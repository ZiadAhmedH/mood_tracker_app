import 'dart:async';
import 'dart:isolate';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodtracker_app/features/emotion_detection/data/services/face_emotaion_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageCaptureService {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  Isolate? _isolate;
  SendPort? _sendPort;
  final ReceivePort _receivePort = ReceivePort();
  Completer<String?>? _predictionCompleter;

  CameraController? get cameraController => _cameraController;
  bool get isCameraInitialized => _cameraController?.value.isInitialized ?? false;

  Future<bool> initCamera() async {
    final permission = await Permission.camera.request();
    if (!permission.isGranted) return false;

    try {
      _cameras = await availableCameras();
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();

      await _initIsolate();
      return true;
    } catch (e) {
      print('❌ Camera init failed: $e');
      return false;
    }
  }

  Future<void> _initIsolate() async {
    try {
      final rootIsolateToken = RootIsolateToken.instance;

      _isolate = await Isolate.spawn(
        _isolateEntry,
        _IsolateData(_receivePort.sendPort, rootIsolateToken),
      );

      _receivePort.listen((message) {
        if (message is SendPort) {
          _sendPort = message;
        } else if (message is String && _predictionCompleter != null) {
          _predictionCompleter!.complete(message);
          _predictionCompleter = null;
        }
      });
    } catch (e) {
      print('❌ Isolate init failed: $e');
    }
  }

  static void _isolateEntry(_IsolateData data) async {
    final isolateReceivePort = ReceivePort();
    data.mainSendPort.send(isolateReceivePort.sendPort);

    if (data.rootIsolateToken != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(data.rootIsolateToken!);
    }

    isolateReceivePort.listen((message) async {
      if (message is List && message.length == 2 && message[0] is Uint8List) {
        final imageBytes = message[0] as Uint8List;
        final responsePort = message[1] as SendPort;

        try {
          final tempFile = File('${Directory.systemTemp.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await tempFile.writeAsBytes(imageBytes);

          final grayFile = await _convertToGrayscale(tempFile);

          final result = await EmotionModelService.runModelOnImage(grayFile);
          final prediction = result != null && result.isNotEmpty
              ? result[0]["label"]
              : "Could not detect emotion";

          if (await tempFile.exists()) await tempFile.delete();
          if (await grayFile.exists()) await grayFile.delete();

          responsePort.send(prediction);
        } catch (e) {
          print('❌ Isolate error: $e');
          responsePort.send("Error processing image");
        }
      }
    });
  }

  static Future<File> _convertToGrayscale(File originalFile) async {
    final bytes = await originalFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw Exception("Failed to decode image");

    final grayscale = img.grayscale(decoded);
    final resized = img.copyResize(grayscale, width: 64, height: 64);
    final tempPath = '${Directory.systemTemp.path}/gray_input_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final grayscaleFile = File(tempPath)..writeAsBytesSync(img.encodeJpg(resized));

    return grayscaleFile;
  }

  Future<void> disposeCamera() async {
    await _cameraController?.dispose();
    _cameraController = null;
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort.close();
  }

  Future<XFile?> takePicture() async {
    if (!isCameraInitialized) return null;

    try {
      return await _cameraController!.takePicture();
    } catch (e) {
      print('❌ Take picture error: $e');
      return null;
    }
  }

  Future<XFile?> pickImageFromGallery() async {
    try {
      return await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (e) {
      print('❌ Gallery pick error: $e');
      return null;
    }
  }

  Future<String?> processImage(File image) async {
    if (_sendPort == null) {
      print('⚠️ Isolate not ready. Processing on main thread...');
      try {
        final grayFile = await _convertToGrayscale(image);
        final result = await EmotionModelService.runModelOnImage(grayFile);
        return result != null && result.isNotEmpty
            ? result[0]["label"]
            : "Could not detect emotion";
      } catch (e) {
        print('❌ Main thread error: $e');
        return "Error processing image";
      }
    }

    try {
      _predictionCompleter = Completer<String?>();
      final bytes = await image.readAsBytes();
      _sendPort!.send([bytes, _receivePort.sendPort]);

      return await _predictionCompleter!.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () => "Processing timeout",
      );
    } catch (e) {
      print('❌ Image processing error: $e');
      return "Error processing image";
    }
  }
}

class _IsolateData {
  final SendPort mainSendPort;
  final RootIsolateToken? rootIsolateToken;

  _IsolateData(this.mainSendPort, this.rootIsolateToken);
}

import 'dart:io';
import 'package:moodtracker_app/core/constants/logo_assets.dart';
import 'package:tflite_v2/tflite_v2.dart';

class EmotionModelService {
  static Future<void> loadModel() async {
    try {
      String? result = await Tflite.loadModel(
        model: Assets.assetsModelsEmotionModelRgb, 
        labels: Assets.assetsModelsLabels,    
      );
      print("✅ Model loaded: $result");
    } catch (e) {
      print("❌ Model load failed: $e");
    }
  }

  static Future<List?> runModelOnImage(File image) async {
    try {
      final result = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,
        threshold: 0.0,
        imageMean: 0.0,
        imageStd: 255.0,
        asynch: true,
      );
      print("🧪 Model output: $result");
      return result;
    } catch (e) {
      print("❌ Error running model: $e");
      return null;
    }
  }

  static Future<void> disposeModel() async {
    await Tflite.close();
  }
}

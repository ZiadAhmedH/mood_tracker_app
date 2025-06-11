import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class EmotionTextService {
  late Interpreter _interpreter;
  late Map<String, int> _vocab;
  final int _features = 5000;

  final List<String> _labels = [
    'anger', 'disgust', 'fear', 'joy', 'neutral', 'sadness', 'surprise'
  ];

  Future<void> init() async {
    _interpreter = await Interpreter.fromAsset("assets/models/text/emotion_model_text.tflite");
    final vocabJson = await rootBundle.loadString("assets/models/text/vocab.json");
    final Map<String, dynamic> jsonMap = jsonDecode(vocabJson);
    _vocab = jsonMap.map((key, value) => MapEntry(key, value as int));
  }

  Future<String?> predictEmotion(String text) async {
    if (text.trim().isEmpty) return null;

    final inputShape = _interpreter.getInputTensor(0).shape;
    final outputShape = _interpreter.getOutputTensor(0).shape;

    final input = [_vectorizeText(text)];
    final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
        .reshape([outputShape[0], outputShape[1]]);

    _interpreter.run(input, output);

    final predictedIndex = _argMax(output[0]);
    return _labels[predictedIndex];
  }

  List<double> _vectorizeText(String text) {
    List<double> vector = List.filled(_features, 0.0);
    final processedText = _preprocessText(text);
    final words = processedText.split(' ').where((w) => w.isNotEmpty).toList();

    final ngrams = <String>[];
    for (int i = 0; i < words.length; i++) {
      ngrams.add(words[i]);
      if (i < words.length - 1) ngrams.add('${words[i]} ${words[i+1]}');
      if (i < words.length - 2) ngrams.add('${words[i]} ${words[i+1]} ${words[i+2]}');
    }

    for (var ngram in ngrams) {
      final index = _vocab[ngram];
      if (index != null && index < _features) vector[index] += 1.0;
    }

    return vector;
  }

  int _argMax(List<double> list) {
    int maxIndex = 0;
    for (int i = 1; i < list.length; i++) {
      if (list[i] > list[maxIndex]) maxIndex = i;
    }
    return maxIndex;
  }

  String _preprocessText(String text) {
    text = text.toLowerCase();
    text = text.replaceAll(RegExp(r'[^a-zA-Z\s]'), ' ');
    final stopwords = {
      'i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'your',
      'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she',
      'her', 'hers', 'herself', 'it', 'its', 'itself', 'they', 'them', 'their',
      'theirs', 'themselves', 'what', 'which', 'who', 'whom', 'this', 'that',
      'these', 'those', 'am', 'is', 'are', 'was', 'were', 'be', 'been', 'being',
      'have', 'has', 'had', 'having', 'do', 'does', 'did', 'doing', 'a', 'an',
      'the', 'and', 'but', 'if', 'or', 'because', 'as', 'until', 'while', 'of',
      'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into', 'through',
      'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down',
      'in', 'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then',
      'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'any',
      'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor',
      'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 's', 't', 'can',
      'will', 'just', 'don', 'should', 'now'
    };
    final words = text.split(' ').where((word) =>
      word.isNotEmpty && !stopwords.contains(word));
    return words.map((word) => _simpleStem(word)).join(' ');
  }

  String _simpleStem(String word) {
    if (word.endsWith('ing')) return word.substring(0, word.length - 3);
    if (word.endsWith('ly')) return word.substring(0, word.length - 2);
    if (word.endsWith('ed')) return word.substring(0, word.length - 2);
    return word;
  }

  void dispose() {
    _interpreter.close();
  }
}

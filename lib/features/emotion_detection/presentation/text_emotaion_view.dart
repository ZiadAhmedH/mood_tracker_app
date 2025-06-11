import 'package:flutter/material.dart';
import 'package:moodtracker_app/features/emotion_detection/data/services/emotion_text_service.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/feeling_selection_screen.dart';

class EmotionTextView extends StatefulWidget {
  static const String routeName = '/emotionTextView';
  const EmotionTextView({super.key});

  @override
  _EmotionTextDetectionScreenState createState() =>
      _EmotionTextDetectionScreenState();
}

class _EmotionTextDetectionScreenState extends State<EmotionTextView> {
  final TextEditingController _controller = TextEditingController();
  final EmotionTextService _emotionService = EmotionTextService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emotionService.init();
  }

  @override
  void dispose() {
    _emotionService.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _analyzeText() async {
    setState(() => _isLoading = true);

    // Simulate loading for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    final emotion = await _emotionService.predictEmotion(_controller.text);
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (emotion != null) {
      Navigator.pushNamed(
        context,
        FeelingView.routeName,
        arguments: {'userFeeling': emotion},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to analyze text')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Write what do you feel',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 194,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _controller,
                enabled: !_isLoading,
                maxLines: 6,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Write what do you feel ....',
                  border: InputBorder.none,
                  counterText: "",
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_controller.text.length} / 500',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyzeText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9616FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _isLoading
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Analyze',
                          key: ValueKey('analyzeText'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

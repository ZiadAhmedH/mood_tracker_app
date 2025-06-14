import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

class MeditationStep {
  final String text;
  final String animationPath;
  final String? audioPath;

  MeditationStep(
      {required this.text, required this.animationPath, this.audioPath});
}

class GuidedMeditationScreen extends StatefulWidget {
  @override
  _GuidedMeditationScreenState createState() => _GuidedMeditationScreenState();
}

class _GuidedMeditationScreenState extends State<GuidedMeditationScreen> {
  final PageController _pageController = PageController();
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;

  final List<MeditationStep> steps = [
    MeditationStep(
      text: 'اجلس في مكان هادئ وخذ نفسًا عميقًا...',
      animationPath: 'assets/animations/meditation.json',
      audioPath: 'assets/audio/steps.mp3',
    ),
    MeditationStep(
      text: 'ركز على تنفسك واشعر بالهواء وهو يدخل ويخرج.',
      animationPath: 'assets/animations/meditation.json',
      audioPath: 'assets/audio/steps.mp3',
    ),
    MeditationStep(
      text: 'تخيل ضوءًا دافئًا يملأ جسدك من الرأس للقدم.',
      animationPath: 'assets/animations/meditation.json',
      audioPath: 'assets/audio/steps.mp3',
    ),
    MeditationStep(
      text: 'ابقَ في هذه الحالة من السكون لدقائق.',
      animationPath: 'assets/animations/meditation.json',
      audioPath: 'assets/audio/steps.mp3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    final currentStep = steps[_currentIndex];
    if (currentStep.audioPath != null) {
      await _audioPlayer.setAsset(currentStep.audioPath!);
    }
  }

  void _playPauseAudio() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _onPageChanged(int index) async {
    setState(() {
      _currentIndex = index;
    });
    await _audioPlayer.stop();
    await _loadAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = steps[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('التأمل الموجّه'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: steps.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final step = steps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        step.animationPath,
                        width: 250,
                        height: 250,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        step.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _playPauseAudio,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('تشغيل / إيقاف الصوت'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(steps.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: index == _currentIndex ? Colors.indigo : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

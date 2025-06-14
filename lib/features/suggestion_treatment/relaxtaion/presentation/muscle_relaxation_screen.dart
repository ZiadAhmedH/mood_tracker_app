import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

class ExerciseStep {
  final String text;
  final String animationPath;
  final String? audioPath;

  ExerciseStep(
      {required this.text, required this.animationPath, this.audioPath});
}

class MuscleRelaxationScreen extends StatefulWidget {
  @override
  _MuscleRelaxationScreenState createState() => _MuscleRelaxationScreenState();
}

class _MuscleRelaxationScreenState extends State<MuscleRelaxationScreen> {
  final PageController _pageController = PageController();
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;

  final List<ExerciseStep> steps = [
    ExerciseStep(
      text: 'ابدأ بشد عضلات القدم بلطف لمدة 5 ثوان.',
      animationPath: 'assets/animations/muscle_relaxation.json',
      audioPath: 'assets/audio/step.mp3',
    ),
    ExerciseStep(
      text: 'ثم استرخي واشعر بالراحة في ساقك.',
      animationPath: 'assets/animations/muscle_relaxation.json',
      audioPath: 'assets/audio/step.mp3',
    ),
    ExerciseStep(
      text: 'كرر العملية مع الرقبة والكتفين بهدوء.',
      animationPath: 'assets/animations/muscle_relaxation.json',
      audioPath: 'assets/audio/step.mp3',
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
        title: Text('تمرين استرخاء العضلات'),
        backgroundColor: Colors.purple,
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
                      SizedBox(height: 20),
                      Text(
                        step.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _playPauseAudio,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: Text('تشغيل / إيقاف الصوت'),
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
                  color: index == _currentIndex ? Colors.purple : Colors.grey,
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

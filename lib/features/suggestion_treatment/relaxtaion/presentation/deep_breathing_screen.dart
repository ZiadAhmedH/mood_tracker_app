import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DeepBreathingScreen extends StatefulWidget {
  @override
  _DeepBreathingScreenState createState() => _DeepBreathingScreenState();
}

class _DeepBreathingScreenState extends State<DeepBreathingScreen> {
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<String> images = [
    'assets/images/image4.png',
    'assets/images/image4.png',
    'assets/images/image4.png',
    'assets/images/image4.png',
  ];
  final List<String> audioFiles = [
    'audio/breathing.mp3',
    'audio/breathing.mp3',
    'audio/breathing.mp3',
    'audio/breathing.mp3',
  ];
  final List<String> stepTitles = [
    'Step 1: Sit in a comfortable position and relax.',
    'Step 2: Take a deep breath in through your nose.',
    'Step 3: Hold your breath for a few seconds.',
    'Step 4: Slowly exhale through your mouth.',
  ];
  final List<String> stepDescriptions = [
    'Sit or lie down in a comfortable position.\nPlace one hand on your chest and the other on your stomach.\nTake a deep breath in through your nose for 4 seconds, focusing on filling your belly with air (not your chest).\nHold your breath for 4 seconds.\nSlowly exhale through your mouth for 6 seconds.\nRepeat these steps for 5-10 minutes.',
    'Place one hand on your chest and the other on your stomach.\nTake a deep breath in through your nose for 4 seconds, focusing on filling your belly with air (not your chest).\nHold your breath for 4 seconds.\nSlowly exhale through your mouth for 6 seconds.\nRepeat these steps for 5-10 minutes.',
    'Take a deep breath in through your nose for 4 seconds, focusing on filling your belly with air (not your chest).\nHold your breath for 4 seconds.\nSlowly exhale through your mouth for 6 seconds.\nRepeat these steps for 5-10 minutes.',
    'Hold your breath for 4 seconds.\nSlowly exhale through your mouth for 6 seconds.\nRepeat these steps for 5-10 minutes.',
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setAsset(audioFiles[_currentIndex]);
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextStep() {
    if (_currentIndex < stepTitles.length - 1) {
      setState(() {
        _currentIndex++;
        _isPlaying = false;
      });
      _audioPlayer.stop();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStep() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isPlaying = false;
      });
      _audioPlayer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Exercise Page', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(images[_currentIndex], height: 250),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      stepTitles[_currentIndex],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          stepDescriptions[_currentIndex],
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 50,
                      color: Colors.purple,
                    ),
                    onPressed: _toggleAudio,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value:
                          _duration.inSeconds == 0
                              ? 0
                              : _position.inSeconds / _duration.inSeconds,
                      backgroundColor: Colors.purple.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  ElevatedButton(onPressed: _previousStep, child: Text('Back')),
                ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(
                    _currentIndex < stepTitles.length - 1 ? 'Next' : 'Finish',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

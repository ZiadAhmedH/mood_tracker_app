import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/features/home/Presentation/main_view.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_state.dart';

class RateMoodBodyView extends StatelessWidget {
  final String userFeeling;

  const RateMoodBodyView({super.key, required this.userFeeling});

  final List<String> moods = const ['Worst', 'Poor', 'Fair', 'Good', 'Excellent'];
  final List<Color> colors = const [
    Colors.red,
    Colors.orange,
    Colors.grey,
    Colors.yellow,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> sliderValue = ValueNotifier<double>(2);

    return BlocConsumer<MoodStatsCubit, MoodStatsState>(
      listener: (context, state) {
        if (state is MoodStatsSaved) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            MainView.routeName,
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is MoodStatsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is MoodStatsSaving;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                "How would you rate your new mood?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        moods.length,
                        (index) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              moods[moods.length - 1 - index],
                              style: const TextStyle(fontSize: 16),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: colors[moods.length - 1 - index],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ValueListenableBuilder<double>(
                      valueListenable: sliderValue,
                      builder: (context, value, _) {
                        return RotatedBox(
                          quarterTurns: -1,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 14,
                              activeTrackColor: colors[value.round()],
                              inactiveTrackColor: Colors.grey[300],
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 14,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 24,
                              ),
                            ),
                            child: Slider(
                              value: value,
                              min: 0,
                              max: 4,
                              divisions: 4,
                              onChanged: (val) => sliderValue.value = val,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<MoodStatsCubit>().saveMood(
                              mood: userFeeling,
                              createdAt: DateTime.now(),
                            );
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Done",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); 
                },
                child: Text(
                  "Choose Another Treatment",
                  style: TextStyle(color: AppColors.primary, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

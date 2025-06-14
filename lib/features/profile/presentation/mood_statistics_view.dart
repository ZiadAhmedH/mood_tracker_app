import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import 'package:moodtracker_app/features/profile/presentation/widgets/mood_statistics_body_view.dart';

class MoodStatisticsView extends StatelessWidget {
  static const String routeName = '/mood-statistics';

  const MoodStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MoodStatsCubit>(
      create: (_) {
        final cubit = GetIt.I<MoodStatsCubit>();
        cubit.loadStats();
        return cubit;
      },
      child: const _MoodStatisticsScaffold(),
    );
  }
}

class _MoodStatisticsScaffold extends StatefulWidget {
  const _MoodStatisticsScaffold();

  @override
  State<_MoodStatisticsScaffold> createState() => _MoodStatisticsScaffoldState();
}

class _MoodStatisticsScaffoldState extends State<_MoodStatisticsScaffold> {
  String _selectedPeriod = 'weekly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: CustomText(text: "Mood Statistics", color: AppColors.graylight, fontSize: 16, fontWeight: FontWeight.w600),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: MoodStatisticsBodyView(
          key: ValueKey(_selectedPeriod),
          period: _selectedPeriod,
          onPeriodChange: (newPeriod) => setState(() => _selectedPeriod = newPeriod),
        ),
      ),
    );
  }
}

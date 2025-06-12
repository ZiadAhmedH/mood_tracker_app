import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
  String _selectedPeriod = 'daily';
  final List<String> _periods = ['daily', 'weekly', 'monthly', 'yearly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Statistics'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _periods.length,
              itemBuilder: (context, index) {
                final period = _periods[index];
                final selected = period == _selectedPeriod;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(period.toUpperCase()),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _selectedPeriod = period);
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: MoodStatisticsBodyView(period: _selectedPeriod),
          ),
        ],
      ),
    );
  }
}

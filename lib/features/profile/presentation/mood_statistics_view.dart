import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import 'package:moodtracker_app/features/profile/presentation/widgets/mood_statistics_body_view.dart';

class MoodStatisticsView extends StatelessWidget {
  static const String routeName = '/mood-statistics';
  static const _primaryColor = Color(0xFF9616FF);

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: MoodStatisticsView._primaryColor,
        title: const Text('Mood Statistics'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _periods.map((period) {
                final selected = period == _selectedPeriod;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = period),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? MoodStatisticsView._primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          period.toUpperCase(),
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: MoodStatisticsBodyView(key: ValueKey(_selectedPeriod), period: _selectedPeriod,),
            ),
          ),
        ],
      ),
    );
  }
}

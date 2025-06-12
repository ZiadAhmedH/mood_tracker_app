import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import 'package:moodtracker_app/features/profile/domain/entities/mod_stat.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_state.dart';

class MoodStatisticsBodyView extends StatelessWidget {
  final String period; // 'daily', 'weekly', 'monthly', 'yearly'

  const MoodStatisticsBodyView({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodStatsCubit, MoodStatsState>(
      builder: (context, state) {
        if (state is MoodStatsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MoodStatsError) {
          return Center(child: Text(state.message));
        } else if (state is MoodStatsLoaded) {
          final List<MoodStat> data = _getStatsByPeriod(state);
          if (data.isEmpty) {
            return const Center(child: Text("No data available."));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();
                        if (index < data.length) {
                          return Text(data[index].mood);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final MoodStat stat = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: stat.count.toDouble(),
                        color: Colors.blueAccent,
                        width: 18,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  List<MoodStat> _getStatsByPeriod(MoodStatsLoaded state) {
    switch (period) {
      case 'daily':
        return state.dailyStats;
      case 'weekly':
        return state.weeklyStats;
      case 'monthly':
        return state.monthlyStats;
      case 'yearly':
        return state.yearlyStats;
      default:
        return [];
    }
  }
}

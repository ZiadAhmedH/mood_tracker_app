import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import 'package:moodtracker_app/features/profile/domain/entities/mod_stat.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_state.dart';

class MoodStatisticsBodyView extends StatelessWidget {
  final String period;

  const MoodStatisticsBodyView({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodStatsCubit, MoodStatsState>(
      builder: (context, state) {
        if (state is MoodStatsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MoodStatsError) {
          return _buildMessage(context, state.message, isError: true);
        }

        if (state is MoodStatsLoaded) {
          final List<MoodStat> data = _getStatsByPeriod(state);
          if (data.isEmpty) {
            return _buildMessage(context, "No mood data found for $period.");
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(data),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();
                        if (index < data.length) {
                          return Text(
                            data[index].mood,
                            style: const TextStyle(fontSize: 12),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
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
                        borderRadius: BorderRadius.circular(6),
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

  double _getMaxY(List<MoodStat> stats) {
    final max = stats.map((s) => s.count).fold<int>(0, (a, b) => a > b ? a : b);
    return max < 5 ? 5 : max.toDouble();
  }

  Widget _buildMessage(BuildContext context, String message, {bool isError = false}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.insert_chart_outlined,
              color: isError ? Colors.red : Colors.grey,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isError ? Colors.red : Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

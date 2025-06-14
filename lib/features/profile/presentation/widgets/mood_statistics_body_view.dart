import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/features/profile/domain/entities/mod_stat.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_state.dart';

class MoodStatisticsBodyView extends StatelessWidget {
  final String period;
  final void Function(String) onPeriodChange;

  const MoodStatisticsBodyView({
    super.key,
    required this.period,
    required this.onPeriodChange,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodStatsCubit, MoodStatsState>(
      builder: (context, state) {
        if (state is MoodStatsLoading) return const Center(child: CircularProgressIndicator());
        if (state is MoodStatsError) return _errorCard(state.message);
        if (state is MoodStatsLoaded) {
          final data = _getStats(state);
          if (data.isEmpty) return _errorCard("No mood data for $period.");

          final moodCount = <String, int>{};
          for (var stat in data) {
            moodCount[stat.mood] = (moodCount[stat.mood] ?? 0) + stat.count;
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ListView(
              key: ValueKey(period),
              padding: const EdgeInsets.all(16),
              children: [
                _lastVisitCard(data),
                const SizedBox(height: 16),
                _periodSelector(),
                const SizedBox(height: 16),
                _thisWeekCard(moodCount),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _lastVisitCard(List<MoodStat> stats) {
    final spots = stats.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.count.toDouble());
    }).toList();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Visit\nStatistics ...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          if (stats.isNotEmpty)
            Text(
              'Updated: ${_formatDate(stats.last.createdAt)}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: spots.isNotEmpty 
                      ? (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) / 4)
                      : 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                      dashArray: [3, 3],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < stats.length && index % 2 == 0) {
                          return Text(
                            _formatDate(stats[index].createdAt),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 8,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.red,
                          strokeWidth: 0,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                minX: 0,
                maxX: (spots.length - 1).toDouble(),
                minY: 0,
                maxY: spots.isNotEmpty 
                    ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1
                    : 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodSelector() {
    const periods = ['This Week', 'This Month', 'This Year'];
    final periodKeys = ['weekly', 'monthly', 'yearly'];
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final selected = periodKeys[index] == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPeriodChange(periodKeys[index]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: selected ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    periods[index],
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.grey[600],
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _thisWeekCard(Map<String, int> moodCount) {
    final moods = moodCount.keys.toList();
    final maxValue = moodCount.values.isNotEmpty 
        ? moodCount.values.reduce((a, b) => a > b ? a : b).toDouble() + 2
        : 10;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week\nStatistics ..',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                      dashArray: [3, 3],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        final labels = ['Worst', 'Poor', 'Fair', 'Good', 'Excellent'];
                        final step = maxValue / 5;
                        final index = (value / step).round();
                        if (index >= 0 && index < labels.length) {
                          return Text(
                            labels[index],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < moods.length) {
                          return Text(
                            moods[index],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: moods.asMap().entries.map((entry) {
                  final mood = entry.value;
                  final count = moodCount[mood]!.toDouble();
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: count,
                        color: _moodColor(mood),
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 600),
              swapAnimationCurve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Color _moodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.yellow[700]!;
      case 'sad':
        return Colors.blue[300]!;
      case 'angry':
        return Colors.red[300]!;
      case 'neutral':
        return Colors.grey[400]!;
      case 'fear':
        return Colors.purple[300]!;
      case 'surprise':
        return Colors.orange[300]!;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month.toString().padLeft(2, '0')}';
  }

  List<MoodStat> _getStats(MoodStatsLoaded state) {
    return switch (period) {
      'weekly' => state.weeklyStats,
      'monthly' => state.monthlyStats,
      'yearly' => state.yearlyStats,
      _ => [],
    };
  }
}
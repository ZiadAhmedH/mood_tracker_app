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
          return _buildErrorCard(state.message);
        }

        if (state is MoodStatsLoaded) {
          final data = _getStatsByPeriod(state);
          if (data.isEmpty) {
            return _buildErrorCard("No mood data found for $period.");
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                if (period == 'weekly') _buildLastVisitCard(data),
                _buildStatsChart(data),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLastVisitCard(List<MoodStat> data) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last Visit\nStatistics...',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.take(7).toList().asMap().entries.map(
                      (entry) => FlSpot(entry.key.toDouble(), entry.value.count.toDouble())
                    ).toList(),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
                lineTouchData: LineTouchData(enabled: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsChart(List<MoodStat> data) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${period[0].toUpperCase()}${period.substring(1)}\nStatistics..',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ['Excellent', 'Good', 'Fair', 'Poor', 'Worst']
                      .map((label) => Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)))
                      .toList(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 240,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(data),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => Colors.black87,
                          getTooltipItem: (group, _, rod, __) {
                            final mood = data[group.x.toInt()].mood;
                            return BarTooltipItem(
                              '$mood: ${rod.toY.toInt()}',
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();
                              if (index < data.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    _getBottomLabel(data[index]),
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withOpacity(0.3),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: data.asMap().entries.map((entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.count.toDouble(),
                            width: 16,
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF6C5CE7),
                          ),
                        ],
                      )).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_chart_outlined, color: Colors.grey, size: 48),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  double _getMaxY(List<MoodStat> data) {
    final max = data.map((s) => s.count).fold<int>(0, (a, b) => a > b ? a : b);
    return (max < 5 ? 5 : max + 1).toDouble();
  }

  String _getBottomLabel(MoodStat stat) {
    switch (period) {
      case 'weekly':
        const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return labels[(stat.createdAt.weekday - 1) % 7];
      case 'daily':
        final hour = stat.createdAt.hour;
        if (hour < 6) return 'Night';
        if (hour < 12) return 'Morning';
        if (hour < 18) return 'Afternoon';
        return 'Evening';
      case 'monthly':
        return '${stat.createdAt.day}/${stat.createdAt.month}';
      case 'yearly':
        return '${stat.createdAt.month}';
      default:
        return stat.mood;
    }
  }

  List<MoodStat> _getStatsByPeriod(MoodStatsLoaded state) {
    switch (period) {
      case 'daily': return state.dailyStats;
      case 'weekly': return state.weeklyStats;
      case 'monthly': return state.monthlyStats;
      case 'yearly': return state.yearlyStats;
      default: return [];
    }
  }
}
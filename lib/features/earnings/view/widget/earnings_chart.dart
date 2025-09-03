import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/cubit/earnings_cubit.dart';

class EarningsChart extends StatelessWidget {
  final List<MonthlyEarning> monthlyEarnings;
  const EarningsChart({super.key, required this.monthlyEarnings});

  @override
  Widget build(BuildContext context) {
    if (monthlyEarnings.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Earnings Trend (Last 6 Months)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(_chartData()),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData() {
    final maxValue = monthlyEarnings.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: (value, _) => Text('₹${value.toInt()}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, _) {
              final index = value.toInt();
              return (index >= 0 && index < monthlyEarnings.length)
                  ? Text(monthlyEarnings[index].month, style: TextStyle(color: Colors.grey.shade600, fontSize: 12))
                  : const Text('');
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (monthlyEarnings.length - 1).toDouble(),
      minY: 0,
      maxY: maxValue * 1.2,
      lineBarsData: [
        LineChartBarData(
          spots: monthlyEarnings.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.amount)).toList(),
          isCurved: true,
          gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade600]),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.blue.shade400.withOpacity(0.3), Colors.blue.shade400.withOpacity(0.1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        )
      ],
    );
  }
}

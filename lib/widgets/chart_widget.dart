import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gold_price_model.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../providers/gold_price_provider.dart';

/// Widget for displaying historical price chart
class PriceChartWidget extends ConsumerStatefulWidget {
  final String currency;

  const PriceChartWidget({
    super.key,
    required this.currency,
  });

  @override
  ConsumerState<PriceChartWidget> createState() => _PriceChartWidgetState();
}

class _PriceChartWidgetState extends ConsumerState<PriceChartWidget> {
  ChartPeriod selectedPeriod = ChartPeriod.days7;
  List<FlSpot> spots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    
    final notifier = ref.read(historicalPriceProvider.notifier);
    await notifier.fetchHistoricalData(
      currency: widget.currency,
      days: selectedPeriod.days,
    );
    
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final historicalData = ref.watch(historicalPriceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Period selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ChartPeriod.values.map((period) {
            final isSelected = selectedPeriod == period;
            return ChoiceChip(
              label: Text(period.label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected && selectedPeriod != period) {
                  setState(() => selectedPeriod = period);
                  _loadData();
                }
              },
              selectedColor: isDarkMode ? Colors.amber : Colors.yellow[700],
              labelStyle: TextStyle(
                color: isSelected
                    ? (isDarkMode ? Colors.black : Colors.white)
                    : (isDarkMode ? Colors.white : Colors.black87),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Chart
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (historicalData.hasError)
          Center(
            child: Text(
              'Failed to load chart data',
              style: TextStyle(color: Colors.red[300]),
            ),
          )
        else if (historicalData.hasValue && historicalData.value!.isEmpty)
          const Center(
            child: Text('No data available'),
          )
        else
          Expanded(
            child: _buildChart(
              historicalData.value ?? [],
              isDarkMode,
            ),
          ),
      ],
    );
  }

  Widget _buildChart(List<HistoricalDataPoint> data, bool isDarkMode) {
    if (data.isEmpty) return const SizedBox.shrink();

    // Prepare data points
    spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price);
    }).toList();

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 10, top: 10, bottom: 30),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: (maxY - minY) / 4,
            verticalInterval: data.length > 1 ? (data.length - 1).toDouble() / 4 : 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    Formatters.formatCurrency(value, widget.currency),
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: data.length > 1 ? (data.length - 1).toDouble() / 4 : 1,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        Formatters.formatShortDate(data[index].date),
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          minX: 0,
          maxX: data.length > 1 ? (data.length - 1).toDouble() : 1,
          minY: minY - padding,
          maxY: maxY + padding,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.2,
              color: Colors.amber,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.amber,
                    strokeWidth: 2,
                    strokeColor: isDarkMode ? Colors.grey[900] : Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.3),
                    Colors.amber.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mini sparkline chart for cards
class SparklineChart extends StatelessWidget {
  final List<double> data;
  final Color color;
  final double height;
  final double width;

  const SparklineChart({
    super.key,
    required this.data,
    this.color = Colors.amber,
    this.height = 40,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;

    // Normalize spots to fit in view
    final normalizedSpots = spots.map((spot) {
      return FlSpot(
        spot.x * (width / (data.length - 1)),
        height - ((spot.y - minY) / range) * height,
      );
    }).toList();

    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(
        painter: SparklinePainter(
          spots: normalizedSpots,
          color: color,
        ),
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<FlSpot> spots;
  final Color color;

  SparklinePainter({required this.spots, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (spots.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(spots.first.x, spots.first.y);

    for (int i = 1; i < spots.length; i++) {
      path.lineTo(spots[i].x, spots[i].y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) {
    return oldDelegate.spots != spots || oldDelegate.color != color;
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _HomeState();
}

class _HomeState extends State<Dashboard> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

  @override
  Widget build(BuildContext context) {

    final List<ChartData> chartData = [
      ChartData('David', 25, Theme.of(context).primaryColor),
      ChartData('Steve', 38, Theme.of(context).colorScheme.secondary),
      ChartData('Jack', 34, Colors.blue),
      ChartData('Others', 52, null)
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: SfCircularChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          title: ChartTitle(text: 'Sales by month'),
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.bottom,
          ),
          series: <CircularSeries>[
            // Render pie chart
            DoughnutSeries<ChartData, String>(
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                dataSource: chartData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y)
          ],
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color? color;
}

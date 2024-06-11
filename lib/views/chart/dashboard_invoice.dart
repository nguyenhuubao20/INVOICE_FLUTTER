import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DashboardInvoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: PieChart(
            dataMap: {
              "Pending": 1000.0,
              "Sent": 2500.0,
              "PendingApproval": 760.0,
              "Completed": 1897.0,
              "Failed": 2987.0,
            },
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            colorList: [
              Colors.orange,
              Colors.red,
              Colors.blue[300]!,
              Colors.green,
              Colors.grey[300]!,
            ],
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            centerText: "Invoice",
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 0,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/saledata.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static dynamic chartData = <SalesData>[
    SalesData('Pending', 1000, Colors.orange),
    SalesData('Sent', 2500, Colors.red),
    SalesData('PendingApproval', 760, Colors.blue[300]!),
    SalesData('Completed', 1897, Colors.green),
    SalesData('Failed', 2987, Colors.grey[300]!)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        body: Column(children: [
          //Initialize the chart widget
          // SfCartesianChart(
          //     primaryXAxis: CategoryAxis(),
          //     // Chart title
          //     title: ChartTitle(text: 'Half yearly sales analysis'),
          //     // Enable legend
          //     legend: Legend(isVisible: true),
          //     // Enable tooltip
          //     tooltipBehavior: TooltipBehavior(enable: true),
          //     series: <CartesianSeries<SalesData, String>>[
          //       LineSeries<SalesData, String>(
          //           dataSource: chartData,
          //           xValueMapper: (SalesData sales, _) => sales.component,
          //           yValueMapper: (SalesData sales, _) => sales.count,
          //           name: 'Sales',
          //           // Enable data label
          //           dataLabelSettings: DataLabelSettings(isVisible: true))
          //     ]),
          Expanded(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    //Initialize the spark charts widget
                    child: SfCircularChart(
                        series: <CircularSeries<SalesData, dynamic>>[
                          // Render pie chart
                          PieSeries<SalesData, String>(
                            dataSource: chartData,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                            emptyPointSettings: EmptyPointSettings(
                                mode: EmptyPointMode.average),
                            pointColorMapper: (SalesData data, _) => data.color,
                            xValueMapper: (SalesData data, _) => data.component,
                            yValueMapper: (SalesData data, _) => data.count,
                          )
                        ])),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Pending'),
                          SizedBox(width: 8),
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Sent'),
                          SizedBox(width: 8),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('PendingApproval'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Completed'),
                          SizedBox(width: 8),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Failed'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}

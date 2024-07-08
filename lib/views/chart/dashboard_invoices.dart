import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/view_models/dashboard_view_model.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../enums/view_status.dart';
import '../../utils/theme.dart';
import '../../widgets/status_card.dart';

class DashboardInvoices extends StatefulWidget {
  const DashboardInvoices({super.key});

  @override
  State<DashboardInvoices> createState() => _DashboardInvoicesState();
}

class _DashboardInvoicesState extends State<DashboardInvoices> {
  late DateTime selectedDate;
  String _selectedKey = 'Yesterday';
  final DashboardViewModel dashboardViewModel = Get.find<DashboardViewModel>();
  Map<String, int> dataRequest = {
    // 'Hôm nay': 1,
    'Yesterday': 2,
    'Last 3 days': 3,
    'Last 5 days': 5,
    'This week': 7,
    // 'Tháng này': 30,
    // 'Quý này': 90,
    // 'Năm nay': 365,
  };

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final vietnam = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(vietnam);
    selectedDate = now;
    dashboardViewModel.getLastRequestDays();
    dashboardViewModel.getInvoiceReportByOrganizationDashBoard();
    dashboardViewModel.getInvoiceReportByOrganization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ScopedModel(
              model: Get.find<DashboardViewModel>(),
              child: ScopedModelDescendant<DashboardViewModel>(
                builder: (context, child, model) {
                  if (model.status == ViewStatus.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (model.status == ViewStatus.Error) {
                    return const Center(child: Text('Failed to load data'));
                  } else if (model.status == ViewStatus.Completed) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 55.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Time',
                                      labelStyle:
                                          TextStyle(color: ThemeColor.black),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: ThemeColor.white,
                                    ),
                                    items: dataRequest.keys.map((String key) {
                                      return DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(key),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedKey = value;
                                          dashboardViewModel.setRequestDays(
                                              dataRequest[value]!);
                                        });
                                      }
                                    },
                                    value: _selectedKey,
                                  ),
                                ),
                                Container(
                                  height: 55.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Status',
                                      labelStyle:
                                          TextStyle(color: ThemeColor.black),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: ThemeColor.white,
                                    ),
                                    items: dataRequest.keys.map((String key) {
                                      return DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(key),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedKey = value;
                                          dashboardViewModel.setRequestDays(
                                              dataRequest[value]!);
                                        });
                                      }
                                    },
                                    value: _selectedKey,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (dashboardViewModel.requestDays > 0)
                                  Row(
                                    children: [
                                      Chip(
                                        label: Text(dashboardViewModel
                                                .requestDays
                                                .toString() +
                                            " days"),
                                        onDeleted: () {
                                          setState(() {
                                            dashboardViewModel
                                                .setRequestDays(1);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                if (dashboardViewModel.requestDays > 0)
                                  Row(
                                    children: [
                                      Chip(
                                        label: Text(dashboardViewModel
                                                .requestDays
                                                .toString() +
                                            " days"),
                                        onDeleted: () {
                                          setState(() {
                                            dashboardViewModel
                                                .setRequestDays(1);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total invoice in ' +
                                      DateFormat('dd-MM-yyyy')
                                          .format(selectedDate) +
                                      ': ${model.invoicetTotalReports?.totalInvoiceReportInDate ?? 0}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Wrap(
                              spacing: 25.0,
                              runSpacing: 25.0,
                              alignment: WrapAlignment.center,
                              children: [
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Success',
                                  value:
                                      model.invoicetTotalReports?.success ?? 0,
                                  color: getBorderColor(1),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Sent',
                                  value: model.invoicetTotalReports?.sent ?? 0,
                                  color: getBorderColor(2),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Completed',
                                  value:
                                      model.invoicetTotalReports?.completed ??
                                          0,
                                  color: getBorderColor(4),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Pending Approval',
                                  value: model.invoicetTotalReports
                                          ?.pendingApproval ??
                                      0,
                                  color: getBorderColor(3),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Pending',
                                  value:
                                      model.invoicetTotalReports?.pending ?? 0,
                                  color: getBorderColor(6),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Retry Pending',
                                  value: model
                                          .invoicetTotalReports?.retryPending ??
                                      0,
                                  color: getBorderColor(7),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Draft',
                                  value: model.invoicetTotalReports?.draft ?? 0,
                                  color: getBorderColor(0),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Failed',
                                  value:
                                      model.invoicetTotalReports?.failed ?? 0,
                                  color: getBorderColor(5),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Replaced',
                                  value:
                                      model.invoicetTotalReports?.replaced ?? 0,
                                  color: getBorderColor(8),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "+invoices in the last" +
                                        " " +
                                        model.requestDays.toString() +
                                        " " +
                                        "days",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            ScopedModel(
                              model: Get.find<DashboardViewModel>(),
                              child: ScopedModelDescendant<DashboardViewModel>(
                                builder: (context, child, model) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Chart(
                                      padding: EdgeInsets.all(8.0),
                                      layers: [
                                        ChartAxisLayer(
                                          settings: ChartAxisSettings(
                                            x: ChartAxisSettingsAxis(
                                              frequency: 1.0,
                                              max: (model.chartData.length - 1)
                                                  .toDouble(),
                                              min: 0,
                                              textStyle: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            y: ChartAxisSettingsAxis(
                                              frequency: 10.0,
                                              max: 50.0,
                                              min: 0.0,
                                              textStyle: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                          labelX: (value) => model
                                              .chartData.keys
                                              .toList()[value.toInt()]!,
                                          labelY: (value) =>
                                              value.toInt().toString(),
                                        ),
                                        ChartLineLayer(
                                          items: List.generate(
                                            model.chartData.length,
                                            (index) => ChartLineDataItem(
                                              value: model.chartData.values
                                                  .toList()[index]!
                                                  .totalInvoiceReportInDate!
                                                  .toDouble(),
                                              x: index.toDouble(),
                                            ),
                                          ),
                                          settings: const ChartLineSettings(
                                            thickness: 2.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text("Failed to load data"));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color getBorderColor(int? status) {
  switch (status) {
    case 0:
      return Colors.grey;
    case 1:
      return Colors.green;
    case 2:
      return Colors.green;
    case 3:
      return Colors.blue;
    case 4:
      return Colors.green;
    case 5:
      return Colors.red;
    case 6:
      return Colors.blue;
    case 7:
      return Colors.blue;
    default:
      return Colors.orange;
  }
}

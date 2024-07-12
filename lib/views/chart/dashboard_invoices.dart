import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/view_models/dashboard_view_model/dashboard_invoices_view_model.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/view_status.dart';
import '../../utils/theme.dart';
import '../../widgets/dashboard/custom_info_box.dart';
import '../../widgets/dashboard/status_card.dart';

class DashboardInvoices extends StatefulWidget {
  const DashboardInvoices({super.key});

  @override
  State<DashboardInvoices> createState() => _DashboardInvoicesState();
}

class _DashboardInvoicesState extends State<DashboardInvoices> {
  final DashboardInvoiceViewModel dashboardViewModel =
      Get.find<DashboardInvoiceViewModel>();
  Map<String, int> dataRequest = {
    'Hôm qua': 2,
    '3 ngày gần nhất': 3,
    '5 ngày gần nhất': 5,
    'Tuần này': 7,
  };

  @override
  void initState() {
    super.initState();
    dashboardViewModel.getLastRequestDays();
    dashboardViewModel.getInvoiceReporPaymenttByOrganizationDashBoard();
    dashboardViewModel.getInvoiceReportByOrganization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ScopedModel(
              model: Get.find<DashboardInvoiceViewModel>(),
              child: ScopedModelDescendant<DashboardInvoiceViewModel>(
                builder: (context, child, model) {
                  if (model.status == ViewStatus.Loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (model.status == ViewStatus.Error) {
                    return const Center(child: Text('Không tải được dữ liệu'));
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Số liệu chi tiết",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 40,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      labelStyle: TextStyle(
                                          color: ThemeColor.black,
                                          fontSize: 14),
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
                                        child: Text(key,
                                            style:
                                                const TextStyle(fontSize: 14)),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        setState(() {
                                          model.selectedKey = value;
                                          model.setRequestDays(
                                              dataRequest[value]!);
                                          model.setSelectedKey(value);
                                        });
                                      }
                                    },
                                    value: model.selectedKey,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    icon: const Icon(Icons.arrow_drop_down,
                                        size: 20),
                                    isDense: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CustomInfoBox(
                                      title: 'Tổng tất cả',
                                      value: model
                                          .invoicetTotalReports!.totalInvoice
                                          .toString(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomInfoBox(
                                      title: 'Tổng trong ngày',
                                      value: model.invoicetTotalReports!
                                          .totalInvoiceReportInDate
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Wrap(
                              spacing: 30.0,
                              runSpacing: 25.0,
                              alignment: WrapAlignment.center,
                              children: [
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Thành công',
                                  value:
                                      model.invoicetTotalReports?.success ?? 0,
                                  color: getBorderColor(1),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Đã gửi',
                                  value: model.invoicetTotalReports?.sent ?? 0,
                                  color: getBorderColor(2),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Hoàn thành',
                                  value:
                                      model.invoicetTotalReports?.completed ??
                                          0,
                                  color: getBorderColor(4),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Chờ phê duyệt',
                                  value: model.invoicetTotalReports
                                          ?.pendingApproval ??
                                      0,
                                  color: getBorderColor(3),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Đang chờ',
                                  value:
                                      model.invoicetTotalReports?.pending ?? 0,
                                  color: getBorderColor(6),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Đang chờ thử lại',
                                  value: model
                                          .invoicetTotalReports?.retryPending ??
                                      0,
                                  color: getBorderColor(7),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Bản nháp',
                                  value: model.invoicetTotalReports?.draft ?? 0,
                                  color: getBorderColor(0),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Thất bại',
                                  value:
                                      model.invoicetTotalReports?.failed ?? 0,
                                  color: getBorderColor(5),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Thay thế',
                                  value:
                                      model.invoicetTotalReports?.replaced ?? 0,
                                  color: getBorderColor(8),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.requestDays.toString() +
                                      " " +
                                      "ngày gần nhất",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            ScopedModel(
                              model: Get.find<DashboardInvoiceViewModel>(),
                              child: ScopedModelDescendant<
                                  DashboardInvoiceViewModel>(
                                builder: (context, child, model) {
                                  if (model.status == ViewStatus.Empty) {
                                    return const Center(
                                      child: Text(
                                        'Không có dữ liệu',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  } else if (model.status ==
                                      ViewStatus.Loading) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (model.status == ViewStatus.Error) {
                                    return const Center(
                                      child: Text(
                                        'Không tải được dữ liệu',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Chart(
                                        padding: EdgeInsets.all(8.0),
                                        layers: [
                                          ChartAxisLayer(
                                            settings: ChartAxisSettings(
                                              x: ChartAxisSettingsAxis(
                                                frequency: 1.0,
                                                max:
                                                    (model.chartData.length - 1)
                                                        .toDouble(),
                                                min: 0,
                                                textStyle: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              y: ChartAxisSettingsAxis(
                                                frequency: (model.maxInvoices +
                                                        model.minInvoices) /
                                                    4,
                                                max: model.maxInvoices,
                                                min: model.minInvoices,
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
                                  }
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

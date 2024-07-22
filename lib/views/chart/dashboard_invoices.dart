import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/view_models/dashboard_view_model/dashboard_invoices_view_model.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/view_status.dart';
import '../../widgets/dashboard/status_card.dart';

class DashboardInvoices extends StatefulWidget {
  const DashboardInvoices({super.key});

  @override
  State<DashboardInvoices> createState() => _DashboardInvoicesState();
}

class _DashboardInvoicesState extends State<DashboardInvoices> {
  final DashboardInvoiceViewModel dashboardViewModel =
      Get.find<DashboardInvoiceViewModel>();
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _fromDate = dashboardViewModel.selectedFromDate;
    _toDate = dashboardViewModel.selectedToDate;
    dashboardViewModel.getInvoicesDashboard();
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          dashboardViewModel.setSelectedFromDate(_fromDate);
        } else {
          _toDate = picked;
          dashboardViewModel.setSelectedToDate(_toDate);
        }
      });
    }
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
                            Column(
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Chọn khoảng thời gian",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          _selectDate(context, true);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 8),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  color: Colors.blue),
                                              SizedBox(width: 8),
                                              Text(
                                                _fromDate == null
                                                    ? 'Từ ngày'
                                                    : DateFormat('dd/MM/yyyy')
                                                        .format(_fromDate!),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 12,
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          _selectDate(context, false);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 8),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  color: Colors.blue),
                                              SizedBox(width: 8),
                                              Text(
                                                _toDate == null
                                                    ? 'Đến ngày'
                                                    : DateFormat('dd/MM/yyyy')
                                                        .format(_toDate!),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            const Row(
                              children: [
                                Text(
                                  "Tổng số hóa đơn theo trạng thái",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Wrap(
                              spacing: 30.0,
                              runSpacing: 25.0,
                              alignment: WrapAlignment.center,
                              children: [
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Thành công',
                                  value: model.totalSuccess.toInt(),
                                  color: getBorderColor(1),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Đã gửi',
                                  value: model.totalSent.toInt(),
                                  color: getBorderColor(2),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Hoàn thành',
                                  value: model.totalCompleted.toInt(),
                                  color: getBorderColor(4),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Chờ phê duyệt',
                                  value: model.totalPendingApproval.toInt(),
                                  color: getBorderColor(3),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Đang chờ',
                                  value: model.totalPending.toInt(),
                                  color: getBorderColor(6),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Đang chờ thử lại',
                                  value: model.totalRetryPending.toInt(),
                                  color: getBorderColor(7),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Bản nháp',
                                  value: model.totalDraft.toInt(),
                                  color: getBorderColor(0),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Thất bại',
                                  value: model.totalFailed.toInt(),
                                  color: getBorderColor(5),
                                ),
                                StatusCard(
                                  width: 100,
                                  height: 100,
                                  title: 'Thay thế',
                                  value: model.totalReplaced.toInt(),
                                  color: getBorderColor(8),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng cộng có ${model.totalInvoiceReportInDate.toInt()} hóa đơn',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                // ConstrainedBox(
                                //   constraints: BoxConstraints(
                                //     maxWidth: 150.0,
                                //   ),
                                //   child: DropdownButton<String>(
                                //     isExpanded: true,
                                //     value: InvoiceStatusListString.isNotEmpty
                                //         ? InvoiceStatusListString[0]
                                //         : null,
                                //     items: InvoiceStatusListString.map(
                                //         (String value) {
                                //       return DropdownMenuItem<String>(
                                //         value: value,
                                //         child: Text(value),
                                //       );
                                //     }).toList(),
                                //     onChanged: (String? newValue) {
                                //       // Xử lý khi thay đổi giá trị
                                //     },
                                //   ),
                                // ),
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
                                    final List<String> dates = model
                                        .dateReportPairs
                                        .map((e) => e.key)
                                        .toList();
                                    final List<double> values = model
                                        .dateReportPairs
                                        .map((e) =>
                                            e.value.totalInvoiceReportInDate
                                                ?.toDouble() ??
                                            0.0)
                                        .toList();
                                    if (values.every((value) => value == 0)) {
                                      return const Center(
                                        child: Text(
                                          'Không có dữ liệu để hiển thị',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }
                                    final int numberOfPoints = dates.length;
                                    final double frequency = numberOfPoints > 5
                                        ? numberOfPoints / 5.0
                                        : 1.0;

                                    final double yMax = values.isNotEmpty
                                        ? values
                                            .where((v) => !v.isNaN)
                                            .reduce((a, b) => a > b ? a : b)
                                        : 1.0;

                                    final double yMin = values.isNotEmpty
                                        ? values
                                            .where((v) => !v.isNaN)
                                            .reduce((a, b) => a < b ? a : b)
                                        : 0.0;

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
                                                frequency: frequency,
                                                max: (numberOfPoints - 1)
                                                    .toDouble(),
                                                min: 0,
                                                textStyle: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              y: ChartAxisSettingsAxis(
                                                frequency: 1,
                                                max: yMax,
                                                min: yMin,
                                                textStyle: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            labelX: (value) {
                                              int index = value.toInt();
                                              return index < dates.length
                                                  ? dates[index]
                                                  : '';
                                            },
                                            labelY: (value) =>
                                                value.toInt().toString(),
                                          ),
                                          ChartLineLayer(
                                            items: List.generate(
                                              numberOfPoints,
                                              (index) => ChartLineDataItem(
                                                value: values[index].isNaN
                                                    ? 0.0
                                                    : values[index],
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

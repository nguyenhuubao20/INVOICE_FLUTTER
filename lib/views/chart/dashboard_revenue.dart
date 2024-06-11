import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../enums/view_status.dart';
import '../../view_models/organization_view_model.dart';
import '../../widgets/status_card.dart';

class DashboardRevenue extends StatefulWidget {
  const DashboardRevenue({super.key});

  @override
  State<DashboardRevenue> createState() => _DashboardRevenueState();
}

class _DashboardRevenueState extends State<DashboardRevenue> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final vietnam = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(vietnam);
    selectedDate = now;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.5),
          //   spreadRadius: 1,
          //   blurRadius: 2,
          //   offset: Offset(0, 2),
          // ),
        ],
      ),
      child: ScopedModel(
        model: Get.find<OrganizationViewModel>(),
        child: ScopedModelDescendant<OrganizationViewModel>(
          builder: (context, child, model) {
            if (model.status == ViewStatus.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (model.status == ViewStatus.Error) {
              return const Center(child: Text('Failed to load data'));
            } else if (model.status == ViewStatus.Completed) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd-MM-yyyy').format(selectedDate),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Total invoice: ${model.invoiceReports?.totalInvoice ?? 0}',
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
                          title: 'Pending',
                          value: model.invoiceReports?.pending ?? 0,
                          color: getBorderColor(0),
                        ),
                        StatusCard(
                          title: 'Sent',
                          value: model.invoiceReports?.sent ?? 0,
                          color: getBorderColor(1),
                        ),
                        StatusCard(
                          title: 'Pending Approval',
                          value: model.invoiceReports?.pendingApproval ?? 0,
                          color: getBorderColor(2),
                        ),
                        StatusCard(
                          title: 'Completed',
                          value: model.invoiceReports?.completed ?? 0,
                          color: getBorderColor(2),
                        ),
                        StatusCard(
                          title: 'Failed',
                          value: model.invoiceReports?.failed ?? 0,
                          color: getBorderColor(4),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("Failed to load data"));
            }
          },
        ),
      ),
    );
  }
}

Color getBorderColor(int? status) {
  switch (status) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.red;
    case 2:
      return Colors.green;
    case 3:
      return Colors.white;
    default:
      return Colors.grey;
  }
}

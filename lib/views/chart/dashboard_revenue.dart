import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../enums/view_status.dart';
import '../../view_models/organization_view_model.dart';

class DashboardRevenue extends StatefulWidget {
  @override
  State<DashboardRevenue> createState() => _DashboardRevenueState();
}

class _DashboardRevenueState extends State<DashboardRevenue> {
  late DateTime selectedDate;
  final OrganizationViewModel organizationViewModel =
      Get.find<OrganizationViewModel>();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final vietnam = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(vietnam);
    selectedDate = now;
    organizationViewModel.getInvoicePaymentReportByOrganization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
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
                              'Total amount: ${model.invoicePaymentReport?.totalAmountReport ?? 0}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('dd-MM-yyyy').format(selectedDate),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[500],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null && picked != selectedDate) {
                                  setState(() {
                                    selectedDate = picked;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [],
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          )),
          SliverToBoxAdapter(),
        ],
      ),
    );
  }
}

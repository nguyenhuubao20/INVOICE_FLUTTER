import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/view_models/invoice_view_model.dart';

import 'dashboard_invoices.dart';
import 'dashboard_revenue.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final InvoiceViewModel _invoiceViewModel = Get.find<InvoiceViewModel>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: MediaQuery.of(context).size * 0.13,
          child: AppBar(
            backgroundColor: Color(0xff549FFD),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _invoiceViewModel.selectedStoreNameStr ?? 'Tổng quan',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
              tabs: [
                Tab(
                    text: 'Số lượng hóa đơn',
                    icon: Icon(Icons.article_outlined)),
                Tab(text: 'Số tiền giao dịch', icon: Icon(Icons.money_off)),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            DashboardInvoices(),
            DashboardRevenue(),
          ],
        ),
      ),
    );
  }
}

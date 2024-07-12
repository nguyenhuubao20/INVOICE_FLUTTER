import 'package:flutter/material.dart';

import 'dashboard_invoices.dart';
import 'dashboard_revenue.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Thống Kê'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Số lượng hóa đơn'),
              Tab(text: 'Số tiền giao dịch'),
            ],
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

import 'package:flutter/material.dart';

import 'dashboard_invoice.dart';
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
          title: Text('Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Invoice'),
              Tab(text: 'Revenue'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DashboardInvoice(),
            DashboardRevenue(),
          ],
        ),
      ),
    );
  }
}

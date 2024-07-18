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
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: MediaQuery.of(context).size * 0.1,
          child: AppBar(
            backgroundColor: Color(0xff549FFD),
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

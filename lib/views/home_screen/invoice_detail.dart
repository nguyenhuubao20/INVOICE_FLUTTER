import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/utils/theme.dart';
import 'package:invoice/views/invoice/invoice_detail_pdf.dart';
import 'package:invoice/views/invoice/preview_invoice_detail.dart';

class InvoiceDetailPage extends StatefulWidget {
  final String invoiceId;

  const InvoiceDetailPage({Key? key, required this.invoiceId})
      : super(key: key);

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            margin: const EdgeInsets.only(left: 10),
            child: InkWell(
              child: Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 10),
                  Text('Home', style: TextStyle(fontSize: 20)),
                ],
              ),
              onTap: () {
                Get.back();
              },
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.visibility), text: 'Chi tiết'),
              Tab(icon: Icon(Icons.picture_as_pdf), text: 'PDF'),
            ],
            labelColor: ThemeColor.primary,
            indicatorColor: ThemeColor.primary,
          ),
        ),
        body: TabBarView(
          children: [
            PreviewInvoiceDetail(invoiceId: widget.invoiceId),
            MyApp(),
          ],
        ),
      ),
    );
  }
}

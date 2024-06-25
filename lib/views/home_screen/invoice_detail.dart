import 'package:flutter/material.dart';
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
          title: Text('Invoice Detail'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.visibility), text: 'Preview'),
              Tab(icon: Icon(Icons.picture_as_pdf), text: 'PDF'),
            ],
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

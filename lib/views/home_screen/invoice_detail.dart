import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/utils/theme.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/invoice.dart';

class InvoiceDetail extends StatefulWidget {
  final String invoiceId;
  const InvoiceDetail({super.key, required this.invoiceId});

  @override
  State<InvoiceDetail> createState() => _InvoiceDetailState();
}

class _InvoiceDetailState extends State<InvoiceDetail> {
  Invoice? invoice;

  @override
  void initState() {
    super.initState();
    invoice =
        Get.find<InvoiceViewModel>().getInvoiceDetailSync(widget.invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<InvoiceViewModel>(
      model: Get.find<InvoiceViewModel>(),
      child: ScopedModelDescendant<InvoiceViewModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Invoice Detail'),
              backgroundColor: ThemeColor.primary,
            ),
            body: model.status == ViewStatus.Loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : model.status == ViewStatus.Error
                    ? Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child:
                              Text(model.msg ?? 'Error loading invoice detail'),
                        ),
                      )
                    : invoice != null
                        ? Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.white,
                            ),
                            child: ListView(
                              children: [
                                ListTile(
                                  title: Text('Invoice ID'),
                                  subtitle: Text(invoice!.id ?? ''),
                                ),
                              ],
                            ),
                          )
                        : Container(),
          );
        },
      ),
    );
  }
}

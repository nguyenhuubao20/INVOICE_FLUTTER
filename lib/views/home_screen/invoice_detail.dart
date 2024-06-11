import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/utils/theme.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/invoice/invoice.dart';

class InvoiceDetail extends StatefulWidget {
  final String invoiceId;
  const InvoiceDetail({Key? key, required this.invoiceId}) : super(key: key);

  @override
  State<InvoiceDetail> createState() => _InvoiceDetailState();
}

class _InvoiceDetailState extends State<InvoiceDetail> {
  Invoice? invoice;
  int selectedFunctionIndex = 0;

  @override
  void initState() {
    super.initState();
    invoice =
        Get.find<InvoiceViewModel>().getInvoiceDetailSync(widget.invoiceId);
  }

  void setFunction(int index) {
    setState(() {
      selectedFunctionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<InvoiceViewModel>(
      model: Get.find<InvoiceViewModel>(),
      child: ScopedModelDescendant<InvoiceViewModel>(
        builder: (context, child, model) {
          return Scaffold(
            body: model.status == ViewStatus.Loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : model.status == ViewStatus.Error
                    ? Container(
                        decoration: BoxDecoration(
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
                        ? CustomScrollView(
                            slivers: <Widget>[
                              SliverAppBar(
                                systemOverlayStyle: SystemUiOverlayStyle.dark,
                                expandedHeight: 100.0,
                                backgroundColor: Colors.white,
                                pinned: true,
                                elevation: 0.0,
                                stretch: true,
                                flexibleSpace: FlexibleSpaceBar(
                                  stretchModes: [
                                    StretchMode.blurBackground,
                                    StretchMode.zoomBackground,
                                  ],
                                ),
                                title: Container(
                                  child: Text('Invoice Detail'),
                                ),
                                bottom: PreferredSize(
                                  preferredSize: Size.fromHeight(30.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      selectedFunctionIndex == 0
                                                          ? ThemeColor.primary
                                                          : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    setFunction(0);
                                                  },
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text('Preview'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      selectedFunctionIndex == 1
                                                          ? ThemeColor.primary
                                                          : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    setFunction(1);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Edit',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(invoice!.status == 0
                                            ? 'Finished'
                                            : 'cccccc'),
                                        Text(invoice!.invoiceCode.toString()),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(invoice!.status == 0
                                            ? 'Finished'
                                            : 'ccccc'),
                                        Text(invoice!.createdDate.toString()),
                                        // Text(invoice!.updatedDate.toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(invoice!.partnerId.toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(invoice!.invoiceDetail.toString()),
                                        SizedBox(
                                          height: 25000,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/invoice_history_partner.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/invoice.dart';

class PreviewInvoiceDetail extends StatefulWidget {
  String invoiceId;
  PreviewInvoiceDetail({Key? key, required this.invoiceId}) : super(key: key);

  @override
  State<PreviewInvoiceDetail> createState() => _PreviewInvoiceDetailState();
}

class _PreviewInvoiceDetailState extends State<PreviewInvoiceDetail> {
  Invoice? invoice;
  InvoiceHistoryPartner? invoiceHistoryPartner;
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
                        ? Center(
                            // Đặt Center widget để căn giữa
                            child: CustomScrollView(
                              slivers: <Widget>[
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Invoice',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '# ${invoice!.invoiceCode ?? ''}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Vnpay status:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${model.invoiceHistoryPartner?.vnPayInvoiceStatus.tvanStatus}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Tvan status:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${model.invoiceHistoryPartner?.vnPayInvoiceStatus.tvanStatus}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Status of invoice:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${model.invoiceHistoryPartner?.vnPayInvoiceStatus.invoiceStatus}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Created date',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${DateFormat('d MMMM').format(DateTime.parse(invoice!.createdDate ?? ''))}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Table(
                                            border: TableBorder.all(
                                                color: Colors.black),
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            children: [
                                              const TableRow(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                ),
                                                children: [
                                                  TableCell(
                                                    child: Center(
                                                      child: Text('No.'),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Text('Product'),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Text('Quantity'),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Text('Price'),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Center(
                                                      child: Text('Total'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              for (int i = 0;
                                                  i < invoice!.items!.length;
                                                  i++)
                                                TableRow(
                                                  decoration: i / 2 == 0
                                                      ? const BoxDecoration(
                                                          color:
                                                              Color(0xff8FBEFF),
                                                        )
                                                      : const BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                  children: [
                                                    TableCell(
                                                      child: Center(
                                                        child: Text(
                                                            (i + 1).toString()),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text(invoice
                                                                ?.items![i]
                                                                .code ??
                                                            ''),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text(invoice!
                                                            .items![i].quantity
                                                            .toString()),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text(invoice!
                                                            .items![i].price
                                                            .toString()), // Giá
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text((invoice!
                                                                    .items![i]
                                                                    .quantity! *
                                                                invoice!
                                                                    .items![i]
                                                                    .price)
                                                            .toString()), // Tổng
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Total Without Tax',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${invoice!.totalAmountWithoutTax}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Tax',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${invoice!.totalTaxAmount}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Total',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${invoice!.totalAmount}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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

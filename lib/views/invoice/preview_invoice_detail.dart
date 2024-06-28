import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/invoice_history_partner.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/invoice_status.dart';
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
                ? const Center(
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
                          child: Text(
                            () {
                              if (model.msg != null && model.msg!.isEmpty) {
                                return model.msg!;
                              } else {
                                return 'Error loading invoice detail';
                              }
                            }(),
                          ),
                        ),
                      )
                    : invoice != null
                        ? Center(
                            child: CustomScrollView(
                              slivers: <Widget>[
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      decoration: BoxDecoration(
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/BG.png'),
                                          fit: BoxFit.fill,
                                        ),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 30),
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
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '# ${invoice!.invoiceCode ?? ''}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: getStatusColor(
                                                                        invoice
                                                                            ?.status),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0)),
                                                          child: Text(
                                                            invoiceStatusFromInt(
                                                                invoice
                                                                    ?.status),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: getStatusColor(
                                                                  invoice
                                                                      ?.status),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                buildRow('Lookup Code',
                                                    invoice!.lookupCode ?? ''),
                                                invoiceStatusFromInt(
                                                            invoice!.status) !=
                                                        'Failed'
                                                    ? Column(
                                                        children: [
                                                          buildRow(
                                                            'Vnpay status',
                                                            model
                                                                        .invoiceHistoryPartner
                                                                        ?.vnPayInvoiceStatus
                                                                        .status !=
                                                                    null
                                                                ? VnpayStatusExtension
                                                                    .get(model
                                                                        .invoiceHistoryPartner!
                                                                        .vnPayInvoiceStatus
                                                                        .status)
                                                                : '',
                                                          ),
                                                          buildRow(
                                                              'Tvan status',
                                                              model.invoiceHistoryPartner?.vnPayInvoiceStatus
                                                                          .tvanStatus !=
                                                                      null
                                                                  ? TvanStatusExtension.get(model
                                                                      .invoiceHistoryPartner!
                                                                      .vnPayInvoiceStatus
                                                                      .tvanStatus)
                                                                  : ''),
                                                          buildRow(
                                                            'Status of invoice after sent',
                                                            model
                                                                        .invoiceHistoryPartner
                                                                        ?.vnPayInvoiceStatus
                                                                        .invoiceStatus !=
                                                                    null
                                                                ? VnpayInvoiceStatusExtension.get(model
                                                                    .invoiceHistoryPartner!
                                                                    .vnPayInvoiceStatus
                                                                    .invoiceStatus)
                                                                : '',
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Error',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        121,
                                                                        121,
                                                                        121)),
                                                          ),
                                                          Text(
                                                              invoice!.responsePartNer
                                                                      ?.message ??
                                                                  '',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ],
                                                      ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Created date',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255,
                                                              121,
                                                              121,
                                                              121)),
                                                    ),
                                                    Text(
                                                      DateFormat('d MMMM').format(
                                                          DateTime.parse(invoice!
                                                                  .createdDate ??
                                                              '')),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Information of Buyer',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            buildRow(
                                                'Buyer Name',
                                                invoice?.invoiceDetail
                                                        ?.buyerFullName ??
                                                    ''),
                                            buildRow(
                                                'Address',
                                                invoice?.invoiceDetail
                                                        ?.buyerAddress ??
                                                    ''),
                                            buildRow(
                                                'Email',
                                                invoice?.invoiceDetail
                                                        ?.buyerEmail ??
                                                    ''),
                                            buildRow(
                                                'Phone',
                                                invoice?.invoiceDetail
                                                        ?.buyerPhoneNumber ??
                                                    ''),
                                            buildRow(
                                                'Bank',
                                                invoice?.invoiceDetail
                                                        ?.buyerBankName ??
                                                    ''),
                                            const SizedBox(height: 20),
                                            const Text(
                                              'Items',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Table(
                                              border: TableBorder.all(
                                                  color: Colors.black),
                                              defaultVerticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              children: [
                                                const TableRow(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          180, 15, 74, 121)),
                                                  children: [
                                                    TableCell(
                                                      child: Center(
                                                        child: Text('No.',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text('Product',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text('Quantity',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text('Price',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text('Total',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                for (int i = 0;
                                                    i < invoice!.items!.length;
                                                    i++)
                                                  TableRow(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    children: [
                                                      TableCell(
                                                        child: Center(
                                                          child: Text((i + 1)
                                                              .toString()),
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
                                                              .items![i]
                                                              .quantity
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
                                                              .toString()),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
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
                                                          const Text(
                                                            'Total Without Tax',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${invoice!.totalAmountWithoutTax}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
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
                                                          const Text(
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
                                                          const Text(
                                                            'Total',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${invoice!.totalAmount}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 20),
                                              color: Colors.black,
                                              height: 2,
                                              width: double.infinity,
                                            ),
                                            const Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '123 Main St, Hanoi',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '0123456789',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Customer@example.com',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
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

  Widget buildRow(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 121, 121, 121)),
        ),
        Text(
          data,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

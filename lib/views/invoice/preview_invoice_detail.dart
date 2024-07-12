import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/invoice_history_partner.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/date_format.dart';
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
                                return 'Lỗi tải chi tiết hóa đơn';
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
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
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
                                                      'Hóa đơn',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 32,
                                                        color: Colors.blue,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            Colors.white,
                                                        decorationStyle:
                                                            TextDecorationStyle
                                                                .dashed,
                                                        letterSpacing: 1.5,
                                                        wordSpacing: 2.0,
                                                        shadows: [
                                                          Shadow(
                                                            blurRadius: 3,
                                                          ),
                                                        ],
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
                                                      '# ${invoice!.invoiceCode ?? ''}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
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
                                                invoiceStatusFromInt(invoice!
                                                                .status) ==
                                                            'Thành Công' &&
                                                        model.invoiceHistoryPartner !=
                                                            null
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
                                                          Flexible(
                                                            child: Text(
                                                              invoice!.responsePartNer
                                                                          ?.message !=
                                                                      null
                                                                  ? 'Lỗi'
                                                                  : '',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              invoice!.responsePartNer
                                                                      ?.message ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              overflow: TextOverflow
                                                                  .visible, // This will ensure text wraps to the next line
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                buildRow('Ngày tạo',
                                                    '${DateFormatVN.formatDate(invoice?.createdDate ?? '')}'),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Thông tin người mua',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            buildRow(
                                                'Tên người mua',
                                                invoice?.invoiceDetail
                                                        ?.buyerFullName ??
                                                    ''),
                                            buildRow(
                                                'Địa chỉ',
                                                invoice?.invoiceDetail
                                                        ?.buyerAddress ??
                                                    ''),
                                            buildRow(
                                                'Email',
                                                invoice?.invoiceDetail
                                                        ?.buyerEmail ??
                                                    ''),
                                            buildRow(
                                                'Điện thoại',
                                                invoice?.invoiceDetail
                                                        ?.buyerPhoneNumber ??
                                                    ''),
                                            buildRow(
                                                'Ngân hàng',
                                                invoice?.invoiceDetail
                                                        ?.buyerBankName ??
                                                    ''),
                                            const SizedBox(height: 20),
                                            const Text(
                                              'Mặt hàng',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
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
                                                        child: Text('Sản phẩm',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text('Số lượng',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text('Giá',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Center(
                                                        child: Text('Tổng cộng',
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
                                                            'Tổng không có thuế',
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
                                                            'Thuế',
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
                                                            'Tổng cộng',
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
                                                      '123 Hà Nội',
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
                                                      'taolachu@email.com',
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
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          data,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

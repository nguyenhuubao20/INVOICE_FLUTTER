import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/models/account.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/utils/route_constrant.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/view_status.dart';
import '../../view_models/account_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  ScrollController _invoicescrollController = ScrollController();
  int selectedMenu = 0;
  List<Invoice>? displayedInvoices = [];
  Account? account;
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  final InvoiceViewModel _invoiceViewModel = Get.find<InvoiceViewModel>();

  @override
  void initState() {
    super.initState();
    _invoiceViewModel.loadInvoice();
  }

  void setInvoiceList(String status) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            'Welcome, ${_accountViewModel.account?.name ?? 'ADMIN'}'),
        actions: [
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            // child: Dropdownbutton(context)
          ),
          const SizedBox(width: 8.0),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Get.find<AccountViewModel>().signOut();
                },
              )
            ],
          )
        ],
      ),
      body: ScopedModel<InvoiceViewModel>(
        model: _invoiceViewModel,
        child: ScopedModelDescendant<InvoiceViewModel>(
          builder: (context, child, model) {
            if (model.status == ViewStatus.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (model.status == ViewStatus.Error) {
              return Center(child: Text('Failed to load invoices'));
            } else if (model.status == ViewStatus.Completed &&
                model.invoiceList != null) {
              return CustomScrollView(
                slivers: <Widget>[
                  const SliverAppBar(
                    pinned: true,
                    expandedHeight: 50.0,
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      for (var invoice in model.invoiceList!) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                "${RouteHandler.INVOICE_DETAIL}?id=${invoice.id}",
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(invoice.totalAmount.toString()),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Invoice Code: ${invoice.invoiceCode}'),
                                        Text(
                                            'Created Date: ${invoice.createdDate}'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('Status: ${invoice.status}'),
                                        Text(
                                            'Payment Method: ${invoice.paymentMethod}'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ]),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No invoices found'));
            }
          },
        ),
      ),
    );
  }
}

// Helper functions to get status and border colors
Color? getStatusColor(int status) {
  switch (status) {
    case 1:
      return Colors.orange[100];
    case 2:
      return Colors.red[100];
    case 3:
      return Colors.green[100];
    case 4:
      return Colors.grey[200];
    case 5:
      return const Color.fromARGB(255, 180, 178, 178);
    default:
      return Colors.transparent;
  }
}

Color? getBorderColor(int status) {
  switch (status) {
    case 1:
      return Colors.orange;
    case 2:
      return Colors.red;
    case 3:
      return Colors.green;
    case 4:
      return Colors.grey[200];
    case 5:
      return Colors.grey;
    default:
      return Colors.transparent;
  }
}

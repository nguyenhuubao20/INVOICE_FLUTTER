import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice/models/invoice.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> list = ['My Company', 'Company A', 'Company B', 'Company C'];
Map<int, String> menu = {
  0: 'All',
  1: 'Unpaid',
  2: 'Overdue',
  3: 'Paid',
  4: 'Cancelled',
  5: 'Draft',
};
List<Invoice> invoiceList = [
  Invoice(
    id: '1',
    date: DateTime.now(),
    customerName: 'Customer A',
    totalPrice: 100.0,
    status: 'Unpaid',
    orderNumber: '1234',
  ),
  Invoice(
    id: '2',
    date: DateTime.now(),
    customerName: 'Customer B',
    totalPrice: 150.0,
    status: 'Paid',
    orderNumber: '1234',
  ),
  Invoice(
    id: '3',
    date: DateTime.now(),
    customerName: 'Customer C',
    totalPrice: 200.0,
    status: 'Draft',
    orderNumber: '1234',
  ),
  Invoice(
    id: '4',
    date: DateTime.now(),
    customerName: 'Customer D',
    totalPrice: 120.0,
    status: 'Overdue',
    orderNumber: '1234',
  ),
  Invoice(
    id: '5',
    date: DateTime.now(),
    customerName: 'Customer E',
    totalPrice: 180.0,
    status: 'Cancelled',
    orderNumber: '1234',
  ),
  Invoice(
    id: '6',
    date: DateTime.now(),
    customerName: 'Customer F',
    totalPrice: 220.0,
    status: 'Paid',
    orderNumber: '1234',
  ),
  Invoice(
    id: '7',
    date: DateTime.now(),
    customerName: 'Customer G',
    totalPrice: 270.0,
    status: 'Paid',
    orderNumber: '1234',
  ),
  Invoice(
    id: '8',
    date: DateTime.now(),
    customerName: 'Customer H',
    totalPrice: 300.0,
    status: 'Paid',
    orderNumber: '1234',
  ),
  Invoice(
    id: '9',
    date: DateTime.now(),
    customerName: 'Customer I',
    totalPrice: 350.0,
    status: 'Paid',
    orderNumber: '1234',
  ),
  Invoice(
    id: '10',
    date: DateTime.now(),
    customerName: 'Customer J',
    totalPrice: 400.0,
    status: 'Paid',
    orderNumber: '1234',
  ),
  Invoice(
    id: '11',
    date: DateTime.now(),
    customerName: 'Customer Q',
    totalPrice: 400.0,
    status: 'Paid',
    orderNumber: '1234',
  ),
  Invoice(
    id: '12',
    date: DateTime.now(),
    customerName: 'Customer K',
    totalPrice: 400.0,
    status: 'Paid',
    orderNumber: '1234',
  ),
];

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  ScrollController _invoicescrollController = ScrollController();
  int selectedMenu = 0;
  List<Invoice> displayedInvoices = [];

  @override
  void initState() {
    displayedInvoices = invoiceList;
    super.initState();
  }

  void setInvoiceList(String status) {
    displayedInvoices =
        invoiceList.where((invoice) => invoice.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Invoice'),
          actions: [
            Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Dropdownbutton(context)),
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
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 50.0,
              title: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    menu.length,
                    (index) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedMenu = index;
                            setInvoiceList(menu[index].toString());
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: selectedMenu == index
                                    ? Border(
                                        bottom: BorderSide(
                                            color: Colors.red, width: 2.0))
                                    : null,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    menu[index]!,
                                    style: TextStyle(fontSize: 16.0).copyWith(
                                      color: selectedMenu == index
                                          ? Colors.red
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
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
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#' +
                                            displayedInvoices[index]
                                                .orderNumber
                                                .toString() ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    displayedInvoices[index].customerName,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    displayedInvoices[index]
                                                .totalPrice
                                                .toString() +
                                            ' USD' ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                    decoration: BoxDecoration(
                                      color: displayedInvoices[index].status ==
                                              'Unpaid'
                                          ? Colors.orange[100]
                                          : displayedInvoices[index].status ==
                                                  'Overdue'
                                              ? Colors.red[100]
                                              : displayedInvoices[index]
                                                          .status ==
                                                      'Paid'
                                                  ? Colors.green[100]
                                                  : displayedInvoices[index]
                                                              .status ==
                                                          'Draft'
                                                      ? Colors.grey[200]
                                                      : displayedInvoices[index]
                                                                  .status ==
                                                              'Cancelled'
                                                          ? Colors.grey[200]
                                                          : Colors.transparent,
                                      border: Border.all(
                                        color: displayedInvoices[index]
                                                    .status ==
                                                'Unpaid'
                                            ? Colors.orange
                                            : displayedInvoices[index].status ==
                                                    'Overdue'
                                                ? Colors.red
                                                : displayedInvoices[index]
                                                            .status ==
                                                        'Paid'
                                                    ? Colors.green
                                                    : displayedInvoices[index]
                                                                .status ==
                                                            'Draft'
                                                        ? Colors.grey
                                                        : Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      displayedInvoices[index].status,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: displayedInvoices[index]
                                                    .status ==
                                                'Unpaid'
                                            ? Colors.orange
                                            : displayedInvoices[index].status ==
                                                    'Overdue'
                                                ? Colors.red
                                                : displayedInvoices[index]
                                                            .status ==
                                                        'Paid'
                                                    ? Colors.green
                                                    : displayedInvoices[index]
                                                                .status ==
                                                            'Draft'
                                                        ? Colors.grey
                                                        : Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(displayedInvoices[index].date),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.0),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0)
                    ],
                  );
                },
                childCount: displayedInvoices.length,
              ),
            ),
          ],
        ));
  }
}

Widget Dropdownbutton(BuildContext context) {
  return DropdownButton<String>(
    padding: EdgeInsets.all(8.0),
    borderRadius: BorderRadius.circular(8),
    value: list[0],
    elevation: 16,
    style: const TextStyle(color: Colors.black),
    onChanged: (String? value) {
      // setState(() {
      //   dropdownValue = value!;
      // });
    },
    items: list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:intl/intl.dart';
import 'package:invoice/enums/invoice_status.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/account.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/utils/route_constrant.dart';
import 'package:invoice/utils/theme.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:invoice/view_models/organization_view_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../models/store.dart';
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
  List<String>? storeNames = [];
  Account? account;
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  final InvoiceViewModel _invoiceViewModel = Get.find<InvoiceViewModel>();
  final OrganizationViewModel _organizationViewModel =
      Get.find<OrganizationViewModel>();
  String? selectedStore = 'Select Store';
  late DateTime selectedDate;
  late DateTime minDate;
  late DateTime maxDate;

  @override
  void initState() {
    super.initState();
    _invoiceViewModel.loadInvoice();
    _organizationViewModel.getStoreByOrganizationId();
    storeNames = _organizationViewModel.storeNames;
    tz.initializeTimeZones();
    final vietnam = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(vietnam);
    minDate = DateTime(now.year - 1, now.month, now.day);
    maxDate = DateTime(now.year + 1, now.month, now.day);
    selectedDate = now;
  }

  void setInvoiceList(String status) {
    displayedInvoices = _invoiceViewModel.invoiceList!
        .where((element) => element.status == status)
        .toList();
  }

  void setSelectedMenu(int index) {
    setState(() {
      selectedMenu = index;
    });
  }

  void setFormattedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildGreeting(_accountViewModel),
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [],
                ),
              ),
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.store, color: Colors.grey[600]),
                        SizedBox(width: 8.0),
                        Text(
                          'Store',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          showBottomSheet(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: ScopedModel<OrganizationViewModel>(
                                model: _organizationViewModel,
                                child: ScopedModelDescendant<
                                    OrganizationViewModel>(
                                  builder: (context, child, model) {
                                    if (model.status == ViewStatus.Completed) {
                                      List<Store>? storeList = model.storeList;
                                      if (storeList != null &&
                                          storeList.isNotEmpty) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: storeList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final Store store =
                                                storeList[index];
                                            return ListTile(
                                              title: Text(store.name ?? '',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                  )),
                                              onTap: () {
                                                setState(() {
                                                  selectedStore = store.name;
                                                });
                                                Get.back();
                                              },
                                            );
                                          },
                                        );
                                      }
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedStore ?? 'Select Store',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16.0),
                child: HorizontalWeekCalendar(
                  minDate: minDate,
                  maxDate: maxDate,
                  initialDate: selectedDate,
                  onDateChange: (date) {
                    setState(() {
                      setFormattedDate(date);
                    });
                  },
                  showTopNavbar: true,
                  monthFormat: "MMMM yyyy",
                  showNavigationButtons: true,
                  weekStartFrom: WeekStartFrom.Monday,
                  borderRadius: BorderRadius.circular(10),
                  activeBackgroundColor: ThemeColor.blue,
                  activeTextColor: Colors.white,
                  inactiveBackgroundColor: Colors.white,
                  inactiveTextColor: Colors.black,
                  disabledTextColor: Colors.grey,
                  disabledBackgroundColor: Colors.grey.withOpacity(.3),
                  activeNavigatorColor: Colors.black,
                  inactiveNavigatorColor: Colors.black,
                  monthColor: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),
              Padding( 
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.grey.withOpacity(0.5),
                      //   spreadRadius: 1,
                      //   blurRadius: 2,
                      //   offset: Offset(0, 2),
                      // ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('dd-MM-yyyy')
                                        .format(selectedDate),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    'VND 0',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16.0),
                              Column(
                                children: [
                                  Container(
                                    child: Image.asset(
                                      "assets/images/chart.png",
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ScopedModel<InvoiceViewModel>(
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
                          SliverAppBar(
                            backgroundColor: Colors.grey[100],
                            pinned: true,
                            expandedHeight: 50.0,
                            automaticallyImplyLeading:
                                false, // This will remove the back arrow
                            title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var _invoiceStatus
                                      in InvoiceStatus.values) ...[
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedMenu = _invoiceStatus.index;
                                          setInvoiceList(_invoiceStatus
                                              .toString()
                                              .split('.')
                                              .last);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12.0),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: selectedMenu ==
                                                      _invoiceStatus.index
                                                  ? ThemeColor.primary
                                                  : Colors.transparent,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          _invoiceStatus
                                              .toString()
                                              .split('.')
                                              .last,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: selectedMenu ==
                                                    _invoiceStatus.index
                                                ? ThemeColor.primary
                                                : Colors.black,
                                            fontWeight: selectedMenu ==
                                                    _invoiceStatus.index
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                                Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: getStatusColor(
                                                        invoice.status),
                                                    border: Border.all(
                                                      color: getBorderColor(
                                                          invoice.status),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Text(
                                                      (invoiceStatusFromString(
                                                              invoice.status ??
                                                                  5))
                                                          .toString()),
                                                ),
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
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildGreeting(AccountViewModel _accountViewModel) {
  String assetPath;
  String greeting = getGreeting();

  // Chọn biểu tượng dựa vào lời chào
  if (greeting == 'Good morning ') {
    assetPath = 'assets/images/afternoon.png';
  } else if (greeting == 'Good afternoon ') {
    assetPath = 'assets/images/afternoon.png';
  } else {
    assetPath = 'assets/images/night.png';
  }

  return Row(
    children: [
      Image.asset(assetPath, width: 30, height: 50),
      SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[500]!,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${_accountViewModel.account?.name ?? ''}',
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}

String getGreeting() {
  tz.initializeTimeZones();
  final vietnam = tz.getLocation('Asia/Ho_Chi_Minh');
  final now = tz.TZDateTime.now(vietnam);

  var hour = now.hour;

  if (hour < 12) {
    return 'Good morning ';
  } else if (hour < 18) {
    return 'Good afternoon ';
  } else {
    return 'Good evening ';
  }
}

// Helper functions to get status and border colors
Color getStatusColor(int? status) {
  switch (status) {
    case 0:
      return Colors.orange[100]!;
    case 1:
      return Colors.red[100]!;
    case 2:
      return Colors.green[100]!;
    case 3:
      return Colors.grey[200]!;
    default:
      return const Color.fromARGB(255, 180, 178, 178);
  }
}

Color getBorderColor(int? status) {
  switch (status) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.red;
    case 2:
      return Colors.green;
    case 3:
      return Colors.white;
    default:
      return Colors.grey;
  }
}

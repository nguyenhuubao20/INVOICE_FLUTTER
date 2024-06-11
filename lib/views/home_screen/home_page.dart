import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/account.dart';
import 'package:invoice/models/invoice/invoice.dart';
import 'package:invoice/utils/theme.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:invoice/view_models/organization_view_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../models/store.dart';
import '../../utils/route_constrant.dart';
import '../../view_models/account_view_model.dart';
import '../../widgets/other_dialogs/store_list_bottom_sheet.dart';

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
  late InvoiceReport? invoiceReports;
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildGreeting(_accountViewModel),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              Get.find<AccountViewModel>().signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.red,
              automaticallyImplyLeading: false,
              pinned: true,
              floating: false,
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.store, color: Colors.red),
                          const SizedBox(width: 8.0),
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
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          showBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext context) =>
                                ScopedModel<OrganizationViewModel>(
                              model: _organizationViewModel,
                              child:
                                  ScopedModelDescendant<OrganizationViewModel>(
                                builder: (context, child, model) {
                                  if (model.status == ViewStatus.Completed) {
                                    List<Store>? storeList = model.storeList;
                                    if (storeList != null &&
                                        storeList.isNotEmpty) {
                                      return StoreListBottomSheet(
                                        storeList: storeList,
                                        onSelectStore: (selectedStore) {
                                          setState(() {
                                            this.selectedStore = selectedStore;
                                          });
                                        },
                                      );
                                    } else {
                                      return const Center(
                                        child: Text('No store found'),
                                      );
                                    }
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedStore ?? 'Select Store',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
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
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16.0),
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
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            SliverToBoxAdapter(
              child: ScopedModel<InvoiceViewModel>(
                model: Get.find<InvoiceViewModel>(),
                child: ScopedModelDescendant<InvoiceViewModel>(
                  builder: (context, child, model) {
                    if (model.status == ViewStatus.Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (model.status == ViewStatus.Error) {
                      return const Center(
                          child: Text('Failed to load invoices'));
                    } else if (model.status == ViewStatus.Completed &&
                        model.invoiceList != null) {
                      return Column(
                        children: [
                          for (var invoice in model.invoiceList!) ...[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    "${RouteHandler.INVOICE_DETAIL}?id=${invoice.id}",
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 2),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: getStatusColor(
                                                    invoice.status),
                                                border: Border.all(
                                                  color: getBorderColor(
                                                      invoice.status),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            Text(
                                                'Payment Method: ${invoice.paymentMethod}'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ],
                      );
                    } else {
                      return SliverToBoxAdapter(
                          child:
                              const Center(child: Text('No invoices found')));
                    }
                  },
                ),
              ),
            ),
          ],
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
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
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

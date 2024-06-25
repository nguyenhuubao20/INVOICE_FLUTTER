import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:intl/intl.dart';
import 'package:invoice/enums/view_status.dart';
import 'package:invoice/models/account.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/utils/route_constrant.dart';
import 'package:invoice/utils/theme.dart';
import 'package:invoice/view_models/invoice_view_model.dart';
import 'package:invoice/view_models/organization_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../enums/invoice_status.dart';
import '../../models/store.dart';
import '../../view_models/account_view_model.dart';
import '../../widgets/other_dialogs/store_list_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  TextEditingController _searchController = TextEditingController();
  List<String> _statuses = [
    'All',
    'Pending',
    'Sent',
    'PendingApproval',
    'Completed',
    'Failed'
  ];
  int selectedMenu = 0;
  List<Invoice>? displayedInvoices = [];
  late InvoiceReport? invoiceReports;
  Account? account;
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  final InvoiceViewModel _invoiceViewModel = Get.find<InvoiceViewModel>();
  final OrganizationViewModel _organizationViewModel =
      Get.find<OrganizationViewModel>();
  String? selectedStore;
  late DateTime selectedDate;
  late String selectedDateStr;
  late int? _selectedStatusIndex = -1;
  late String? _selectedStatus = null;
  late String selectedname = '';
  late DateTime minDate;
  late DateTime maxDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final vietnam = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(vietnam);
    minDate = DateTime(now.year - 1, now.month, now.day);
    maxDate = DateTime(now.year + 1, now.month, now.day);
    selectedDate = DateTime(now.year, now.month, now.day);
    selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    _invoiceViewModel.loadInvoice(
        selectedDateStr, selectedStore, _selectedStatusIndex, selectedname);
  }

  @override
  void dispose() {
    _searchController.dispose();
    refreshController.dispose();
    super.dispose();
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

  void setInvoiceToDisplayed(String? storeId, DateTime date) {
    setState(() {
      selectedDate = date;
      selectedDateStr = DateFormat("yyyy-MM-dd").format(date);
      _invoiceViewModel.loadInvoice(
        selectedDateStr,
        selectedStore,
        _selectedStatusIndex,
        selectedname,
      );
    });
    refreshController.requestRefresh();
  }

  void _onSearchChanged(String value) {
    selectedname = value;

    setInvoiceToDisplayed(selectedDateStr, selectedDate);
  }

  void _onStatusChanged(String? newStatus) {
    switch (newStatus) {
      case 'All':
        _selectedStatusIndex = -1;
        break;
      case 'Pending':
        _selectedStatusIndex = 0;
        break;
      case 'Sent':
        _selectedStatusIndex = 1;
        break;
      case 'PendingApproval':
        _selectedStatusIndex = 2;
        break;
      case 'Completed':
        _selectedStatusIndex = 3;
        break;
      case 'Failed':
        _selectedStatusIndex = 4;
        break;
      default:
        _selectedStatusIndex = 4;
    }

    setState(() {
      _selectedStatus = newStatus;
    });

    setInvoiceToDisplayed(
      selectedStore,
      selectedDate,
    );
  }

  void _onRefresh() async {
    final result = await _invoiceViewModel.loadInvoice(
      selectedDateStr,
      selectedStore,
      _selectedStatusIndex,
      selectedname,
      isRefresh: true,
    );
    if (result) {
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    final result = await _invoiceViewModel.loadInvoice(
      selectedDateStr,
      selectedStore,
      _selectedStatusIndex,
      selectedname,
    );
    if (result) {
      refreshController.loadComplete();
    } else {
      refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff549FFD),
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
              backgroundColor: Color(0xff549FFD),
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
                          Icon(Icons.store, color: Color(0xff549FFD)),
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
                              model: Get.find<OrganizationViewModel>(),
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
                                            for (var s in storeList) {
                                              selectedStore = s.id!;
                                              setInvoiceToDisplayed(
                                                selectedStore,
                                                selectedDate,
                                              );
                                            }
                                          });
                                        },
                                      );
                                    } else {
                                      return const StoreListBottomSheet(
                                        storeList: [],
                                        onSelectStore: null,
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
                    setInvoiceToDisplayed(selectedStore, date);
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
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: TextFormField(
                              controller: _searchController,
                              onFieldSubmitted: (value) {
                                _onSearchChanged(value);
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search invoices',
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.grey[200],
                            ),
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: DropdownButton<String>(
                                    value: _selectedStatus,
                                    hint: Text('Status'),
                                    icon: Icon(Icons.filter_list),
                                    iconSize: 24,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    onChanged: (String? newValue) {
                                      _onStatusChanged(newValue);
                                    },
                                    items: _statuses
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    ScopedModel<InvoiceViewModel>(
                      model: _invoiceViewModel,
                      child: ScopedModelDescendant<InvoiceViewModel>(
                        builder: (context, child, model) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: SmartRefresher(
                              enablePullUp: true,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              controller: refreshController,
                              child: _buildContent(model),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildContent(InvoiceViewModel model) {
  if (model.status == ViewStatus.Loading) {
    return Center(
      child: CircularProgressIndicator(),
    );
  } else if (model.status == ViewStatus.Error) {
    return Center(
      child: Text(
        'Some error occurred! Please try again later.',
        style: TextStyle(color: Color(0xff549FFD)),
      ),
    );
  } else if (model.status == ViewStatus.Empty) {
    return Center(
      child: Text(
        'Invoice is not available now! Please try again later.',
        style: TextStyle(color: Color(0xff549FFD)),
      ),
    );
  } else if (model.status == ViewStatus.Completed) {
    return ListView.builder(
      itemCount: model.invoiceList.length,
      itemBuilder: (context, index) {
        var displayedInvoices = model.invoiceList[index];
        return InkWell(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    '# ${displayedInvoices.invoiceCode}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRowWithIcon(Icons.code_off,
                              '${displayedInvoices.lookupCode}', Colors.grey),
                          _buildRowWithIcon(
                              Icons.payment,
                              '${displayedInvoices.paymentMethod}',
                              Colors.grey),
                          _buildRowWithIcon(
                              null,
                              'Total: ${displayedInvoices.totalAmount}',
                              Colors.black),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 1.0,
                              horizontal: 8.0,
                            ),
                            child: Text(
                              invoiceStatusFromString(displayedInvoices.status),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: getBorderColor(displayedInvoices.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildRowWithIcon(
                              Icons.access_time,
                              '${timeago.format(DateTime.parse(displayedInvoices.createdDate!))}',
                              Colors.grey),
                          _buildRowWithIcon(
                              Icons.calendar_month,
                              '${DateFormat('d MMMM').format(DateTime.parse(displayedInvoices.createdDate!))}',
                              Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () => Get.toNamed(
            '${RouteHandler.INVOICE_DETAIL}?id=${displayedInvoices.id}',
          ),
        );
      },
    );
  } else {
    return Container();
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

Widget _buildRowWithIcon(IconData? icon, String text, Color textColor) {
  return Row(
    children: [
      if (icon != null) Icon(icon, color: textColor, size: 16.0),
      if (icon != null) SizedBox(width: 8.0),
      Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

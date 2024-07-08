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
import '../../widgets/other_dialogs/dialog.dart';
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
    'Draft', // Bản nháp
    'Success', // Gửi thành công
    'Sent', // Đã gửi
    'Pending Approval', // Đang chờ phê duyệt
    'Completed', // Hoàn tất
    'Failed', // Thất bại
    'Pending',
    'RetryPending',
    'Replaced' // Đang chờ thử lại
  ];
  int selectedMenu = 0;
  List<Invoice>? displayedInvoices = [];
  late InvoiceReport? invoiceReports;
  Account? account;
  final AccountViewModel _accountViewModel = Get.find<AccountViewModel>();
  final InvoiceViewModel _invoiceViewModel = Get.find<InvoiceViewModel>();
  final OrganizationViewModel _organizationViewModel =
      Get.find<OrganizationViewModel>();
  String? selectedStoreId;
  String? selectedStoreStr;
  DateTime? selectedDate;
  String? selectedDateStr;
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
    _invoiceViewModel.loadInvoice();
  }

  @override
  void dispose() {
    _searchController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void setInvoiceToDisplayed() {
    setState(() {
      _invoiceViewModel.loadInvoice();
    });
    refreshController.requestRefresh();
  }

  void _onRefresh() async {
    final result = await _invoiceViewModel.loadInvoice(
      isRefresh: true,
    );
    if (result) {
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    final result = await _invoiceViewModel.loadInvoice();
    if (result) {
      refreshController.loadComplete();
    } else {
      refreshController.loadFailed();
    }
  }

  void triggerRefresh() {
    _onRefresh();
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
            icon: Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () {
              _invoiceViewModel.removeAll();
              setInvoiceToDisplayed();
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.notifications),
          //   color: Colors.white,
          //   onPressed: () {},
          // ),
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              _accountViewModel.signOut();
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
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: StoreListBottomSheet(
                                        storeList: storeList,
                                        onSelectStore:
                                            (selectedStore, selectedStoreStr) {
                                          setState(() {
                                            for (var s in storeList!) {
                                              selectedStoreId = s.id!;
                                              selectedStoreStr = s.name!;
                                              _invoiceViewModel.setStore(
                                                  selectedStoreId,
                                                  selectedStoreStr);
                                              setInvoiceToDisplayed();
                                            }
                                          });
                                        },
                                      ),
                                    );
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
                                _invoiceViewModel.selectedStoreNameStr ??
                                    'Select Store',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (_invoiceViewModel.selectedStoreNameStr !=
                                      null) {
                                    _invoiceViewModel.resetStore();
                                    setInvoiceToDisplayed();
                                  }
                                },
                                child: Icon(
                                  _invoiceViewModel.selectedStoreNameStr == null
                                      ? Icons.arrow_drop_down
                                      : Icons.close,
                                  color: Colors.black,
                                ),
                              )
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
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: HorizontalWeekCalendar(
                      minDate: minDate,
                      maxDate: maxDate,
                      initialDate: _invoiceViewModel.selectedDateStr != null
                          ? DateTime.parse(_invoiceViewModel.selectedDateStr!)
                          : DateTime.now(),
                      onDateChange: (date) {
                        _invoiceViewModel.setSelectedDate(date);
                        setInvoiceToDisplayed();
                      },
                      showTopNavbar: true,
                      monthFormat: "MMMM yyyy",
                      showNavigationButtons: true,
                      weekStartFrom: WeekStartFrom.Monday,
                      borderRadius: BorderRadius.circular(10),
                      activeBackgroundColor:
                          _invoiceViewModel.selectedDate != null
                              ? ThemeColor.blue
                              : Colors.grey[100],
                      activeTextColor: _invoiceViewModel.selectedDate != null
                          ? Colors.white
                          : Colors.black,
                      inactiveBackgroundColor: Colors.grey[100],
                      inactiveTextColor: Colors.black,
                      disabledTextColor: Colors.grey,
                      disabledBackgroundColor: Colors.grey.withOpacity(.3),
                      activeNavigatorColor: Colors.black,
                      inactiveNavigatorColor: Colors.black,
                      monthColor: Colors.black,
                    ),
                  ),
                ],
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
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: TextFormField(
                              controller: _searchController,
                              onFieldSubmitted: (value) {
                                _invoiceViewModel.setSearchedName(value);
                                setInvoiceToDisplayed();
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search invoices',
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.black),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 0.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: DropdownButtonFormField<String>(
                                    value: _invoiceViewModel.selectedStatusStr,
                                    hint: Text(''),
                                    icon: Icon(Icons.filter_list),
                                    iconSize: 24,
                                    isExpanded: true,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      _invoiceViewModel
                                          .setSelectedStatus(newValue);
                                      setInvoiceToDisplayed();
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Status',
                                      labelStyle:
                                          TextStyle(color: ThemeColor.black),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: ThemeColor.white,
                                    ),
                                    items: _statuses
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              color: _invoiceViewModel
                                                          .selectedStatusStr ==
                                                      value
                                                  ? ThemeColor.blue
                                                  : ThemeColor.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    ScopedModel<InvoiceViewModel>(
                      model: _invoiceViewModel,
                      child: ScopedModelDescendant<InvoiceViewModel>(
                        builder: (context, child, model) {
                          return Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: SmartRefresher(
                                enablePullUp: true,
                                onRefresh: _onRefresh,
                                onLoading: _onLoading,
                                controller: refreshController,
                                child: _buildContent(model, this),
                              ),
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

Widget _buildContent(InvoiceViewModel model, _HomePageState state) {
  if (model.status == ViewStatus.Error) {
    return const Center(
      child: Text(
        'Some error occurred! Please try again later.',
        style: TextStyle(color: Color(0xff549FFD)),
      ),
    );
  } else if (model.status == ViewStatus.Empty) {
    return const Center(
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
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '# ${displayedInvoices.invoiceCode}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRowWithIcon(
                              Icons.code_off,
                              '${displayedInvoices.lookupCode ?? ''}',
                              Colors.grey),
                          _buildRowWithIcon(
                              Icons.payment,
                              '${displayedInvoices.paymentMethod}',
                              Colors.grey),
                          Text(
                            invoiceStatusFromString(displayedInvoices.status),
                            style: TextStyle(
                              fontSize: 17.0,
                              color: getStatusColor(displayedInvoices.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildRowWithIcon(
                              Icons.access_time,
                              '${timeago.format(DateTime.parse(displayedInvoices.createdDate!))}',
                              Colors.grey),
                          _buildRowWithIcon(
                              Icons.calendar_month,
                              '${DateFormat('d MMMM').format(DateTime.parse(displayedInvoices.createdDate!))}',
                              Colors.grey),
                          _buildRowWithIcon(
                              null,
                              'Total: ${displayedInvoices.totalAmount}',
                              Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                if (displayedInvoices.status == 0)
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool confirmed = await showConfirmDialog(
                              title: 'Approval Invoice',
                              content: 'Do you want to approve this invoice?',
                              confirmText: 'Yes',
                            );
                            if (confirmed) {
                              model.approvalInvoice(
                                  model.invoiceList[index].id!);
                            } else {
                              // Người dùng đã hủy bỏ hành động
                            }
                          },
                          child: Text(
                            'Waiting for approval',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  )
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

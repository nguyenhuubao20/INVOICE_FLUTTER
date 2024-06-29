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
    'RetryPending', // Đang chờ thử lại
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
    _invoiceViewModel.loadInvoice(
        selectedDateStr, selectedStore, _selectedStatusIndex, selectedname);
  }

  @override
  void dispose() {
    _searchController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void setInvoiceToDisplayed(String? storeId, DateTime? date) {
    setState(() {
      selectedDate = date;
      selectedDateStr =
          date != null ? DateFormat("yyyy-MM-dd").format(date) : '';
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
      case 'Draft':
        _selectedStatusIndex = 0;
        break;
      case 'Success':
        _selectedStatusIndex = 1;
        break;
      case 'Sent':
        _selectedStatusIndex = 2;
        break;
      case 'Pending Approval':
        _selectedStatusIndex = 3;
        break;
      case 'Completed':
        _selectedStatusIndex = 4;
        break;
      case 'Failed':
        _selectedStatusIndex = 5;
        break;
      case 'Pending':
        _selectedStatusIndex = 6;
        break;
      case 'RetryPending':
        _selectedStatusIndex = 7;
        break;
      default:
        _selectedStatusIndex = -1;
        break;
    }
    setState(() {
      _invoiceViewModel.setSelectedStatus(newStatus);
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
                                              selectedStore = s.id!;
                                              selectedStoreStr = s.name!;
                                              setInvoiceToDisplayed(
                                                selectedStore,
                                                selectedDate,
                                              );
                                              _invoiceViewModel.setStoreName(
                                                  selectedStoreStr);
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
                  initialDate: _invoiceViewModel.selectedDateStr != null
                      ? DateTime.parse(_invoiceViewModel.selectedDateStr!)
                      : DateTime.now(),
                  onDateChange: (date) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(date);
                    _invoiceViewModel.setSelectedDate(formattedDate);
                    setInvoiceToDisplayed(
                        selectedStore, date ?? DateTime.now());
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
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
                                    onChanged: (String? newValue) {
                                      _onStatusChanged(newValue);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Status',
                                      labelStyle:
                                          TextStyle(color: ThemeColor.black),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: ThemeColor.black, width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: ThemeColor.black, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ThemeColor.blue, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
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
                              state.triggerRefresh();
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

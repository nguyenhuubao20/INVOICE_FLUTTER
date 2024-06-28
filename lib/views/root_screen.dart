import 'package:flutter/material.dart';
import 'package:invoice/views/settings/setting.dart';

import '../utils/theme.dart';
import 'chart/dashboard.dart';
import 'home_screen/home_page.dart';

class RootScreen extends StatefulWidget {
  final int idx;
  const RootScreen({super.key, required this.idx});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  String? userId;
  List<Widget> portraitViews = [
    HomePage(),
    Dashboard(),
    Setting(),
  ];

  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Invoice'),
    BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_customize), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];
  @override
  void initState() {
    _selectedIndex = widget.idx;

    // getUserId().then((value) => {userId = value});
    // Get.find<AccountViewModel>().getMembershipInfo();
    // if (Get.find<MenuViewModel>().blogList != null &&
    //     // ignore: unnecessary_null_comparison
    //     (Get.find<MenuViewModel>()
    //             .blogList!
    //             .firstWhere((element) => element.isDialog == true) !=
    //         null)) {
    //   Timer.run(showImageDialog);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   elevation: 2,
      //   backgroundColor: ThemeColor.primary,
      //   onPressed: () {
      //     Get.toNamed(RouteHandler.CREATE_INVOICE);
      //   },
      //   child: Icon(
      //     Icons.add,
      //     size: 28,
      //     color: Colors.white,
      //   ),
      //   shape: CircleBorder(),
      // ),
      body: portraitViews[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: items,
        iconSize: 24,
        currentIndex: _selectedIndex,
        selectedItemColor: ThemeColor.primary,
        unselectedItemColor: Colors.grey[600],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

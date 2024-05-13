import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/utils/route_constrant.dart';
import 'package:invoice/widgets/other_dialogs/dialog.dart';

import '../utils/theme.dart';
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
    // OrdersScreen(),
    // MenuScreen(),
    // QrScreen(),
    // OrderHistory(),
    // OtherPage(),
  ];

  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
    BottomNavigationBarItem(
        icon: Icon(Icons.coffee_outlined), label: 'Đặt hàng'),
    // BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Quet mã'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.history_outlined,
        ),
        label: 'Hoạt động'),
    BottomNavigationBarItem(
        icon: Icon(Icons.person_2_outlined), label: 'Tài khoản'),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          elevation: 2,
          backgroundColor: ThemeColor.primary,
          onPressed: () {
            if (userId == null) {
              showConfirmDialog(
                      title: "Người dùng chưa đăng nhập",
                      content:
                          "Vui lòng đăng nhập để đặt đơn và nhận ưu đãi nhé",
                      confirmText: "Đăng nhập")
                  .then((value) => {
                        if (value) {Get.toNamed(RouteHandler.LOGIN)}
                      });
            } else {
            }
          },
          child: const Icon(
            Icons.qr_code_scanner,
            size: 28,
            color: Colors.white,
          )),
      body: portraitViews[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: items,
        iconSize: 24,
        currentIndex: _selectedIndex,
        selectedItemColor: ThemeColor.primary,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

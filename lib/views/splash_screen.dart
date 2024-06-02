import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/utils/route_constrant.dart';

import '../api/account_api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserIsLogged();
  }

  Future<void> _checkUserIsLogged() async {
    AccountAPI accountAPI = AccountAPI();
    bool isLoggedIn = await accountAPI.checkUserIsLogged();
    if (isLoggedIn) {
      Get.offAllNamed(RouteHandler.HOME);
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed(RouteHandler.INTRO);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.network(
          'https://www.shutterstock.com/image-vector/invoice-typographic-stamp-sign-badge-260nw-1027820257.jpg',
          height: 140.0,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

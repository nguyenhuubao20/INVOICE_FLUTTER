import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/models/account.dart';
import 'package:invoice/utils/route_constrant.dart';
import 'package:invoice/view_models/account_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AccountViewModel acc = Get.find<AccountViewModel>();

  @override
  void initState() {
    super.initState();
    _checkUserIsLogged();
  }

  Future<void> _checkUserIsLogged() async {
    Account? account = await acc.checkUserIsLogged();
    if (account != null) {
      Get.toNamed(RouteHandler.HOME);
    } else {
      Get.offAllNamed(RouteHandler.INTRO);
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

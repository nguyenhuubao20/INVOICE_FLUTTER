import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final AccountViewModel acc = Get.find<AccountViewModel>();

  // @override
  // void initState() {
  //   super.initState();
  //   _checkUserIsLogged();
  // }

  // Future<void> _checkUserIsLogged() async {
  //   Account? account = await acc.checkUserIsLogged();
  //   if (account != null) {
  //     switch (account.role) {
  //       case 0:
  //         await Get.find<BrandViewModel>().loadOrganizationList();
  //         break;
  //       case 2:
  //         await Get.find<OrganizationViewModel>().getStoreByOrganizationId();
  //         break;
  //       default:
  //         // Handle other cases if needed
  //         break;
  //     }
  //     Get.toNamed(RouteHandler.HOME);
  //   } else {
  //     Get.offAllNamed(RouteHandler.INTRO);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Lottie.asset(
                'assets/files/Loading.json',
                height: 280.0,
                fit: BoxFit.fitHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

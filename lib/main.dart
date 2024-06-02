import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:invoice/setup.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/route_constrant.dart';
import 'package:invoice/views/home_screen/invoice_detail.dart';
import 'package:invoice/views/not_found_screen.dart';
import 'package:invoice/views/root_screen.dart';
import 'package:invoice/views/splash_screen.dart';
import 'package:url_strategy/url_strategy.dart';

import 'utils/theme.dart';
import 'views/login/login.dart';
import 'widgets/carousel_slider.dart';

Future<void> main() async {
  if (!GetPlatform.isWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  setPathUrlStrategy();
  createRouteBindings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Invoice Manager',
      color: Colors.white,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      getPages: [
        GetPage(
            name: RouteHandler.WELCOME,
            page: () => const SplashScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.LOGIN,
            page: () => const LoginScreen(),
            transition: Transition.cupertino),
        GetPage(
            name: RouteHandler.INTRO,
            page: () => const SliderIntroduction(),
            transition: Transition.cupertino),
        GetPage(
            name: RouteHandler.INVOICE_DETAIL,
            page: () => InvoiceDetail(invoiceId: Get.parameters['id'] ?? '0'),
            transition: Transition.cupertino),
        GetPage(
            name: RouteHandler.HOME,
            page: () => RootScreen(
                  idx: int.parse(Get.parameters['idx'] ?? '0'),
                ),
            transition: Transition.cupertino),
      ],
      initialRoute: RouteHandler.WELCOME,
      unknownRoute: GetPage(
          name: RouteHandler.NOT_FOUND, page: () => const NotFoundScreen()),
      home: const SplashScreen(),
    );
  }
}

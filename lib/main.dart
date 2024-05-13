import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:invoice/setup.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/route_constrant.dart';
import 'package:invoice/views/home_screen/home_page.dart';
import 'package:invoice/views/login/login.dart';
import 'package:invoice/views/not_found_screen.dart';
import 'package:invoice/views/root_screen.dart';
import 'package:invoice/views/splash_screen.dart';
import 'package:url_strategy/url_strategy.dart';

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
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff8FBEFF),
          scaffoldBackgroundColor: Color(0xffF9F9F9),
          brightness: Brightness.light,
          fontFamily: 'Inter'),
      themeMode: ThemeMode.light,
      getPages: [
        GetPage(
            name: RouteHandler.WELCOME,
            page: () => const SplashScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.HOME,
            page: () => const HomePage(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.LOGIN,
            page: () => const LoginScreen(),
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

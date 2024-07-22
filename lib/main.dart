import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:invoice/networking/firebase/firebase_notification.dart';
import 'package:invoice/setup.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/route_constrant.dart';
import 'package:invoice/view_models/theme_view_model.dart';
import 'package:invoice/views/not_found_screen.dart';
import 'package:invoice/views/root_screen.dart';
import 'package:invoice/views/settings/setting.dart';
import 'package:invoice/views/splash_screen.dart';
import 'package:url_strategy/url_strategy.dart';

import 'enums/date_format.dart';
import 'networking/firebase/firebase_options.dart';
import 'utils/theme.dart';
import 'views/home_screen/invoice_detail.dart';
import 'views/invoice/preview_invoice_detail.dart';
import 'views/login/login.dart';
import 'widgets/carousel_slider.dart';

@pragma("vm:entry-point")
Future<void> main() async {
  if (!GetPlatform.isWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();
  DateFormatVN.initializeTimeAgo();
  await initializeDateFormatting('vi', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  DartPluginRegistrant.ensureInitialized();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await FireBaseNotification().init();
  setPathUrlStrategy();
  createRouteBindings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeViewModel = ThemeViewModel();
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
      themeMode: themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      supportedLocales: [
        const Locale('vi', 'VN'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
            name: RouteHandler.INVOICE_DETAIL,
            page: () =>
                InvoiceDetailPage(invoiceId: Get.parameters['id'] ?? '0'),
            transition: Transition.cupertino),
        GetPage(
            name: RouteHandler.PREVIEW_INVOICE_DETAIL,
            page: () =>
                PreviewInvoiceDetail(invoiceId: Get.parameters['id'] ?? '0'),
            transition: Transition.cupertino),
        GetPage(
            name: RouteHandler.INTRO,
            page: () => const SliderIntroduction(),
            transition: Transition.cupertino),
        GetPage(
            name: RouteHandler.SETTINGS,
            page: () => const Setting(),
            transition: Transition.cupertino),
        GetPage(
          name: RouteHandler.DASHBOARD,
          page: () => RootScreen(
            idx: int.parse(Get.parameters['idx'] ?? '0'),
          ),
          transition: Transition.cupertino,
        ),
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

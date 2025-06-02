import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:r2reowner/constants/custom_scroll_behaviour.dart';
import 'package:r2reowner/routing_service.dart';
import 'package:r2reowner/state_management/deal_offer_provider.dart';
import 'package:r2reowner/state_management/entry_input_provider.dart';
import 'package:r2reowner/state_management/payment_provider.dart';
import 'package:r2reowner/state_management/rep_menu_provider.dart';
import 'package:r2reowner/state_management/restaurant_info_provider.dart';
import 'package:r2reowner/state_management/sales_history_provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_size/window_size.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  // Use package:url_strategy until this pull request is released:
  // https://github.com/flutter/flutter/pull/77103

  // Use to setHashUrlStrategy() to use "/#/" in the address bar (default). Use
  // setPathUrlStrategy() to use the path. You may need to configure your web
  // server to redirect all paths to index.html.
  //
  // On mobile platforms, both functions are no-ops.
  setHashUrlStrategy();
  // setPathUrlStrategy();
  setupWindow();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  widgetsBinding;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GoRouter router = RoutingService().router;
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    router.refresh();
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EntryInputProvider()),
        ChangeNotifierProvider(create: (context) => RestaurantInfoProvider()),
        ChangeNotifierProvider(create: (context) => DealOfferProvider()),
        ChangeNotifierProvider(create: (context) => SalesHistoryProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ChangeNotifierProvider(create: (context) => RepMenuProvider()),
      ],
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerConfig: router,
        scrollBehavior: CustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
      );
}

const double windowWidth = 480;
const double windowHeight = 854;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Navigation and routing');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then(
      (screen) {
        setWindowFrame(
          Rect.fromCenter(
            center: screen!.frame.center,
            width: windowWidth,
            height: windowHeight,
          ),
        );
      },
    );
  }
}

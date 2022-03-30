// Copyright 2022 FlexWM Web Based Management. Derechos Reservados
// Author: Mauricio Lopez Barba

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flexwm/common/theme.dart';
import 'package:flexwm/models/cart.dart';
import 'package:flexwm/models/catalog.dart';
import 'package:window_size/window_size.dart';
import 'package:flexwm/screens/cart.dart';
import 'package:flexwm/screens/catalog.dart';
import 'package:flexwm/screens/login.dart';
import 'package:flexwm/screens/photos.dart';
import 'package:flexwm/screens/wfsp_list.dart';
import 'package:flexwm/screens/wfsp_form.dart';

void main() {
  setupWindow();
  runApp(const MyApp());
}

const double windowWidth = 400;
const double windowHeight = 800;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('FlexWM App');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => CatalogModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Provider Demo',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginForm(),
          '/catalog': (context) => const MyCatalog(),
          '/cart': (context) => const MyCart(),
          '/photos': (context) => const MyPhotos(),
          '/wflowsteps': (context) => const WFlowStepList(),
        },
      ),
    );
  }
}
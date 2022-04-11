// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flexwm/common/theme.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:flexwm/models/cart.dart';
import 'package:flexwm/models/catalog.dart';
import 'package:window_size/window_size.dart';
import 'package:flexwm/screens/cart.dart';
import 'package:flexwm/screens/catalog.dart';
import 'package:flexwm/screens/login.dart';
import 'package:flexwm/screens/photos.dart';
import 'package:flexwm/screens/wfsp_list.dart';
import 'package:flexwm/screens/cust_list.dart';


// Metodo de arranque inicial
void main() {
  setupWindow();
  runApp(const MyApp());
}

// Asigna tamaños default
void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('FlexWM App');
    setWindowMinSize(const Size(params.windowWidth, params.windowHeight));
    setWindowMaxSize(const Size(params.windowWidth, params.windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: params.windowWidth,
        height: params.windowHeight,
      ));
    });
  }
}

// Inicio clase base
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
        title: 'FlexWM App',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginForm(),
          '/catalog': (context) => const MyCatalog(),
          '/cart': (context) => const MyCart(),
          '/photos': (context) => const MyPhotos(),
          '/wfsp_list': (context) => const WFlowStepList(),
          '/cust_list': (context) => const CustomerList(),
        },
      ),
    );
  }
}
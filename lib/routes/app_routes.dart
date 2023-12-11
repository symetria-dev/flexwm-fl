import 'package:flexwm/common/params.dart' as params;
import 'package:flexwm/models/crqd.dart';
import 'package:flexwm/routes/routes.dart';
import 'package:flexwm/screens/crqs_list.dart';
import 'package:flexwm/screens/cust_credit_form.dart';
import 'package:flexwm/screens/cust_crqs_form.dart';
import 'package:flexwm/screens/dashboard.dart';
import 'package:flexwm/screens/cameraPhotoId.dart';
import 'package:flexwm/widgets/upload_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/crqs.dart';
import '../screens/crqs_form.dart';

class AppRoutes {
  static const initialRoute = '/';
  static final menuOptions = <MenuOption>[
    MenuOption(
        route: '/catalog',
        leadingWidget: const Icon(Icons.home),
        name: 'Principal',
        screen: const Dashboard()),
      MenuOption(
          route: '/crqs_list',
          leadingWidget: const Icon(Icons.account_balance_wallet_sharp),
          name: 'Mis Créditos',
          screen: const CreditRequestList()),
    /*MenuOption(
        route: '/wfsp_list',
        name: 'Tareas Activas',
        leadingWidget: params.getProperIcon(SoWFlowStep.programCode),
        screen: CrqsForm(creditRequest: SoCreditRequest.empty(),
          creditRequestDetail: SoCreditRequestDetail.empty(),)),*/
    //Se comentan para versión clientes edupass
    MenuOption(
        route: '/privacy',
        name: 'Aviso de Privacidad',
        leadingWidget: Icon(Icons.privacy_tip_rounded, color: Colors.orangeAccent),
        screen: WebViewWidget(
            controller: controller
        )
    ),
   /* MenuOption(
        route: '/user',
        name: 'Usuarios',
        leadingWidget: params.getProperIcon(SoUser.programCode),
        screen: const CameraPhotoId()),*/
    MenuOption(
        route: '/',
        name: 'Salir',
        leadingWidget: const Icon(Icons.exit_to_app),
        screen: const LoginForm()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final options in menuOptions) {
      appRoutes
          .addAll({options.route: (BuildContext context) => options.screen});
    }

    return appRoutes;
  }



}
WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
      // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
     /* if (request.url.startsWith('https://www.youtube.com/')) {
        return NavigationDecision.prevent;
      }*/
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://visualmexico.com.mx/aviso-de-privacidad/'));

//https://visualmexico.com.mx/wp-content/uploads/2022/12/politica-privacidad.pdf
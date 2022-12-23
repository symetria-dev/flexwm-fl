import 'package:flexwm/common/params.dart' as params;
import 'package:flexwm/routes/routes.dart';
import 'package:flexwm/screens/crqs_list.dart';
import 'package:flexwm/screens/cust_credit_form.dart';
import 'package:flexwm/screens/cust_crqs_form.dart';
import 'package:flexwm/screens/dashboard.dart';
import 'package:flexwm/screens/cameraPhotoId.dart';
import 'package:flexwm/widgets/upload_image_widget.dart';

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
    MenuOption(
        route: '/wfsp_list',
        name: 'Tareas Activas',
        leadingWidget: params.getProperIcon(SoWFlowStep.programCode),
        screen: const WFlowStepList()),
    //Se comentan para versión clientes edupass
 /*   MenuOption(
        route: '/cust_list',
        name: 'Clientes',
        leadingWidget: params.getProperIcon(SoCustomer.programCode),
        screen: const CustomerList()),
    MenuOption(
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

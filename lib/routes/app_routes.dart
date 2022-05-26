import 'package:flexwm/common/params.dart' as params;
import 'package:flexwm/routes/routes.dart';

class AppRoutes {
  static const initialRoute = '/';
  static final menuOptions = <MenuOption>[
    MenuOption(
        route: '/catalog',
        leadingWidget: const Icon(Icons.home),
        name: 'Principal',
        screen: const MyCatalog()),
    MenuOption(
        route: '/photos',
        leadingWidget: const Icon(Icons.image),
        name: 'Fotos',
        screen: const MyPhotosPage()),
    MenuOption(
        route: '/wfsp_list',
        name: 'Tareas Activas',
        leadingWidget: params.getProperIcon(SoWFlowStep.programCode),
        screen: const WFlowStepList()),
    MenuOption(
        route: '/cust_list',
        name: 'Clientes',
        leadingWidget: params.getProperIcon(SoCustomer.programCode),
        screen: const CustomerList()),
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

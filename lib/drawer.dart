// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'package:flexwm/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;

Widget getDrawer(BuildContext context) {
  //Listar menus
  final menuOptions = AppRoutes.menuOptions;
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            params.firstname + ' ' + params.lastname,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          accountEmail: Text(
            params.email,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          currentAccountPicture: Image.network(
            params.getAppUrl(params.instance) +
                params.uploadFiles +
                '/' +
                params.photoUrl,
            fit: BoxFit.contain,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg.jpeg'),
              fit: BoxFit.fill,
            ),
          ),
          otherAccountsPictures: const [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('images/isotipo.png'),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(5),
          itemCount: menuOptions.length,
          itemBuilder: (context, i) => ListTile(
            leading: menuOptions[i].leadingWidget,
            title: Text(menuOptions[i].name),
            onTap: () {
              // Update the state of the app
              Navigator.pop(context);
              Navigator.pushNamed(context, menuOptions[i].route);
              // Then close the drawer
              //Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}

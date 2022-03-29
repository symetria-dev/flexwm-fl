import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;

Widget getDrawer(BuildContext context) {
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
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage("images/person.jpg"),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg.jpeg'),
              fit: BoxFit.fill,
            ),
          ),
          otherAccountsPictures: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('images/isotipo.png'),
            ),
          ],
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Principal'),
          onTap: () {
            // Update the state of the app
            Navigator.pop(context);
            Navigator.pushNamed(context, '/catalog');
            // Then close the drawer
            //Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.browse_gallery),
          title: const Text('Catalog'),
          onTap: () {
            // Update the state of the app
            Navigator.pop(context);
            Navigator.pushNamed(context, '/catalog');
            // Then close the drawer
            //Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text('Fotos'),
          onTap: () {
            // Update the state of the app
            Navigator.pop(context);
            Navigator.pushNamed(context, '/photos');
            // Then close the drawer
            //Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.task),
          title: const Text('Tareas'),
          onTap: () {
            // Update the state of the app
            Navigator.pop(context);
            Navigator.pushNamed(context, '/wflowsteps');
            // Then close the drawer
            //Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Salir'),
          onTap: () {
            // Update the state of the app
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
            // Then close the drawer
            //Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}


import 'package:flutter/material.dart';

class AppBarStyle {

  static AppBar authAppBarFlex({
  required String title, TabBar? tabs,
}){
    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white),),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  // Color.fromRGBO(0, 130, 146, 1),
                  // Color.fromRGBO(112, 169, 179, 1.0)
                  Color.fromRGBO(243, 129, 48, 1),
                  Color.fromRGBO(255, 209, 97, 1)
                ]
            )
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      bottom: tabs,
      // toolbarHeight: 65,
      // actions: [
      //   Column(
      //     children: [
      //       IconButton(
      //           onPressed: (){},
      //           icon: const Icon(Icons.account_circle_outlined)
      //       ),
      //       const Text("Avales"),
      //     ],
      //   ),
      //   const SizedBox(width: 10,)
      // ],
    );
  }

}
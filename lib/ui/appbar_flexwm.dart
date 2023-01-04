
import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;

class AppBarStyle {

  static AppBar authAppBarFlex({
  required String title, TabBar? tabs,
}){
    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white),),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: params.theme
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
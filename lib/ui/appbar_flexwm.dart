
import 'package:flutter/material.dart';

class AppBarStyle {

  static AppBar authAppBarFlex({
  required String title,
}){
    return AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white),),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 130, 146, 1),
                  Color.fromRGBO(112, 169, 179, 1.0)
                ]
            )
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

}
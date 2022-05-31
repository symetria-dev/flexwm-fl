import 'package:flutter/material.dart';


class InputDecorations {

  static InputDecoration authInputDecoration({
    String? hintText,
    required String labelText,
    IconData? prefixIcon,
    IconData? sufixIcon
  }) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(37, 131, 170, 1)
          ),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: Color.fromRGBO(37, 131, 170, 1)
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(37, 131, 170, 1),
            width: 2
          )
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey
        ),
        prefixIcon: prefixIcon != null 
          ? Icon( prefixIcon, color: const Color.fromRGBO(37, 131, 170, 1) )
          : null,
        suffixIcon: sufixIcon != null
          ? Icon(sufixIcon, color: const Color.fromRGBO(37, 131, 170, 1),)
          : null
      );
  }  

}
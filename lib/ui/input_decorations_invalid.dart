import 'package:flutter/material.dart';


class InputDecorationsInvalid {

  static InputDecoration authInputDecoration({
    String? hintText,
    required String labelText,
    IconData? prefixIcon,
    IconData? sufixIcon
  }) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red
          ),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.red
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2
          )
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey
        ),
        prefixIcon: prefixIcon != null 
          ? Icon( prefixIcon, color: Colors.red )
          : null,
        suffixIcon: sufixIcon != null
          ? Icon(sufixIcon, color: Colors.red,)
          : null
      );
  }  

}
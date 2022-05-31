import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void resultMessage(String msg, BuildContext context) {
  (Platform.isIOS)
      ? showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Material(
                color: const Color.fromRGBO(255, 255, 255, 0.0),
                child: Text(msg),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          })
      : showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Material(
                color: const Color.fromRGBO(255, 255, 255, 0.0),
                child: Text(msg),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
}

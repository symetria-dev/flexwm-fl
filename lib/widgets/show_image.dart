
import 'package:flutter/material.dart';

void ShowImageAlert(BuildContext context, String url) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero, //this right here
          content: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: SizedBox(
              height: 400,
              child: Image.network(
                url,
              ),
            ),
          ),
        ),
      );
    },
  );
}
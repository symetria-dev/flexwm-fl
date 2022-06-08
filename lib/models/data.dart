// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

// Modelo de clase Customer
import 'package:flutter/material.dart';

class Data {
  int id = -1;
  String label = '';


  Data.empty();

  Data(this.id, this.label,);

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(json['id'] as int,
        json['label'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}

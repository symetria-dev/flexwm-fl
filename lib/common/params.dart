// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

library flexwm.params;
import 'package:flutter/material.dart';

// Constantes
const String jSessionIdQuery = 'jsessionid';
const String uploadFiles = 'uploadfiles';

// Diseño
const Color bgColor = Colors.white;
const Color appBarBgColor = Colors.white;

// Variables
String instance = '';
bool isLoggedIn = false;
String email = '';
String firstname = '';
String lastname = '';
String jSessionId = '';
String photoUrl = '';

// Obtiene el servidor a utilizar
String getAppUrl(String instance) {
  // Revisa si tiene prefijo para ambiente desarrollo
  if (instance[0] == "_") {
    String cleanInstance = instance.substring(1, instance.length);
    return "http://localhost:8080/" + cleanInstance + "/";
  } else if (instance[0] == "-") {
    String cleanInstance = instance.substring(1, instance.length);
    return "https://sandbox.flexwm.com/" + cleanInstance + "/";
  } else {
    return "https://apps.flexwm.com/" + instance + "/";
  }
}

// Icono segun app
Icon getProperIcon(String wFlowCallerCode) {
  if (wFlowCallerCode == 'OPPO') {
    return const Icon(Icons.album_outlined, color: Colors.deepOrange);
  } else if (wFlowCallerCode == 'ORDE') {
    return const Icon(Icons.shopping_bag_outlined, color: Colors.lightBlue);
  } else if (wFlowCallerCode == 'ACTI') {
    return const Icon(Icons.alt_route_sharp, color: Colors.amber);
  } else {
    return const Icon(Icons.task);
  }
}
// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

library flexwm.params;

import 'package:flutter/material.dart';

// Constantes
const double windowWidth = 400;
const double windowHeight = 800;
const String jSessionIdQuery = 'jsessionid';
const String uploadFiles = 'uploadfiles';
const String dateFormat = 'yyyy-MM-dd';
const String offsetQuery = 'offsqry';

const String searchQuery = 's';
const String forceFilter = 'ff';
const String deleteFilter = 'delete';
const String filterValueQuery = 'filterfieldvalue';

const int servletResponseScOk = 200;
const int servletResponseScNotAcceptable = 406;
const int servletResponseScForbidden = 403;
const int servletResponseScInternalServerError = 500;

// Diseño
const Color bgColor = Colors.white;
const Color appBarBgColor = Colors.white;

// Variables de login
String instance = '-edupass';
// String instance = '_flexwm-js';
//String instance = '-demo';
bool isLoggedIn = false;
String email = '';
String firstname = '';
String lastname = '';
String jSessionId = '';
String photoUrl = '';
bool loggedCust = false;
int idLoggedUser = -1;

// Obtiene el id del usuario loggeado
int getIdLoggedUser() {
  return idLoggedUser;
}

//Color para el tema de la app
List<Color> theme = [
  // Color.fromRGBO(0, 130, 146, 1),
  // Color.fromRGBO(112, 169, 179, 1.0)
  const Color.fromRGBO(243, 129, 48, 1),
  const Color.fromRGBO(255, 209, 97, 1)
];

// Obtiene el servidor a utilizar
String getAppUrl(String instance) {
  //Revisa que el parametro de instancia no este vacio
  if (instance != "") {
    // Revisa si tiene prefijo para ambiente desarrollo
    if (instance[0] == '_') {
      String cleanInstance = instance.substring(1, instance.length);
      // return 'http://localhost:8080/' + cleanInstance + '/';
      return 'http://192.168.100.9:8080/' + cleanInstance + '/';
    } else if (instance[0] == "-") {
      String cleanInstance = instance.substring(1, instance.length);
      return 'https://sb.flexwm.com/' + cleanInstance + '/';
    } else {
      return 'https://apps.flexwm.com/' + instance + '/';
    }
  } else {
    //TODO configurar de maneria dinamica instancia default
    //Si se encuentra vacio le seteamos la de local para pruebas
    return 'http://192.168.100.22:8080/flexwm-js/';
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
  } else if (wFlowCallerCode == 'RFQU') {
    return const Icon(Icons.request_page_outlined, color: Colors.green);
  } else if (wFlowCallerCode == 'CUST') {
    return const Icon(Icons.group, color: Colors.green);
  } else {
    return const Icon(Icons.task, color: Colors.blueAccent);
  }
}

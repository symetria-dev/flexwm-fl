// Copyright 2022 FlexWM Web Based Management. Derechos Reservados
// Author: Mauricio Lopez Barba

library flexwm.params;

// Constantes
const String jSessionIdQuery = 'jsessionid';
const String uploadFiles = 'uploadfiles';

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
library flexwm.params;

// Constantes
const String jSessionIdQuery = 'jsessionid';

// Variables
String instance = '';
bool isLoggedIn = false;
String email = '';
String firstname = '';
String lastname = '';
String jSessionId = '';

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
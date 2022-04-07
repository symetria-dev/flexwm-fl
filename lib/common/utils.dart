import 'package:url_launcher/url_launcher.dart';

// Abre mail to
Future<void> makeMail(String url) async {
  print('Intentando llamar a : ' + 'mailto:' + url);
  if (await canLaunch('mailto:' + url)) {
    await launch('mailto:' + url);
  } else {
    throw 'No fue posible abrir mailto: $url';
  }
}

// Clase para hacer llamada telefonica
Future<void> makePhoneCall(String url) async {
  print('Intentando llamar a : ' + 'tel:' + url);
  if (await canLaunch('tel:' + url)) {
    await launch('tel:' + url);
  } else {
    throw 'No fue posible abrir tel: $url';
  }
}
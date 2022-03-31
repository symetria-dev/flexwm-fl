// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

// Modelo de clase tarea
class SoLogin {
  String jSessionId = "";
  String email = "";
  String password = "";
  String firstname = "";
  String lastname = "";
  String photoUrl = "";

  SoLogin.empty();

  SoLogin(this.jSessionId, this.email, this.password, this.firstname, this.lastname, this.photoUrl);

  factory SoLogin.fromJson(Map<String, dynamic> json) {
    return SoLogin(
      json['jSessionId'] as String,
      json['email'] as String,
      json['password'] as String,
      json['firstname'] as String,
      json['lastname'] as String,
      json['photoUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jSessionId': jSessionId,
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'photoUrl': photoUrl,
    };
  }
}

// Modelo de clase tarea
class SoLogin {
  String jSessionId = "";
  String email = "";
  String password = "";
  String firstname = "";
  String lastname = "";

  SoLogin.empty();

  SoLogin(this.jSessionId, this.email, this.password, this.firstname, this.lastname);

  factory SoLogin.fromJson(Map<String, dynamic> json) {
    return SoLogin(
      json['jSessionId'] as String,
      json['email'] as String,
      json['password'] as String,
      json['firstname'] as String,
      json['lastname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jSessionId': jSessionId,
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}
class SoUser {
  static const String programCode = 'USER';

  int id = -1;
  String firstname = "";
  String email = "";
  String password = "";
  String passwordConf = "";
  String photo = "";
  int locationId = -1;
  int areaId = -1;

  SoUser.empty();

  SoUser(this.id, this.firstname, this.email, this.password, this.passwordConf,
      this.locationId, this.areaId, this.photo);

  factory SoUser.fromJson(Map<String, dynamic> json) {
    return SoUser(
      json['id'] as int,
      json['firstname'] as String,
      json['email'] as String,
      json['password'] as String,
      json['passwordConf'] as String,
      json['locationId'] as int,
      json['areaId'] as int,
      json['photo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'email': email,
      'password': password,
      'passwordConf': passwordConf,
      'locationId': locationId,
      'areaId': areaId,
     
    };
  }
}

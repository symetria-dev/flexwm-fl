class SoUserEmail {
  int id = -1;
  int userId = -1;
  String email = "";
  String type = "P";

  static List getTypeOptions = [
    {"value": "P", "label": "Personal"},
    {"value": "W", "label": "Trabajo"}
  ];

  static String kind = 'locations';

  SoUserEmail.empty();

  SoUserEmail(this.id, this.userId, this.email, this.type);

  factory SoUserEmail.fromJson(Map<String, dynamic> json) {
    return SoUserEmail(json['id'] as int, json['userId'] as int,
        json['email'] as String, json['type'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'type': type,
    };
  }
}

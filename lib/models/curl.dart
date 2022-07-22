class SoCustomerRelative {
  int id = -1;
  String type = "P";
  String fullName = "";
  String fatherLastName = "";
  String motherLastName = "";
  String email = "";
  String number = "";
  String cellPhone = "";
  String extension = "";
  int responsible = 0;
  int customerId = -1;

  static List getTypeOptions = [
    {"value": "S", "label": "Esposo(a)"},
    {"value": "F", "label": "Padre"},
    {"value": "M", "label": "Madre"},
    {"value": "B", "label": "Hermano(a)"},
    {"value": "C", "label": "Hijo(a)"},
    {"value": "O", "label": "Otro"},
    {"value": "A", "label": "Amigo(a)"},
    {"value": "P", "label": "Socio"},
    {"value": "W", "label": "Colega"},
  ];

  SoCustomerRelative.empty();

  SoCustomerRelative(this.id, this.type,this.customerId,this.fullName,
      this.fatherLastName,this.motherLastName,this.email,this.number,
      this.cellPhone,this.extension,this.responsible);

  factory SoCustomerRelative.fromJson(Map<String, dynamic> json) {
    return SoCustomerRelative(
        json['id'] as int,
        json['type'] as String,
        json['customerId'] as int,
      json['fullName'] as String,
      json['fatherLastName'] as String,
      json['motherLastName'] as String,
      json['email'] as String,
      json['number'] as String,
      json['cellPhone'] as String,
      json['extension'] as String,
      json['responsible'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'customerId': customerId,
      'fullName' : fullName,
      'fatherLastName' : fatherLastName,
      'motherLastName' : motherLastName,
      'email' : email,
      'number' : number,
      'cellPhone' : cellPhone,
      'extension' : extension,
      'responsible' : responsible
    };
  }

}
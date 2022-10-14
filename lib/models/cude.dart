class SoCustDetail {
  int id = -1;
  String institution= "";
  String location = "";
  String period = "";
  String degreeObtained = "";
  int customerId = -1;
  String maritalStatus = "S";
  String maritalRegimen = "C";
  int economicDependents = 0;
  String typeHousing = "";
  int yearsResidence = 0;
  String relationship = "";

  static List getStatusOptions = [
    {"value": "S", "label": "Soltero(a)"},
    {"value": "M", "label": "Casado(a)"},
    {"value": "D", "label": "Divorciado(a)"},
    {"value": "E", "label": "Separación en Proceso"},
    {"value": "W", "label": "Viudo"},
    {"value": "C", "label": "Concubinato"},
  ];

  static List getRegimenOptions = [
    {"value":"C", "label":"Comunidad"},
    {"value":"S", "label":"Bienes Separados"},
    {"value":"M", "label":"Mixto"},
  ];

  SoCustDetail.empty();

  SoCustDetail(this.id ,this.institution,this.location,this.period,
      this.degreeObtained,this.customerId,this.maritalStatus,this.maritalRegimen,
      this.economicDependents,this.typeHousing,this.yearsResidence,this.relationship);

  factory SoCustDetail.fromJson(Map<String, dynamic> json) {
    return SoCustDetail(
      json['id'] as int,
      json['institution'] as String,
      json['location'] as String,
      json['period'] as String,
      json['degreeObtained'] as String,
      json['customerId'] as int,
      json['maritalStatus'] as String,
      json['maritalRegimen'] as String,
      json['economicDependents'] as int,
      json['typeHousing'] as String,
      json['yearsResidence'] as int,
      json['relationship'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution': institution,
      'location': location,
      'period': period,
      'degreeObtained': degreeObtained,
      'customerId': customerId,
      'maritalStatus': maritalStatus,
      'maritalRegimen': maritalRegimen,
      'economicDependents': economicDependents,
      'typeHousing': typeHousing,
      'yearsResidence': yearsResidence,
      'relationship': relationship,
    };
  }

}
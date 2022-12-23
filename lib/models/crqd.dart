class SoCreditRequestDetail {
  static const String programCode = 'CRQD';
  int id = -1;
  int visaFees = 0;
  int planeTickets = 0;
  double programCost = 0.0;
  double maintenance = 0.0;
  String studiesPlace = "";
  int engagementAgencyId = 0;
  String engagementSchool = "";
  String dateProbablyTravel = "";
  String educationalProgram = "";
  int creditRequestId = -1;
  double verifiableIncome = 0.0;
  int countryId = -1;
  String city = "";
  String educationalInstitution = "";
  String educationalInstitutionType = "";
  String dateStartInstitution = "";
  String dateEndInstitution = "";
  String institution= "";
  String location = "";
  String period = "";
  String degreeObtained = "";

  static String AGENCY_UNO = 'U';
  static String AGENCY_DOS = 'D';

  static String INSTITUTION_TYPE_NATIONAL = 'N';
  static String INSTITUTION_TYPE_INTERNATIONAL = 'I';

  static List getAgencyOptions = [
    {"value": "-", "label": "Seleccione una agencia"},
    {"value": AGENCY_UNO, "label": "Agencia Uno"},
    {"value": AGENCY_DOS, "label": "Agencia Dos"},
  ];

  static List getInstitutionType = [
    {"value": INSTITUTION_TYPE_NATIONAL, "label": "Nacional"},
    {"value": INSTITUTION_TYPE_INTERNATIONAL, "label": "Internacional"},
  ];

  SoCreditRequestDetail.empty();

  SoCreditRequestDetail(this.id,this.visaFees,this.planeTickets,this.programCost,
      this.maintenance,this.studiesPlace,this.engagementAgencyId,
      this.engagementSchool,this.dateProbablyTravel,this.educationalProgram,
      this.creditRequestId,this.verifiableIncome, this.countryId, this.city,
      this.educationalInstitution, this.educationalInstitutionType,
      this.dateStartInstitution, this.dateEndInstitution,this.institution,
      this.location,this.period,this.degreeObtained,
      );

  factory SoCreditRequestDetail.fromJson(Map<String, dynamic> json){
    return SoCreditRequestDetail(
      json['id'] as int,
      json['visaFees'] as int,
      json['planeTickets'] as int,
      json['programCost'] as double,
      json['maintenance'] as double,
      json['studiesPlace'] as String,
      json['engagementAgencyId'] as int,
      json['engagementSchool'] as String,
      json['dateProbablyTravel'] as String,
      json['educationalProgram'] as String,
      json['creditRequestId'] as int,
      json['verifiableIncome'] as double,
      json["countryId"] as int,
      json["city"] as String,
      json['educationalInstitution'] as String,
      json['educationalInstitutionType'] as String,
      json['dateStartInstitution'] as String,
      json['dateEndInstitution'] as String,
      json['institution'] as String,
      json['location'] as String,
      json['period'] as String,
      json['degreeObtained'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'visaFees' : visaFees,
      'planeTickets' : planeTickets,
      'programCost' : programCost,
      'maintenance' : maintenance,
      'studiesPlace' : studiesPlace,
      'engagementAgencyId' : engagementAgencyId,
      'engagementSchool' : engagementSchool,
      'dateProbablyTravel' : dateProbablyTravel,
      'educationalProgram' : educationalProgram,
      'creditRequestId' : creditRequestId,
      'verifiableIncome' : verifiableIncome,
      'countryId' : countryId,
      'city' : city,
      'educationalInstitution' : educationalInstitution,
      'educationalInstitutionType' : educationalInstitutionType,
      'dateStartInstitution' : dateStartInstitution,
      'dateEndInstitution' : dateEndInstitution,
      'institution' : institution,
      'location' : location,
      'period' : period,
      'degreeObtained' : degreeObtained,
    };
  }
}
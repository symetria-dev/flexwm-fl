import 'package:flexwm/models/cust.dart';

class SoCreditRequestGuarantee {
  static const String programCode = 'CRQG';
  int id = -1;
  String relation = "";
  int customerId = -1;
  int creditRequestId = -1;
  String role = "";

  int economicDependents = 0;
  String typeHousing = "";
  int yearsResidence = 0;

  String ciec = "";
  double accountStatement = 0.0;
  double payrollReceipts = 0.0;
  String heritage = "";
  String employmentStatus = STATUS_EMPLOYEE;
  String company = "";
  String economicActivity = "";
  int yearsEmployment = 0;
  double creditCards = 0.0;
  double rent = 0.0;
  double creditAutomotive = 0.0;
  double creditFurniture = 0.0;
  double personalLoans = 0.0;
  double verifiableIncome = 0.0;
  SoCustomer soCustomer = SoCustomer.empty();
  String identification = "";
  String proofIncome = "";
  String fiscalSituation = "";
  String verifiableIncomeFile = "";
  String declaratory = "";
  String identificationBack = "";
  String identityVideo = "";
  String proofAddress = "";

  static String RELATION_SELF = 'Z';
  static String RELATION_PARENT = 'P';
  static String RELATION_SIBLING = 'S';
  static String RELATION_MARITAL = 'M';
  static String RELATION_OTHER = 'O';

  static String ROLE_BENEFICIARY = 'B';
  static String ROLE_ACREDITED = 'A';
  static String ROLE_COACREDITED = 'C';
  static String ROLE_GUARANTEE = 'G';
  static String ROLE_COLLATERAL = 'P';

  static String STATUS_SINGLE = 'S';
  static String STATUS_MARRIED = 'M';
  static String STATUS_DIVORCED = 'D';
  static String STATUS_SEPARATION = 'E';
  static String STATUS_WIDOWED = 'W';
  static String STATUS_CONCUBINAGE = 'C';

  static String REGIMEN_CONJUGAL_SOCIETY = 'C';
  static String REGIMEN_SEPARATION_PROPERTY = 'S';
  static String REGIMEN_MIXED_REGIMEN = 'M';

  static String STATUS_EMPLOYEE = 'E';
  static String STATUS_PROFESSIONAL = 'P';
  static String STATUS_BUSINESSMAN = 'B';
/*

  static List getStatusOptions = [
    {"value": STATUS_SINGLE, "label": "Soltero(a)"},
    {"value": STATUS_MARRIED, "label": "Casado(a)"},
    {"value": STATUS_DIVORCED, "label": "Divorciado(a)"},
    {"value": STATUS_SEPARATION, "label": "Separación en Proceso"},
    {"value": STATUS_WIDOWED, "label": "Viudo"},
    {"value": STATUS_CONCUBINAGE, "label": "Concubinato"},
  ];

  static List getRegimenOptions = [
    {"value": REGIMEN_CONJUGAL_SOCIETY, "label":"Comunidad"},
    {"value": REGIMEN_SEPARATION_PROPERTY, "label":"Bienes Separados"},
    {"value": REGIMEN_MIXED_REGIMEN, "label":"Mixto"},
  ];
*/

  static List getRelationOptions = [
    {"value": RELATION_SELF, "label": "Mismo"},
    {"value": RELATION_PARENT, "label": "Padre/Madre"},
    {"value": RELATION_SIBLING, "label": "Hermano(a)"},
    {"value": RELATION_MARITAL, "label": "Pareja"},
    {"value": RELATION_OTHER, "label": "Otros"},
  ];

  static List getRoleOptions = [
    {"value": ROLE_BENEFICIARY, "label": "Beneficiario"},
    {"value": ROLE_ACREDITED, "label": "Acreditado Titular"},
    {"value": ROLE_COACREDITED, "label": "Coacreditado"},
    {"value": ROLE_GUARANTEE, "label": "Aval"},
    {"value": ROLE_COLLATERAL, "label": "Garante Prendiario"},
  ];

  static List getEmploymentStatus = [
    {"value": STATUS_EMPLOYEE, "label": "Empleado"},
    {"value": STATUS_PROFESSIONAL, "label": "Profesionista"},
    {"value": STATUS_BUSINESSMAN, "label": "Empresario"},
  ];

  static String getLabelRol(String value){
    String role = '';
    List roles = getRoleOptions;
    for(int i =0;i<roles.length;i++){
      if(value == roles[i]['value']){
        role = roles[i]['label'];
      }
    }
    return role;
  }


  SoCreditRequestGuarantee.empty();

  SoCreditRequestGuarantee(this.id,this.relation,this.customerId,this.creditRequestId,
      this.role, this.economicDependents,this.typeHousing,
      this.yearsResidence,this.ciec,this.accountStatement,this.payrollReceipts,this.heritage,
      this.employmentStatus,this.company,this.economicActivity,this.yearsEmployment,
      this.creditCards,this.rent,this.creditAutomotive,this.creditFurniture,this.personalLoans,
      this.verifiableIncome, this.soCustomer,this.identification,this.proofIncome,
      this.fiscalSituation,this.verifiableIncomeFile,this.declaratory, this.identificationBack,
      this.identityVideo, this.proofAddress);

  factory SoCreditRequestGuarantee.fromJson(Map<String, dynamic> json){
    return SoCreditRequestGuarantee(
      json['id'] as int,
      json['relation'] as String,
      json['customerId'] as int,
      json['creditRequestId'] as int,
      json['role'] as String,
      json['economicDependents'] as int,
      json['typeHousing'] as String,
      json['yearsResidence'] as int,
      json['ciec'] as String,
      json['accountStatement'] as double,
      json['payrollReceipts'] as double,
      json['heritage'] as String,
      json['employmentStatus'] as String,
      json['company'] as String,
      json['economicActivity'] as String,
      json['yearsEmployment'] as int,
      json['creditCards'] as double,
      json['rent'] as double,
      json['creditAutomotive'] as double,
      json['creditFurniture'] as double,
      json['personalLoans'] as double,
      json['verifiableIncome'] as double,
      SoCustomer(json['soCustomer']['id'] as int,
        json['soCustomer']['code'] as String,
        json['soCustomer']['displayName'] as String,
        json['soCustomer']['legalName'] as String,
        json['soCustomer']['logo'] as String,
        json['soCustomer']['phone'] as String,
        json['soCustomer']['email'] as String,
        json['soCustomer']['referralId'] as int,
        json['soCustomer']['referralComments'] as String,
        json['soCustomer']['customerType'] as String,
        json['soCustomer']['rfc'] as String,
        json['soCustomer']['firstName'] as String,
        json['soCustomer']['fatherLastName'] as String,
        json['soCustomer']['salesManId'] as int,
        json['soCustomer']['nss'] as String,
        json['soCustomer']['stablishMentDate'] as String,

        json['soCustomer']['birthdate'] as String,
        json['soCustomer']['passw'] as String,
        json['soCustomer']['passwconf'] as String,

        json['soCustomer']['curp'] as String,
        json['soCustomer']['recommendedBy'] as int,
        json['soCustomer']['motherlastname'] as String,
        json['soCustomer']['maritalStatus'] as String,
        json['soCustomer']['mobile'] as String,
        json['soCustomer']['maritalRegime'] as String,
        json['soCustomer']['spouseName'] as String,
          ),
      json['identification'] as String,
      json['proofIncome'] as String,
      json['fiscalSituation'] as String,
      json['verifiableIncomeFile'] as String,
      json['declaratory'] as String,
      json['identificationBack'] as String,
      json['identityVideo'] as String,
      json['proofAddress'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'relation' : relation,
      'customerId' : customerId,
      'creditRequestId' : creditRequestId,
      'role' : role,
      'economicDependents': economicDependents,
      'typeHousing': typeHousing,
      'yearsResidence': yearsResidence,
      'ciec' : ciec,
      'accountStatement' : accountStatement,
      'payrollReceipts' : payrollReceipts,
      'heritage' : heritage,
      'employmentStatus' : employmentStatus,
      'company' : company,
      'economicActivity' : economicActivity,
      'yearsEmployment' : yearsEmployment,
      'creditCards' : creditCards,
      'rent' : rent,
      'creditAutomotive' : creditAutomotive,
      'creditFurniture' : creditFurniture,
      'personalLoans' : personalLoans,
      'verifiableIncome' : verifiableIncome,
      'soCustomer' : soCustomer,
      'identification' : identification,
      'proofIncome' : proofIncome,
      'fiscalSituation' : fiscalSituation,
      'verifiableIncomeFile' : verifiableIncomeFile,
      'declaratory' : declaratory,
      'identificationBack' : identificationBack,
      'identityVideo' : identityVideo,
      'proofAddress' : proofAddress,
    };
  }
}
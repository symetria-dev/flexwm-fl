import 'package:flexwm/models/wflw.dart';

class SoCreditRequest {
  int id = -1;
  String destiny = "D";
  double amountRequired = 0.0;
  int deadlineRequired = 0;
  double monthlyPayment = 0.0;
  int customerId = -1;
  int currencyId = -1;
  int creditTypeId = -1;
  int creditProfileId = -1;
  String code = "";
  String status = "";
  int wFlowId = -1;
  String fiscalRegime = '';
  int creditBureau = 0;
  SoWFlow soWFlow = SoWFlow.empty();
  /*String employmentStatus = 'E';
  String company = "";
  String economicActivity = "";
  String yearsEmployment = "";
  double creditCards = 0.0;
  double rent = 0.0;
  double creditAutomotive = 0.0;
  double creditFurniture = 0.0;
  double personalLoans = 0.0;

  double monthlyIncome = 0.0;
  double otherIncome = 0.0;
  double aproximateMonthlyPay = 0.0;*/

  static String STATUS_EDITION = 'E';
  static String STATUS_REVISION = 'R';
  static String STATUS_AUTHORIZED = 'A';
  static String STATUS_CANCELLED = 'C';

  static String FISCALREGIME_PERSON = 'P';
  static String FISCALREGIME_PERSONACTIVITY = 'A';
  static String FISCALREGIME_COMPANY = 'C';

  static List getDestinyOptions = [
    {"value": "D", "label": "Diplomado"},
    {"value": "P", "label": "Preparatoria"},
    {"value": "I", "label": "Inscripciones"},
    {"value": "M", "label": "Maestría"},
    {"value": "L", "label": "Licenciatura"},
  ];

  static List getFiscalRegime = [
    {"value": FISCALREGIME_PERSON, "label": "Persona Fisica"},
    {"value": FISCALREGIME_PERSONACTIVITY, "label": "Persona Fisica Act. Emp."},
    {"value": FISCALREGIME_COMPANY, "label": "Persona Moral"},
  ];
  static String getStatusText(String value){
    String status = '';
    switch(value){
      case 'E':{
        status = 'Edición';
      }
      break;
      case 'R':{
        status = 'Revisión';
      }
      break;
      case 'A':{
        status = 'Autorizado';
      }
      break;
      case 'C':{
        status = 'Cancelada';
      }
      break;
    }

    return status;
  }

  static String getStatusPorcent(String value){
    String statusPorcent = '';
    return statusPorcent;
  }
  static String getCreditDestiny(String value){
    String destiny = '';
    for(int i = 0;i < getDestinyOptions.length;i++){
      if(getDestinyOptions[i]['value'] == value){
        destiny = getDestinyOptions[i]['label'];
      }
    }
    return destiny;
  }

  static List getEmploymentStatus = [
    {"value": "E", "label": "Empleado"},
    {"value": "P", "label": "Profesionista"},
    {"value": "B", "label": "Empresario"},
  ];

  SoCreditRequest.empty();

  SoCreditRequest(this.id, this.destiny,this.customerId,this.amountRequired,
      this.deadlineRequired,this.monthlyPayment,this.currencyId,this.creditTypeId,
      this.creditProfileId, this.code, this.status,
      this.wFlowId, this.fiscalRegime, this.creditBureau, this.soWFlow);

  factory SoCreditRequest.fromJson(Map<String, dynamic> json) {
    return SoCreditRequest(
      json['id'] as int,
      json['destiny'] as String,
      json['customerId'] as int,
      json['amountRequired'] as double,
      json['deadlineRequired'] as int,
      json['monthlyPayment'] as double,
      json['currencyId'] as int,
      json['creditTypeId'] as int,
      json['creditProfileId'] as int,
      json['code'] as String,
      json['status'] as String,
      json['wFlowId'] as int,
      json['fiscalRegime'] as String,
      json['creditBureau'] as int,
      SoWFlow(
        json['soWFlow']['id'] as int,
        json['soWFlow']['code'] as String,
        json['soWFlow']['name'] as String,
        json['soWFlow']['description'] as String,
        json['soWFlow']['userMsgs'] as bool,
        json['soWFlow']['customerMsgs'] as bool,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destiny': destiny,
      'customerId': customerId,
      'amountRequired' : amountRequired,
      'deadlineRequired' : deadlineRequired,
      'monthlyPayment' : monthlyPayment,
      'currencyId' : currencyId,
      'creditTypeId' : creditTypeId,
      'creditProfileId' : creditProfileId,
      'code' : code,
      'status' : status,
      'wFlowId' : wFlowId,
      'fiscalRegime' : fiscalRegime,
      'creditBureau' : creditBureau,
      'soWFlow' : soWFlow,
    };
  }

}
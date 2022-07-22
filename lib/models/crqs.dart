class SoCreditRequest {
  int id = -1;
  String destiny = "D";
  double amountRequired = 0.0;
  int deadlineRequired = 0;
  double monthlyPayment = 0.0;
  int customerId = -1;
  int currencyId = -1;
  int creditTypeId = -1;
  int oderTypeId = -1;
  int creditProfileId = -1;
  int wflowTypeId = -1;

  static List getDestinyOptions = [
    {"value": "D", "label": "Diplomado"},
    {"value": "P", "label": "Preparatoria"},
    {"value": "I", "label": "Inscripciones"},
    {"value": "M", "label": "Maestría"},
    {"value": "L", "label": "Licenciatura"},
  ];

  SoCreditRequest.empty();

  SoCreditRequest(this.id, this.destiny,this.customerId,this.amountRequired,
      this.deadlineRequired,this.monthlyPayment,this.currencyId,this.creditTypeId,
      this.oderTypeId,this.creditProfileId, this.wflowTypeId);

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
      json['oderTypeId'] as int,
      json['creditProfileId'] as int,
      json['wflowTypeId'] as int,
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
      'oderTypeId' : oderTypeId,
      'creditProfileId' : creditProfileId,
      'wflowTypeId' : wflowTypeId,
    };
  }

}
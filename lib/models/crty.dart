class SoCreditType {
  static const String programCode = 'CRTY';
  int id = -1;
  String name = "";
  String description = "";
  int periods = 0;
  double minAmount = 0.0;
  double maxAmount = 0.0;
  double grant = 0.0;
  String status = "";
  int maxStart = 0;
  double maxGrant = 0.0;
  String startDate = "";
  String endDate = "";
  int publicRequest = 0;
  int multiDisbursement = 0;
  int guarantees = 0;
  int requestWFlowTypeId = 0;
  int creditWFlowTypeId = 0;
  int creditCategoryId = 0;

  SoCreditType.empty();

  SoCreditType(this.id,this.name,this.description,this.periods,this.minAmount,
      this.maxAmount,this.grant,this.status,this.maxStart,this.maxGrant,
      this.startDate,this.endDate,this.publicRequest,this.multiDisbursement,
      this.guarantees,this.requestWFlowTypeId,this.creditWFlowTypeId,
      this.creditCategoryId);

  factory SoCreditType.fromJson(Map<String, dynamic> json){
    return SoCreditType(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['periods'] as int,
      json['minAmount'] as double,
      json['maxAmount'] as double,
      json['grant'] as double,
      json['status'] as String,
      json['maxStart'] as int,
      json['maxGrant'] as double,
      json['startDate'] as String,
      json['endDate'] as String,
      json['publicRequest'] as int,
      json['multiDisbursement'] as int,
      json['guarantees'] as int,
      json['requestWFlowTypeId'] as int,
      json['creditWFlowTypeId'] as int,
      json['creditCategoryId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'description' : description,
      'periods' : periods,
      'minAmount' : minAmount,
      'maxAmount' : maxAmount,
      'grant' : grant,
      'status' : status,
      'maxStart' : maxStart,
      'maxGrant' : maxGrant,
      'startDate' : startDate,
      'endDate' : endDate,
      'publicRequest' : publicRequest,
      'multiDisbursement' : multiDisbursement,
      'guarantees' : guarantees,
      'requestWFlowTypeId' : requestWFlowTypeId,
      'creditWFlowTypeId' : creditWFlowTypeId,
      'creditCategoryId' : creditCategoryId,
    };
  }
}
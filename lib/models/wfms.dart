class SoWFlowMessage {
  int id = -1;
  String type = "";
  String datetime = "";
  String message = "";
  int customerId = 0;
  int userId = 0;
  int wflowId = 0;

  static String TYPE_SYS = 'S';
  static String TYPE_USER = 'U';
  static String TYPE_CUSTOMER ='C';


  SoWFlowMessage.empty();

  SoWFlowMessage(this.id,this.type,this.datetime,this.message,this.customerId,
      this.userId,this.wflowId);

  factory SoWFlowMessage.fromJson(Map<String, dynamic> json){
    return SoWFlowMessage(
      json['id'] as int,
      json['type'] as String,
      json['datetime'] as String,
      json['message'] as String,
      json['customerId'] as int,
      json['userId'] as int,
      json['wflowId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'type' : type,
      'datetime' : datetime,
      'message' : message,
      'customerId' : customerId,
      'userId' : userId,
      'wflowId' : wflowId,
    };
  }
}
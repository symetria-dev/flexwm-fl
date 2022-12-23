class SoWFlow {
  int id = -1;
  String code = "";
  String name = "";
  String description = "";
  bool userMsgs = false;
  bool customerMsgs = false;

  SoWFlow.empty();

  SoWFlow(this.id,this.code, this.name, this.description, this.userMsgs,
      this.customerMsgs);

  factory SoWFlow.fromJson(Map<String, dynamic> json){
    return SoWFlow(
      json['id'] as int,
      json['code'] as String,
      json['name'] as String,
      json['description'] as String,
      json['userMsgs'] as bool,
      json['customerMsgs'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'code' : code,
      'name' : name,
      'description' : description,
      'userMsgs' : userMsgs,
      'customerMsgs' : customerMsgs,
    };
  }
}
class SoCustAddres {
  int id = -1;
  String type = "P";
  String street ="";
  String number = "";
  String neighborhood = "";
  String zip = "";
  String description = "";
  int cityId = -1;
  int customerId = -1;
  int deliveryAddress = 0;
  String interiorNumber = "";

  static List getTypeOptions = [
    {"value": "P", "label": "Personal"},
    {"value": "W", "label": "Trabajo"},
    {"value": "F", "label": "Domicilio Fiscal"}
  ];

  SoCustAddres.empty();

  SoCustAddres(this.id, this.type,this.street,this.number,this.neighborhood,
      this.zip,this.description,this.cityId,this.customerId,
      this.deliveryAddress,this.interiorNumber);

  factory SoCustAddres.fromJson(Map<String, dynamic> json) {
    return SoCustAddres(
        json['id'] as int,
        json['type'] as String,
        json['street'] as String,
        json['number'] as String,
        json['neighborhood'] as String,
        json['zip'] as String,
        json['description'] as String,
        json['cityId'] as int,
        json['customerId'] as int,
        json['deliveryAddress'] as int,
        json['interiorNumber'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'street': street,
      'number': number,
      'neighborhood': neighborhood,
      'zip': zip,
      'description': description,
      'cityId': cityId,
      'customerId': customerId,
      'deliveryAddress': deliveryAddress,
      'interiorNumber': interiorNumber
    };
  }

}
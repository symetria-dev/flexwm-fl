class SoCreditRequestAsset {
  int id = -1;
  String type = "";
  String description = "";
  double value = 0.0;
  String purchaseDate = "";
  String photo = "";

  // Campos Inmueble
  String folio = "";
  String deedNumber = "";
  String civicNumber = "";
  String street = "";
  String extNumber = "";
  String intNumber = "";
  String zip = "";

  // Campos automovil
  String invoice = "";
  String brand = "";
  String model = "";
  int year = 0;
  String serial = "";
  String motor = "";

  String comments = "";
  String status = "";

  int cityId = 0;
  int creditRequestGuaranteeId = 0;
  int creditRequestId = 0;

  static String TYPE_AUTO = 'A';
  static String TYPE_PROPERTY = 'P';

  static String STATUS_REVISION = 'P';
  static String STATUS_AUTHORIZED = 'A';
  static String STATUS_REJECTED = 'R';

  static List getTypeOptions = [
    {"value": "-", "label": "Seleccione una agencia"},
    {"value": TYPE_AUTO, "label": "Automovil"},
    {"value": TYPE_PROPERTY, "label": "Inmueble"},
  ];

  SoCreditRequestAsset.empty();

  SoCreditRequestAsset(this.id,this.type,this.description,this.value,
      this.purchaseDate,this.photo,this.folio,this.deedNumber,this.civicNumber,
      this.street,this.extNumber,this.intNumber,this.zip,this.invoice,this.brand,
      this.model,this.year,this.serial,this.motor,this.comments,this.status,
      this.cityId,this.creditRequestGuaranteeId,this.creditRequestId,);

  factory SoCreditRequestAsset.fromJson(Map<String, dynamic> json){
    return SoCreditRequestAsset(
      json['id'] as int,
      json['type'] as String,
      json['description'] as String,
      json['value'] as double,
      json['purchaseDate'] as String,
      json['photo'] as String,
      json['folio'] as String,
      json['deedNumber'] as String,
      json['civicNumber'] as String,
      json['street'] as String,
      json['extNumber'] as String,
      json['intNumber'] as String,
      json['zip'] as String,
      json['invoice'] as String,
      json['brand'] as String,
      json['model'] as String,
      json['year'] as int,
      json['serial'] as String,
      json['motor'] as String,
      json['comments'] as String,
      json['status'] as String,
      json['cityId'] as int,
      json['creditRequestGuaranteeId'] as int,
      json['creditRequestId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'type' : type,
      'description' : description,
      'value' : value,
      'purchaseDate' : purchaseDate,
      'photo' : photo,
      'folio' : folio,
      'deedNumber' : deedNumber,
      'civicNumber' : civicNumber,
      'street' : street,
      'extNumber' : extNumber,
      'intNumber' : intNumber,
      'zip' : zip,
      'invoice' : invoice,
      'brand' : brand,
      'model' : model,
      'year' : year,
      'serial' : serial,
      'motor' : motor,
      'comments' : comments,
      'status' : status,
      'cityId' : cityId,
      'creditRequestGuaranteeId' : creditRequestGuaranteeId,
      'creditRequestId' : creditRequestId,
    };
  }
}
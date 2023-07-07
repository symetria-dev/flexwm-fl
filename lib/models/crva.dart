class SoCreditValidation {
  static const String programCode = 'CRVA';
  int id = -1;
  String description = '';
  String comments = '';
  String startDate = '';
  int required = 0;
  int minScore = 0;
  int score = 0;
  String json = '';
  String status = '';
  String result = '';
  int creditRequestGuaranteeId = 0;
  int creditTypeValidationId = 0;
  int webServiceId = 0;
  int creditRequestId = 0;
  String name = '';
  String nameValidation = '';

  // Estatus
  static String STATUS_INIT = 'I';
  static String STATUS_EXECUTE = 'X';
  static String STATUS_FINISHED = 'F';
  static String STATUS_ERROR = 'E';

  // Resultado
  static String RESULT_PENDING = 'P';
  static String RESULT_AUTHORIZED = 'A';
  static String RESULT_REJECTED = 'R';
  static String RESULT_NOTREQUIRED = 'N';

  static List getResultOptions = [
    {"value": RESULT_PENDING, "label":"Pendiente"},
    {"value": RESULT_AUTHORIZED, "label":"Aprobado"},
    {"value": RESULT_REJECTED, "label":"Rechazado"},
    {"value": RESULT_NOTREQUIRED, "label":"No Requerido"},
  ];

  static List getStatusOptions = [
    {"value": STATUS_INIT, "label":"Sin Iniciar"},
    {"value": STATUS_EXECUTE, "label":"Ejecutar"},
    {"value": STATUS_FINISHED, "label":"Finalizado"},
    {"value": STATUS_ERROR, "label":"Error"},
  ];

  static String getLabelType(String value){
    String role = '';
    List roles = getResultOptions;
    for(int i =0;i<roles.length;i++){
      if(value == roles[i]['value']){
        role = roles[i]['label'];
      }
    }
    return role;
  }

  static String getLabelStatus(String value){
    String role = '';
    List roles = getStatusOptions;
    for(int i =0;i<roles.length;i++){
      if(value == roles[i]['value']){
        role = roles[i]['label'];
      }
    }
    return role;
  }

  SoCreditValidation.empty();

  SoCreditValidation(this.id,this.description,this.comments,this.startDate,
      this.required,this.minScore,this.score,this.json,this.status,this.result,
      this.creditRequestGuaranteeId,this.creditTypeValidationId,
      this.webServiceId,this.creditRequestId,this.name, this.nameValidation);

  factory SoCreditValidation.fromJson(Map<String, dynamic> json){
    return SoCreditValidation(
      json['id'] as int,
      json['description'] as String,
      json['comments'] as String,
      json['startDate'] as String,
      json['required'] as int,
      json['minScore'] as int,
      json['score'] as int,
      json['json'] as String,
      json['status'] as String,
      json['result'] as String,
      json['creditRequestGuaranteeId'] as int,
      json['creditTypeValidationId'] as int,
      json['webServiceId'] as int,
      json['creditRequestId'] as int,
      json['name'] as String,
      json['nameValidation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'description' : description,
      'comments' : comments,
      'startDate' : startDate,
      'required' : required,
      'minScore' : minScore,
      'score' : score,
      'json' : json,
      'status' : status,
      'result' : result,
      'creditRequestGuaranteeId' : creditRequestGuaranteeId,
      'creditTypeValidationId' : creditTypeValidationId,
      'webServiceId' : webServiceId,
      'creditRequestId' : creditRequestId,
      'name' : name,
      'nameValidation' : nameValidation,
    };
  }
}
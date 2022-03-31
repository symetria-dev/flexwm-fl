// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

// Modelo de clase tarea
class SoWFlowStep {
  int id = -1;
  String wFlowCode = "";
  String wFlowName = "";
  String wFlowCallerCode = "";
  String customerCode = "";
  String customerDisplayName = "";
  String customerLogo = "";
  String name = "";
  String description = "";
  int progress = 0;
  String remindDate = "";

  SoWFlowStep.empty();

  SoWFlowStep(this.id, this.wFlowCode, this.wFlowName, this.wFlowCallerCode,
      this.customerCode, this.customerDisplayName, this.customerLogo,
      this.name, this.description, this.progress, this.remindDate);

  factory SoWFlowStep.fromJson(Map<String, dynamic> json) {
    return SoWFlowStep(json['id'] as int,
        json['wFlowCode'] as String,
        json['wFlowName'] as String,
        json['wFlowCallerCode'] as String,
        json['customerCode'] as String,
        json['customerDisplayName'] as String,
        json['customerLogo'] as String,
        json['name'] as String,
        json['description'] as String,
        json['progress'] as int,
        json['remindDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wFlowCode': wFlowCode,
      'wFlowName': wFlowName,
      'wFlowCallerCode': wFlowCallerCode,
      'customerCode': customerCode,
      'customerDisplayName': customerDisplayName,
      'customerLogo': customerLogo,
      'name': name,
      'description': description,
      'progress': progress,
      'remindDate': remindDate,
    };
  }
}
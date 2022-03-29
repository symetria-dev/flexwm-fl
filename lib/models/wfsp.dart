
// Modelo de clase tarea
class SoWFlowStep {
  int id = -1;
  String header = "";
  String name = "";
  String description = "";
  int progress = 0;

  SoWFlowStep.empty();

  SoWFlowStep(this.id, this.header, this.name, this.description, this.progress);

  factory SoWFlowStep.fromJson(Map<String, dynamic> json) {
    return SoWFlowStep(json['id'] as int, json['header'] as String, json['name'] as String, json['description'] as String, json['progress'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'header': header,
      'name': name,
      'description': description,
      'progress': progress,
    };
  }
}
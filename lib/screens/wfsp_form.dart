// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flexwm/models/wfsp.dart';
import 'package:flexwm/common/params.dart' as params;

// Create a Form widget.
class WFlowStepForm extends StatefulWidget {
  final String requiredAttrib;

  // Constructor obliga a obtener el id
  const WFlowStepForm({Key? key, required this.requiredAttrib})
      : super(key: key);

  @override
  WFlowStepFormState createState() {
    return WFlowStepFormState();
  }
}

// Forma de wflowstep con estado
class WFlowStepFormState extends State<WFlowStepForm> {
  final _formKey = GlobalKey<FormState>();
  SoWFlowStep soWFlowStep = SoWFlowStep.empty();
  late Future<SoWFlowStep> _futureSoWFlowStep;

  // Variables auxiliares de campos
  final descriptionController = TextEditingController();
  final commentsController = TextEditingController();
  final remindDateController = TextEditingController();
  String progress = '';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _futureSoWFlowStep = fetchWFlowStep(widget.requiredAttrib);
  }

  @override
  void dispose() {
    // Libera los controladores
    descriptionController.dispose();
    commentsController.dispose();
    remindDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: params.bgColor,
      appBar: AppBar(
        title: Text('Tarea', style: Theme.of(context).textTheme.headline6),
        backgroundColor: params.appBarBgColor,
      ),
      body: Center(
        child: FutureBuilder<SoWFlowStep>(
          future: _futureSoWFlowStep,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Tiene datos prepara forma,
              // pone exclamacion ! porque ya valido que no es nulo
              return getForm(context, snapshot.data!);
            } else if (snapshot.hasError) {
              // Hay errores los muestra
              return Text('${snapshot.error}');
            } else {
              // Muestra icono avance
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  // Prepara la forma
  Widget getForm(BuildContext context, SoWFlowStep getSoWFlowStep) {
    soWFlowStep = getSoWFlowStep;
    descriptionController.text = soWFlowStep.description;
    remindDateController.text = soWFlowStep.remindDate;
    progress = soWFlowStep.progress.toString();
    selectedDate = DateTime.parse(soWFlowStep.remindDate);

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            getHeader(soWFlowStep),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Descripcion',
              ),
              controller: descriptionController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Agregar Comentario',
              ),
              controller: commentsController,
            ),
            remindDateDateField(context),
            getProgressComboBox(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Valida la forma, si regresa verdadero actua
                  if (_formKey.currentState!.validate()) {
                    // Actualiza registro
                    updateWFlowStep();
                  }
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget de header
  Widget getHeader(SoWFlowStep soWFlowStep) {
    return Card(
      child: ListTile(
        leading: params.getProperIcon(soWFlowStep.wFlowCallerCode),
        title: Text(soWFlowStep.name),
        subtitle: Text(soWFlowStep.wFlowCode + ' ' + soWFlowStep.wFlowName +
            '\n' +
            '' + soWFlowStep.customerCode +
            ' ' +
            soWFlowStep.customerDisplayName),
        trailing: Image.network(
          params.getAppUrl(params.instance) +
              params.uploadFiles +
              '/' +
              soWFlowStep.customerLogo,
          width: 100,
          height: 100,
          errorBuilder: (context, error, stackTrace) {
            return const Text('');
          },
        ),
      ),
    );
  }

  // Combo box de porcentajes
  Widget getProgressComboBox() {
    return DropdownButtonFormField<String>(
      value: progress,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      onChanged: (String? newValue) {
        progress = newValue!;
      },
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: '% Avance',
      ),
      items: <String>['0', '25', '50', '75', '100']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // Widget de fecha
  remindDateDateField(BuildContext context) {
    DateFormat formatter = DateFormat(params.dateFormat);

    return TextFormField(
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Fecha recordatorio',
      ),
      controller: remindDateController,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: selectedDate == null ? DateTime.now() : selectedDate!,
          firstDate: DateTime(2000),
          lastDate: DateTime(2222),
        ).then((date) {
          //setState(() {
          selectedDate = date;
          String fDate = formatter.format(date!);
          remindDateController.text = fDate;
          //});
        });
      },
    );
  }

  // Obtiene los datos del registro
  Future<SoWFlowStep> fetchWFlowStep(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restwflowstep;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?id=' +
            id.toString()));

    // Si no es exitoso envia a login
    if (response.statusCode != 200) {
      Navigator.pushNamed(context, '/');
    }

    return SoWFlowStep.fromJson(jsonDecode(response.body));
  }

  // Actualiza el wflowstep en el servidor
  Future<SoWFlowStep> updateWFlowStep() async {
    soWFlowStep.description = descriptionController.text;
    soWFlowStep.comments = commentsController.text;
    soWFlowStep.remindDate = remindDateController.text;
    soWFlowStep.progress = int.parse(progress);

    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restwflowstep;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie': params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soWFlowStep),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Almacenado Exitosamente')),
      );

      // Update the state of the app
      Navigator.pop(context);
      Navigator.pushNamed(context, '/wflowsteps');

      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return SoWFlowStep.fromJson(jsonDecode(response.body));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al Guardar')),
      );
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception(
          'Failed to create album. ' + response.statusCode.toString());
    }
  }
}

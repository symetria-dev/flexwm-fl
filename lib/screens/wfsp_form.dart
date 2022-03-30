// Copyright 2022 FlexWM Web Based Management. Derechos Reservados
// Author: Mauricio Lopez Barba

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/models/wfsp.dart';
import 'package:flutter/cupertino.dart';
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
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String progress = '';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _futureSoWFlowStep = fetchWFlowStep(widget.requiredAttrib);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle Tarea'),
      ),
      body: Center(
        child: FutureBuilder<SoWFlowStep>(
          future: _futureSoWFlowStep,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Tiene datos prepara forma,
              // pone exclamacion ! porque ya valido que no es nulo
              return getForm(snapshot.data!);
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
  Widget getForm(SoWFlowStep getSoWFlowStep) {
    soWFlowStep = getSoWFlowStep;
    nameController.text = soWFlowStep.name;
    descriptionController.text = soWFlowStep.description;
    progress = soWFlowStep.progress.toString();

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Divider(
            height: 20,
            thickness: 5,
            indent: 0,
            endIndent: 0,
            color: Colors.white,
          ),
          Text(
            soWFlowStep.header,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const Divider(
            height: 20,
            thickness: 5,
            indent: 0,
            endIndent: 0,
            color: Colors.black54,
          ),
          TextFormField(
            //initialValue: soWFlowStep.name,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nombre',
            ),
            controller: nameController,
          ),
          TextFormField(
            //initialValue: soWFlowStep.description,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Descripcion',
            ),
            controller: descriptionController,
          ),
          getProgressComboBox(),
          CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime(1969, 1, 1),
            onDateTimeChanged: (DateTime newDateTime) {
              // Do something
            },
          ),
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
        labelText: 'Avance',
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return SoWFlowStep.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Error al obtener registro: ' + response.statusCode.toString());
    }
  }

  // Actualiza el wflowstep en el servidor
  Future<SoWFlowStep> updateWFlowStep() async {
    soWFlowStep.name = nameController.text;
    soWFlowStep.description = descriptionController.text;
    soWFlowStep.progress = int.parse(progress);

    final response = await http.post(
      Uri.parse('http://localhost:8080/flexwm-js/restwflowstep'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
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

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/models/wfsp.dart';
import 'package:flexwm/common/params.dart' as params;

// Create a Form widget.
class WFlowStepForm extends StatefulWidget {
  const WFlowStepForm({Key? key}) : super(key: key);

  @override
  WFlowStepFormState createState() {
    return WFlowStepFormState();
  }
}

// Forma de wflowstep con estado
class WFlowStepFormState extends State<WFlowStepForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  SoWFlowStep soWFlowStep = SoWFlowStep.empty();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle Tarea'),
        ),
        body: Center(
          child: FutureBuilder<SoWFlowStep>(
            future: fetchWFlowStep(arguments['id']),
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
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      );
  }

  // Obtiene los datos del registro
  Future<SoWFlowStep> fetchWFlowStep(int id) async {
    final response = await http.get(Uri.parse('http://localhost:8080/flexwm-js/restwflowstep;' + params.jSessionIdQuery + '=' + params.jSessionId + '?id=' + id.toString()));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return SoWFlowStep.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Error al obtener registro: ' + response.statusCode.toString());
    }
  }

  // Prepara la forma
  Widget getForm(SoWFlowStep getSoWFlowStep) {
    soWFlowStep = getSoWFlowStep;

    nameController.text = soWFlowStep.name;
    descriptionController.text = soWFlowStep.description;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(soWFlowStep.name + ' (' + soWFlowStep.id.toString() + ')',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Text(soWFlowStep.header,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
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
          CheckboxListTile(title: Text('Finalizar Tarea'),
              secondary: Icon(Icons.task),
              controlAffinity: ListTileControlAffinity.platform,
              value: true,
              onChanged: (bool? value) {
                setState((){
                  print(value);
                });
              },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  updateWFlowStep();
                }
              },
              child: const Text('Guardar',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),),
            ),
          ),
        ],
      ),
    );
  }

  // Actualiza el wflowstep en el servidor
  Future<SoWFlowStep> updateWFlowStep() async {
    soWFlowStep.name = nameController.text;
    soWFlowStep.description = descriptionController.text;

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
      throw Exception('Failed to create album. ' + response.statusCode.toString());
    }
  }
}

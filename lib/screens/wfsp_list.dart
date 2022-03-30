// Copyright 2022 FlexWM Web Based Management. Derechos Reservados
// Author: Mauricio Lopez Barba

import 'dart:async';
import 'dart:convert';
import 'package:flexwm/screens/wfsp_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/drawer.dart';
import 'package:flexwm/models/wfsp.dart';
import 'package:flexwm/common/params.dart' as params;

// Clase que genera el widget contenedor de wflowsteps
class WFlowStepList extends StatelessWidget {
  const WFlowStepList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
      ),
      body: FutureBuilder<List<SoWFlowStep>>(
        future: fetchSoWFlowSteps(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Error al obtener los datos
            return Center(
              child: Text('An error has occurred: ' + snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            // Prepara la clase que genera el widget de la lista
            return SoWFlowStepList(sOWFlowSteps: snapshot.data!);
          } else {
            // No ha llegado la informacion muestra indicador de progreso
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      drawer: getDrawer(context),
    );
  }

  // Genera la peticion de datos al servidor
  Future<List<SoWFlowStep>> fetchSoWFlowSteps(http.Client client) async {
    final response = await client.get(Uri.parse(params.getAppUrl(params.instance) + 'restwflowstep;' + params.jSessionIdQuery + '=' + params.jSessionId));

    // Use the compute function to run parsePhotos in a separate isolate.
    return compute(parseSoWFlowSteps, response.body);
  }

  // A function that converts a response body into a List<Photo>.
  List<SoWFlowStep> parseSoWFlowSteps(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<SoWFlowStep>((json) => SoWFlowStep.fromJson(json)).toList();
  }
}

// Clase que genera el widget de la lista
class SoWFlowStepList extends StatelessWidget {
  // Variables
  final List<SoWFlowStep> sOWFlowSteps;

  // Constructor
  const SoWFlowStepList({Key? key, required this.sOWFlowSteps}) : super(key: key);

  // Genera el widget de lista, por cada elemento de la lista
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sOWFlowSteps.length,
      itemBuilder: (context, index) {
        final item = sOWFlowSteps[index];
        return Card(
          child: ListTile(
            //onTap: () {Navigator.pushNamed(context, '/wflowstep', arguments: {'id': item.id});},
            //onTap: { Navigator.push(
            //    context,
            //    MaterialPageRoute(
            //      builder: (_) => WFlowStepForm(requiredAttrib: item.id),
            //    ),
            //  );},
            leading: IconButton(
              //onPressed: () {Navigator.pushNamed(context, '/wflowstep', arguments: {'id': item.id});},
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => WFlowStepForm(requiredAttrib: item.id.toString())
                  ),
              ),
              icon: const Icon(Icons.task),
            ),
            title: Text(item.name),
            subtitle: Text(item.header),
            trailing: Text(item.progress.toString() + '%'),
          ),
        );
      },
    );
  }
}



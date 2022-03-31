// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'dart:async';
import 'dart:convert';
import 'package:flexwm/screens/wfsp_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/drawer.dart';
import 'package:flexwm/models/wfsp.dart';
import 'package:flexwm/common/params.dart' as params;

// Create a Form widget.
class WFlowStepList extends StatefulWidget {
  const WFlowStepList({Key? key}) : super(key: key);

  @override
  _WFlowStepListState createState() {
    return _WFlowStepListState();
  }
}

// Clase de estado
class _WFlowStepListState extends State<WFlowStepList> {
  late Future<List<SoWFlowStep>> _futureSoWFlowSteps;

  @override
  void initState() {
    super.initState();
    _futureSoWFlowSteps = fetchSoWFlowSteps();
  }

  // Genera la peticion de datos al servidor
  Future<List<SoWFlowStep>> fetchSoWFlowSteps() async {
    final response = await http.Client().get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restwflowstep;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId));
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<SoWFlowStep>((json) => SoWFlowStep.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas', style: Theme.of(context).textTheme.headline1),
      ),
      body: FutureBuilder<List<SoWFlowStep>>(
        //initialData: [],
        future: _futureSoWFlowSteps,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: getListWidget(snapshot.data!),
              onRefresh: _pullRefresh,
            );
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
      drawer: getDrawer(context),
    );
  }

  Widget getListWidget(List<SoWFlowStep> soWFlowStepList) {
    return ListView.builder(
      itemCount: soWFlowStepList.length,
      itemBuilder: (context, index) {
        final item = soWFlowStepList[index];
        return Card(
          child: ListTile(
            //onTap: () {Navigator.pushNamed(context, '/wflowstep', arguments: {'id': item.id});},
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      WFlowStepForm(requiredAttrib: item.id.toString())),
            ),
            leading: IconButton(
              //onPressed: () {Navigator.pushNamed(context, '/wflowstep', arguments: {'id': item.id});},
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        WFlowStepForm(requiredAttrib: item.id.toString())),
              ),
              icon: Icon(getProperIcon(item.wFlowCallerCode)),
            ),
            title: Text(item.name),
            subtitle: Text(item.wFlowCode + ' ' + item.wFlowName),
            trailing: Text(item.progress.toString() + '%'),
          ),
        );
      },
    );
  }

  Future<void> _pullRefresh() async {
    List<SoWFlowStep> freshFutureSoWFlowSteps = await fetchSoWFlowSteps();
    setState(() {
      _futureSoWFlowSteps = Future.value(freshFutureSoWFlowSteps);
    });
  }
  
  IconData getProperIcon(String wFlowCallerCode) {
    if (wFlowCallerCode == 'OPPO') {
      return Icons.adjust;
    } else if (wFlowCallerCode == 'ORDE') {
      return Icons.add_shopping_cart;
    } else if (wFlowCallerCode == 'ACTI') {
      return Icons.alt_route_sharp;
    } else {
      return Icons.task;
    }
  }
}

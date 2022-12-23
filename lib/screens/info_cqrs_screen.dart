
import 'dart:convert';

import 'package:flexwm/widgets/card_container.dart';
import 'package:flexwm/widgets/card_stepcontainer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/crqa.dart';
import '../models/crqg.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../models/crqs.dart';

class CreditRequestInfoScreen extends StatefulWidget{

  final SoCreditRequest soCreditRequest;
  final int step;
  const CreditRequestInfoScreen({Key? key, required this.soCreditRequest, required this.step}) : super(key: key);

  @override
  State<CreditRequestInfoScreen> createState() => _CreditRequestInfoScreen();
}

class _CreditRequestInfoScreen extends State<CreditRequestInfoScreen>{

  //Lista de avales
  final List<SoCreditRequestGuarantee> _creditRequestGuarantee = [];
  //Lista de garantias por solicitud de crédito
  final List<SoCreditRequestAsset> _creditRequestAssetListData = [];
  //id del cliente logeado
  int idCustomer = 0;
  //Paso de la solicitud
  int step = 0;
  //Solicitud de crédito
  SoCreditRequest soCreditRequest = SoCreditRequest.empty();

  @override
  void initState() {
    idCustomer = params.idLoggedUser;
    step = widget.step;
    soCreditRequest = widget.soCreditRequest;
    fetchSoCreditRequestAssets(soCreditRequest.id);
    fetchSoCreditRequestGuarantee(soCreditRequest.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
              child: Center(
                child: Text(
                    'Información General',
                    style: TextStyle(color: Colors.black54, fontSize: 20)
                ),
              ),
            ),
            CardContainer(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          color: Colors.teal,
                          onPressed: (){},
                          icon: Icon(Icons.edit)
                      ),
                      Expanded(child: Text('Estado de su solicitud: '
                          '${SoCreditRequest.getStatusText(soCreditRequest.status)}')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          color: Colors.teal,
                          onPressed: (){},
                          icon: Icon(Icons.account_balance_wallet)
                      ),
                      Expanded(child: Text('Pasos realizados de la solicitud: $step/3')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        color: Colors.teal,
                          onPressed: (){},
                          icon: Icon(Icons.account_circle)
                      ),
                      Expanded(child: Text('Avales registrados: ${_creditRequestGuarantee.length}')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          color: Colors.teal,
                          onPressed: (){},
                          icon: Icon(Icons.newspaper)
                      ),
                      Expanded(child: Text('Garantías registradas: ${_creditRequestAssetListData.length}')),
                    ],
                  ),
                ],
              ),
            ),
            if(soCreditRequest.status == SoCreditRequest.STATUS_EDITION)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if(step == 3){
                    _alertSendRequest();
                  }else{
                    Fluttertoast.showToast(msg: 'Necesita completar los 3 pasos para enviar su solicitud');
                  }
                },
                child: const Text('Enviar Solicitud',
                  style: TextStyle(
                    fontSize: 18,
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

  Future<void> _alertSendRequest() async {
    return showDialog(
      context: context,
    builder: (context){
      return AlertDialog(
        title: const Text('¿Desea enviar su solicitud?'),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('No')),
          TextButton(onPressed: (){
            addCreditRequest();
            Navigator.pop(context);
          }, child: const Text('Sí')),
        ],
      );
    }
    );
  }

  Widget _alertSendReque(){
    return AlertDialog(
      title: const Text('¿Desea enviar su solicitud?'),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text('No')),
        TextButton(onPressed: (){
          addCreditRequest();
        }, child: const Text('Sí')),
      ],
    );
  }

  Future<List<SoCreditRequestAsset>> fetchSoCreditRequestAssets(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcrqa;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        'crqs' +
        '=' +
        forceFilter.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    _creditRequestAssetListData.addAll(
        parsed.map<SoCreditRequestAsset>((json) => SoCreditRequestAsset.fromJson(json)).toList());
    setState((){});
    return parsed
        .map<SoCreditRequestAsset>((json) => SoCreditRequestAsset.fromJson(json))
        .toList();
  }

  Future<List<SoCreditRequestGuarantee>> fetchSoCreditRequestGuarantee(
      int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcrqg;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        params.forceFilter +
        '=' +
        forceFilter.toString() +
        '&' +
        params.filterValueQuery +
        '=' +
        idCustomer.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    _creditRequestGuarantee.addAll(parsed
        .map<SoCreditRequestGuarantee>(
            (json) => SoCreditRequestGuarantee.fromJson(json))
        .toList());
    setState(() {});
    return parsed
        .map<SoCreditRequestGuarantee>(
            (json) => SoCreditRequestGuarantee.fromJson(json))
        .toList();
  }

  // Actualiza la solicitud de credito en el servidor
  Future<bool> addCreditRequest() async {
    soCreditRequest.status = SoCreditRequest.STATUS_REVISION;

    // Envia la sesion como Cookie, con el nombre en UpperCase
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcrqs;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCreditRequest),
    );

    if (response.statusCode == params.servletResponseScOk) {

      // Si fue exitoso obtiene la respuesta
      setState((){
        soCreditRequest = SoCreditRequest.fromJson(jsonDecode(response.body));
      });
/*      fetchCreditRequest(soCreditRequest.id.toString());
      setState((){codeCrqs = soCreditRequest.code;});
      fetchCreditRequestDetail(soCreditRequest.id.toString());*/
      // Muestra mensaje
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Su solicitud fue enviada con éxito')),
      );
      return true;
    } else {
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ${response.body}')),
      );
      return false;
    }
  }

}
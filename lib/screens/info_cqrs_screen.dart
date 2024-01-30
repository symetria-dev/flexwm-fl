
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
import '../models/crva.dart';

class CreditRequestInfoScreen extends StatefulWidget{

  final SoCreditRequest soCreditRequest;
  final int step;
  final bool requiredAsset;
  final int requiredGuarantees;
  const CreditRequestInfoScreen({Key? key, required this.soCreditRequest,
    required this.step, required this.requiredAsset,
    required this.requiredGuarantees}) : super(key: key);

  @override
  State<CreditRequestInfoScreen> createState() => _CreditRequestInfoScreen();
}

class _CreditRequestInfoScreen extends State<CreditRequestInfoScreen>{

  //Lista de avales
  final List<SoCreditRequestGuarantee> _creditRequestGuarantee = [];
  //Lista de garantias por solicitud de crédito
  final List<SoCreditRequestAsset> _creditRequestAssetListData = [];
  //Lista de validaciones por solicitud de crédito
  final List<SoCreditValidation> _creditRequestValidations = [];
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
    fetchSoCreditValidations(soCreditRequest.id);
    super.initState();
print('valores valores - ${_creditRequestGuarantee.length} - ${widget.requiredGuarantees} - step $step - ${soCreditRequest.status }');

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
            if((_creditRequestGuarantee.length-1 != widget.requiredGuarantees || step < 4)
            && soCreditRequest.status == SoCreditRequest.STATUS_EDITION)
              checkList(),
            if(_creditRequestGuarantee.length-1 == widget.requiredGuarantees && step !=3
            && soCreditRequest.status == SoCreditRequest.STATUS_EDITION)
              readySend(),
            if(soCreditRequest.status == SoCreditRequest.STATUS_REVISION)
              statusRevision(),
            if(soCreditRequest.status == SoCreditRequest.STATUS_AUTHORIZED)
              statusAuthorized(),
            if(soCreditRequest.status == SoCreditRequest.STATUS_CANCELLED)
              statusCancelled(),
            if(_creditRequestGuarantee.length-1 == widget.requiredGuarantees && step ==3
                && soCreditRequest.status == SoCreditRequest.STATUS_EDITION)
              _sendCrqsBotton(),
            const SizedBox(height: 30,),
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

  Widget _sendCrqsBotton(){
    return Column(
      children: [
        if(!widget.requiredAsset)
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
        if(widget.requiredAsset  &&
            _creditRequestAssetListData.isNotEmpty )
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
    );
  }

  Widget checkList(){
    return CardContainer(
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
              Expanded(child: Text('Avales registrados: '
                  '${_creditRequestGuarantee.length - 1}/${widget.requiredGuarantees}')),
            ],
          ),
          if(widget.requiredAsset)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                    color: Colors.teal,
                    onPressed: (){},
                    icon: Icon(Icons.newspaper)
                ),
                Expanded(child: Text('Garantías registradas: ${_creditRequestAssetListData.length}/1')),
              ],
            ),
          if(!widget.requiredAsset)
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
          const SizedBox(height: 30,),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _creditRequestValidations.length,
              itemBuilder: (BuildContext context, int index){
                SoCreditValidation nextSoCreditValidation =
                SoCreditValidation(
                    _creditRequestValidations[index].id,
                    _creditRequestValidations[index].description,
                    _creditRequestValidations[index].comments,
                    _creditRequestValidations[index].startDate,
                    _creditRequestValidations[index].required,
                    _creditRequestValidations[index].minScore,
                    _creditRequestValidations[index].score,
                    _creditRequestValidations[index].json,
                    _creditRequestValidations[index].status,
                    _creditRequestValidations[index].result,
                    _creditRequestValidations[index].creditRequestGuaranteeId,
                    _creditRequestValidations[index].creditTypeValidationId,
                    _creditRequestValidations[index].webServiceId,
                    _creditRequestValidations[index].creditRequestId,
                    _creditRequestValidations[index].name,
                    _creditRequestValidations[index].nameValidation);
                return SingleChildScrollView(
                  // height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if(index < 1)
                          Text('Acreditado: ${nextSoCreditValidation.name}',
                            style: const TextStyle(color: Colors.black,fontSize: 15),
                          ),
                        if(index>0 && nextSoCreditValidation.name != _creditRequestValidations[index-1].name)
                          Text('Acreditado: ${nextSoCreditValidation.name}',
                            style: const TextStyle(color: Colors.black,fontSize: 15),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              color: Colors.teal,
                              onPressed: (){},
                              icon: Icon(
                                  (nextSoCreditValidation.result == SoCreditValidation.RESULT_AUTHORIZED)
                                      ?Icons.check_box
                                      :Icons.check_box_outline_blank
                              ),
                            ),
                            Expanded(child: Text('Validación: ${nextSoCreditValidation.nameValidation} \n'
                                'Estatus: ${SoCreditValidation.getLabelStatus(nextSoCreditValidation.status)}\n'
                                'Resultado: ${nextSoCreditValidation.comments}',
                                style: const TextStyle(color: Colors.grey,fontSize: 15)
                            )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
          )
        ],
      ),
    );
  }

  Widget readySend(){
    return CardContainer(
        child:  Column(
          children: [
            Row(
              children: const [
                Text('Lista para Enviar',
                  style: TextStyle(color: Colors.black,fontSize: 17),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: const [
               /* IconButton(
                  color: Colors.teal,
                  onPressed: (){},
                  icon: const Icon(
                      (true)
                          ?Icons.check_box
                          :Icons.check_box_outline_blank
                  ),
                ),*/
                Expanded(child: Text('Tu Solicitud fue completada con exito.  '
                    'Si estas listo Envia para que se pueda revisar.\n\n'
                    'Declaro bajo protesta de decir verdad que la información aquí asentada es cierta'
                    ', que actúo por forma propia y no por cuenta de un tercero y que el origen de '
                    'los recursos con los que se dará cumplimiento al contrato correspondiente que '
                    'se derive de la presente solicitud proceden de fuente licitas.',
                    style: TextStyle(color: Colors.grey,fontSize: 15)
                )
                ),
              ],
            ),
          ],
        ),
    );
  }

  Widget statusRevision(){
    return CardContainer(
      child:  Column(
        children: [
          Row(
            children: const [
              Text('En Revisión',
                style: TextStyle(color: Colors.black,fontSize: 17),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: const [
              /* IconButton(
                  color: Colors.teal,
                  onPressed: (){},
                  icon: const Icon(
                      (true)
                          ?Icons.check_box
                          :Icons.check_box_outline_blank
                  ),
                ),*/
              Expanded(child: Text('Tu Solicitud está siendo revisada…',
                  style: TextStyle(color: Colors.grey,fontSize: 15)
              )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statusAuthorized(){
    return CardContainer(
      child:  Column(
        children: [
          Row(
            children: const [
              Text('Aprobada',
                style: TextStyle(color: Colors.black,fontSize: 17),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: const [
              /* IconButton(
                  color: Colors.teal,
                  onPressed: (){},
                  icon: const Icon(
                      (true)
                          ?Icons.check_box
                          :Icons.check_box_outline_blank
                  ),
                ),*/
              Expanded(child: Text('Tu solicitud fue autorizada te contactaran \n'
                  'para formalizar el crédito.',
                  style: TextStyle(color: Colors.grey,fontSize: 15)
              )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statusCancelled(){
    return CardContainer(
      child:  Column(
        children: [
          Row(
            children: const [
              Text('Rechazada',
                style: TextStyle(color: Colors.black,fontSize: 17),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: const [
              /* IconButton(
                  color: Colors.teal,
                  onPressed: (){},
                  icon: const Icon(
                      (true)
                          ?Icons.check_box
                          :Icons.check_box_outline_blank
                  ),
                ),*/
              Expanded(child: Text('Tu solicitud fue rechazada…',
                  style: TextStyle(color: Colors.grey,fontSize: 15)
              )
              ),
            ],
          ),
        ],
      ),
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

  //consulta lista de validaciones existentes de la solicitud
  Future<List<SoCreditValidation>> fetchSoCreditValidations(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcrva;' +
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

    _creditRequestValidations.addAll(
        parsed.map<SoCreditValidation>((json) => SoCreditValidation.fromJson(json)).toList());
    setState((){});
    return parsed
        .map<SoCreditValidation>((json) => SoCreditValidation.fromJson(json))
        .toList();
  }
}
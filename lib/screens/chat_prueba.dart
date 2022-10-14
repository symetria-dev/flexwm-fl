// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'dart:async';
import 'dart:convert';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flexwm/models/wfms.dart';
import 'package:flexwm/screens/cust_form.dart';
import 'package:flexwm/screens/cust_steps_form.dart';
import 'package:flexwm/screens/cust_tabs_form.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/drawer.dart';
import 'package:flexwm/models/cust.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:flexwm/common/utils.dart' as utils;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/cust_provider.dart';

// Create a Form widget.
class ChatPrueba extends StatefulWidget {
  final int forceFilter;
  const ChatPrueba({Key? key, required this.forceFilter}) : super(key: key);

  @override
  _ChatPruebaState createState() {
    return _ChatPruebaState();
  }
}

// Clase de estado
class _ChatPruebaState extends State<ChatPrueba> {
  late Future<List<SoWFlowMessage>> _futureSoWFlowMessage;

  // Variables auxiliares de campos
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureSoWFlowMessage = fetchSoWFlowMessage();
  }

  @override
  void dispose() {
    // Libera los controladores
    searchController.dispose();
    super.dispose();
  }

  // Genera la peticion de datos al servidor
  Future<List<SoWFlowMessage>> fetchSoWFlowMessage() async {
    String url = params.getAppUrl(params.instance) +
        'restwfms'
            ';' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        params.forceFilter +
        '=' +
        widget.forceFilter.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<SoWFlowMessage>((json) => SoWFlowMessage.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        Expanded(
          child: FutureBuilder<List<SoWFlowMessage>>(
            future: _futureSoWFlowMessage,
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
        ),
        MessageBar(
          onSend: (value){
            addWFlowMessage(value);
          },
          /*actions: [
            InkWell(
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 24,
              ),
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: InkWell(
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.green,
                  size: 24,
                ),
                onTap: () {},
              ),
            ),
          ],*/
        )
      ]);
  }

  // Obtiene el encabezado con busqueda
  Widget getHeader(BuildContext context) {
    return const Text('Clientes');
  }

  // Obtiene el listado con formato
  Widget getListWidget(List<SoWFlowMessage> soCustomerList) {
    DateTime dateChip = DateTime.now();
    DateTime lastDate = DateTime.now();
    // String dateFormat = DateFormat('yyyy-MM-dd').format(DateTime.parse(soCustomerList[0].datetime));
    final firstDate;
    if(soCustomerList[0].datetime != ''){
      firstDate = DateFormat('yyyy-MM-dd').parse(soCustomerList[0].datetime);
    }else{
      firstDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    return ListView.builder(
      itemCount: soCustomerList.length,
      itemBuilder: (context, index) {
        final item = soCustomerList[index];
        if(index>0){
          dateChip = DateFormat('yyyy-MM-dd').parse(item.datetime);
          lastDate = DateFormat('yyyy-MM-dd').parse(soCustomerList[index-1].datetime);
        }
        return Column(
          children: [
            if(item == soCustomerList[0])
              DateChip(
                  date: firstDate,
              ),
            if(dateChip != lastDate && item != soCustomerList[0])
              DateChip(
                date: dateChip,
              ),
            BubbleSpecialOne(
              text: item.message,
              isSender: (item.type == SoWFlowMessage.TYPE_CUSTOMER) ?true :false,
              tail: true,
              color: (item.type == SoWFlowMessage.TYPE_CUSTOMER) ?Colors.teal :Colors.grey,
              textStyle: const TextStyle(color: Colors.white, fontSize: 17),
            ),

          ],
        );
      },
    );
  }

  // Actualiza el customer en el servidor
  Future<bool> addWFlowMessage(String message) async {
  SoWFlowMessage soWFlowMessage = SoWFlowMessage.empty();
  soWFlowMessage.message = message;
  soWFlowMessage.customerId = params.idLoggedUser;
  soWFlowMessage.wflowId = widget.forceFilter;
    // Envia la sesion como Cookie, con el nombre en UpperCase
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restwfms;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soWFlowMessage),
    );

    if (response.statusCode == params.servletResponseScOk) {

      // Si fue exitoso obtiene la respuesta
      soWFlowMessage = SoWFlowMessage.fromJson(jsonDecode(response.body));

      // Muestra mensaje
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Datos actualizados correctamente')),
      // );
      setState(() {
        _futureSoWFlowMessage = fetchSoWFlowMessage();
      });
      return true;
    } else {
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ${response.body}')),
      );
      return false;
    }
  }

  // Actualiza al arrastrar hacia abajo
  Future<void> _pullRefresh() async {
    List<SoWFlowMessage> freshFutureSoCustomers = await fetchSoWFlowMessage();
    setState(() {
      _futureSoWFlowMessage = Future.value(freshFutureSoCustomers);
    });
  }
}

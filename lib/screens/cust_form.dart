// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flexwm/models/cust.dart';
import 'package:flexwm/common/params.dart' as params;

// Create a Form widget.
class CustomerForm extends StatefulWidget {
  final String requiredAttrib;

  // Constructor obliga a obtener el id
  const CustomerForm({Key? key, required this.requiredAttrib})
      : super(key: key);

  @override
  _CustomerFormState createState() {
    return _CustomerFormState();
  }
}

// Forma de Customer con estado
class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  SoCustomer soCustomer = SoCustomer.empty();
  late Future<SoCustomer> _futureSoCustomer;

  // Variables auxiliares de campos
  final referralCommentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureSoCustomer = fetchCustomer(widget.requiredAttrib);
  }

  @override
  void dispose() {
    // Libera los controladores
    referralCommentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: params.bgColor,
      appBar: AppBar(
        title: Text('Cliente', style: Theme.of(context).textTheme.headline6),
        backgroundColor: params.appBarBgColor,
      ),
      body: Center(
        child: FutureBuilder<SoCustomer>(
          future: _futureSoCustomer,
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
  Widget getForm(BuildContext context, SoCustomer getSoCustomer) {
    soCustomer = getSoCustomer;
    referralCommentsController.text = soCustomer.referralComments;

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            getHeader(soCustomer),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Comentario Referencias',
              ),
              controller: referralCommentsController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Valida la forma, si regresa verdadero actua
                  if (_formKey.currentState!.validate()) {
                    // Actualiza registro
                    updateCustomer();
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
  Widget getHeader(SoCustomer soCustomer) {
    return Card(
      child: ListTile(
        leading: params.getProperIcon(SoCustomer.programCode),
        title: Text(soCustomer.code + ' ' + soCustomer.displayName),
        subtitle: Text(soCustomer.phone +
            ' ' +
            soCustomer.email),
        trailing: Image.network(
          params.getAppUrl(params.instance) +
              params.uploadFiles +
              '/' +
              soCustomer.logo,
          width: 100,
          height: 100,
          errorBuilder: (context, error, stackTrace) {
            return const Text('');
          },
        ),
      ),
    );
  }

  // Obtiene los datos del registro
  Future<SoCustomer> fetchCustomer(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcust;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?id=' +
            id.toString()));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      Navigator.pushNamed(context, '/');
    }

    return SoCustomer.fromJson(jsonDecode(response.body));
  }

  // Actualiza el Customer en el servidor
  void updateCustomer() async {
    soCustomer.referralComments = referralCommentsController.text;

    // Envia la sesion como Cookie, con el nombre en UpperCase
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcust;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
            params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCustomer),
    );

    if (response.statusCode == params.servletResponseScOk) {
      // Si fue exitoso obtiene la respuesta
      soCustomer = SoCustomer.fromJson(jsonDecode(response.body));

      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente "' + soCustomer.code + '" actualizado')),
      );

      // Regresa al listado
      Navigator.pop(context);
      Navigator.pushNamed(context, '/cust_list');
    } else if (response.statusCode == params.servletResponseScNotAcceptable ||
        response.statusCode == params.servletResponseScForbidden) {
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al Guardar')),
      );
    } else {
      // Aun no se recibe respuesta del servidor
      const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

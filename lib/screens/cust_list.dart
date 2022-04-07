// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'dart:async';
import 'dart:convert';
import 'package:flexwm/screens/cust_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/drawer.dart';
import 'package:flexwm/models/cust.dart';
import 'package:flexwm/common/params.dart' as params;

// Create a Form widget.
class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  _CustomerListState createState() {
    return _CustomerListState();
  }
}

// Clase de estado
class _CustomerListState extends State<CustomerList> {
  late Future<List<SoCustomer>> _futureSoCustomers;

  @override
  void initState() {
    super.initState();
    _futureSoCustomers = fetchSoCustomers();
  }

  // Genera la peticion de datos al servidor
  Future<List<SoCustomer>> fetchSoCustomers() async {
    final response = await http.Client().get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcust;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponse_Sc_Ok) {
      Navigator.pushNamed(context, '/');
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<SoCustomer>((json) => SoCustomer.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: params.bgColor,
      appBar: AppBar(
        title: getHeader(context),
        backgroundColor: params.appBarBgColor,
      ),
      body: Column (
        children: [
          TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Comentario Referencias',
            ),
          ),
          FutureBuilder<List<SoCustomer>>(
            future: _futureSoCustomers,
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
        ]
      ),
      drawer: getDrawer(context),
    );
  }

  // Obtiene el encabezado con busqueda
  Widget getHeader(BuildContext context) {
    return Row(
      children: [
        const Text('Clientes'),

      ],
    );
  }

  // Obtiene el listado con formato
  Widget getListWidget(List<SoCustomer> soCustomerList) {
    return ListView.builder(
      itemCount: soCustomerList.length,
      itemBuilder: (context, index) {
        final item = soCustomerList[index];
        return Card(
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      CustomerForm(requiredAttrib: item.id.toString())),
            ),
            leading: IconButton(
              //onPressed: () {Navigator.pushNamed(context, '/Customer', arguments: {'id': item.id});},
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        CustomerForm(requiredAttrib: item.id.toString())),
              ),
              icon: params.getProperIcon('CUST'),
            ),
            title: Text(item.code + ' ' + item.displayName),
            subtitle: Text(item.email),
            trailing: Text(item.phone.toString(),
                style: const TextStyle(color: Colors.indigo)),
          ),
        );
      },
    );
  }

  // Actualiza al arrastrar hacia abajo
  Future<void> _pullRefresh() async {
    List<SoCustomer> freshFutureSoCustomers = await fetchSoCustomers();
    setState(() {
      _futureSoCustomers = Future.value(freshFutureSoCustomers);
    });
  }
}

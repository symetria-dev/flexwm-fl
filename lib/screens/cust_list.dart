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
import 'package:flexwm/common/utils.dart' as utils;

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

  // Variables auxiliares de campos
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureSoCustomers = fetchSoCustomers();
  }

  @override
  void dispose() {
    // Libera los controladores
    searchController.dispose();
    super.dispose();
  }

  // Genera la peticion de datos al servidor
  Future<List<SoCustomer>> fetchSoCustomers() async {
    String url = params.getAppUrl(params.instance) +
        'restcust'
            ';' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        params.searchQuery +
        '=' +
        searchController.text;
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<SoCustomer>((json) => SoCustomer.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: params.bgColor,
      appBar: AppBar(
        title: getHeader(context),
        backgroundColor: params.appBarBgColor,
      ),
      body: Column(children: [
        Row(children: [
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Buscar en Clientes',
              ),
              controller: searchController,
              onFieldSubmitted: (value) {
                // Accion al presionar enter
                setState(() {
                  _futureSoCustomers = fetchSoCustomers();
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Accion al presionar
              setState(() {
                _futureSoCustomers = fetchSoCustomers();
              });
            },
            child: const Text(
              'Buscar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ]),
        Expanded(
          child: FutureBuilder<List<SoCustomer>>(
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
        ),
      ]),
      drawer: getDrawer(context),
    );
  }

  // Obtiene el encabezado con busqueda
  Widget getHeader(BuildContext context) {
    return const Text('Clientes');
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
            leading: Image.network(
              params.getAppUrl(params.instance) +
                  params.uploadFiles +
                  '/' +
                  item.logo,
              width: 75,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, color: Colors.green);
              },
            ),
            title: Text(item.code + ' ' + item.displayName),
            subtitle: Text(item.legalName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {utils.makeMail(item.email);}, icon: const Icon(Icons.email)),
                IconButton(onPressed: () {utils.makePhoneCall(item.phone);}, icon: const Icon(Icons.phone)),
              ],
            ),
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

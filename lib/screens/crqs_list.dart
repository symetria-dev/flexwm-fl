// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'dart:async';
import 'dart:convert';
import 'package:flexwm/models/crqs.dart';
import 'package:flexwm/screens/crqg_list.dart';
import 'package:flexwm/screens/cust_crqs_form.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flexwm/widgets/auth_formbackground.dart';
import 'package:flexwm/widgets/auth_listbackground.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/drawer.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/crqd.dart';
import '../models/cust.dart';
import '../routes/app_routes.dart';
import 'crqs_form.dart';

// Create a Form widget.
class CreditRequestList extends StatefulWidget {
  const CreditRequestList({Key? key}) : super(key: key);

  @override
  _CreditRequestList createState() {
    return _CreditRequestList();
  }
}

// Clase de estado
class _CreditRequestList extends State<CreditRequestList> {
  late Future<List<SoCreditRequest>> _futureSoCreditRequests;
  List<SoCreditRequest> _soCreditRequest = [];
  late int idCustomer = params.idLoggedUser;
  SoCustomer soCustomer = SoCustomer.empty();
  //var para tipo de listado
  bool list = false;
  //detalle del credito
  SoCreditRequestDetail soCreditRequestDetail = SoCreditRequestDetail.empty();

  @override
  void initState() {
    /*fetchCustomer(idCustomer.toString()).then((value) {
      if(soCustomer.curp.isEmpty || soCustomer.rfc.isEmpty){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustCrqsForm()),
        );
      }
    });*/
    fetchSoCreditRequests().then((value) {
      if(_soCreditRequest.isEmpty){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CrqsForm(
                creditRequest: SoCreditRequest.empty(),
                creditRequestDetail: SoCreditRequestDetail.empty(),
              )),
        ).then((value) => setState(() {
          _futureSoCreditRequests = fetchSoCreditRequests();
        }));
      }
    });
    super.initState();
    _futureSoCreditRequests = fetchSoCreditRequests();

  }

  // Genera la peticion de datos al servidor
  Future<List<SoCreditRequest>> fetchSoCreditRequests() async {
    final response = await http.Client().get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcrqs;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?idcust=' +
            idCustomer.toString()));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      Navigator.pushNamed(context, AppRoutes.initialRoute);
    }
    setState(() {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      _soCreditRequest = parsed.map<SoCreditRequest>((json) => SoCreditRequest.fromJson(json)).toList();
    });

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    return parsed
        .map<SoCreditRequest>((json) => SoCreditRequest.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        /* child: Container(
          width: double.infinity,
          height: double.infinity,
          child: const Icon(Icons.add, color: Colors.white,),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 130, 146, 1),
                    Color.fromRGBO(112, 169, 179, 1.0)
                  ]
              )
          ),
        ),*/
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CrqsForm(
                      creditRequest: SoCreditRequest.empty(),
                      creditRequestDetail: SoCreditRequestDetail.empty(),
                    )),
          ).then((value) => setState(() {
                _futureSoCreditRequests = fetchSoCreditRequests();
              }));
        },
      ),
      // backgroundColor: params.bgColor,
      appBar: AppBarStyle.authAppBarFlex(title: 'Mis créditos'),
      body: AuthListBackground(
        child: AuthFormBackground(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: FutureBuilder<List<SoCreditRequest>>(
              future: _futureSoCreditRequests,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _soCreditRequest = snapshot.data!;
                  return (_soCreditRequest.isEmpty)
                      ? noListWidget()
                      : (list)
                          ? getList(_soCreditRequest)
                          : getListWidget(_soCreditRequest);
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
        ),
      ),
      drawer: getDrawer(context),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.support_agent,
                size: 30,
                color: Colors.blueGrey,
              ),
              tooltip: 'Ayuda',
              onPressed: () {
                showAlertDialog(context);
              }),
          if (list)
            IconButton(
                icon: const Icon(
                  Icons.art_track_outlined,
                  size: 30,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  setState(() {
                    list = false;
                  });
                }),
          if (!list)
            IconButton(
                icon: const Icon(
                  Icons.view_list_sharp,
                  size: 30,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  setState(() {
                    list = true;
                  });
                }),
        ],
      ),
    );
  }

  //alert de ayuda
  showAlertDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:
          const Text("Si tienes dudas del proceso, por favor contáctanos al:"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(
                Icons.mail,
                color: Colors.blueGrey,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "soporte@edupass.mx",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(
                Icons.phone,
                color: Colors.blueGrey,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "0155 6387 1129",
                style: TextStyle(color: Colors.grey),
              )
            ],
          )
        ],
      ),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget noListWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 70, bottom: 0.8, left: 5, right: 5),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  gradient: LinearGradient(
                      begin: AlignmentDirectional.topEnd,
                      end: AlignmentDirectional.bottomEnd,
                      colors: [
                        Color.fromRGBO(0, 130, 146, 1),
                        // Color.fromRGBO(225, 158, 110, 1),
                        // Color.fromRGBO(243, 129, 48, 1),
                        // Color.fromRGBO(21, 67, 96, 1),
                        // Color.fromRGBO(171, 178, 185, 1)
                        Color.fromRGBO(112, 169, 179, 1.0)
                      ])),
              child: SizedBox(
                height: 140,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.asset(
                      'images/logo.png',
                      fit: BoxFit.fitWidth,
                      color: Colors.white,
                    )),
                    const Positioned(
                        bottom: 6,
                        left: 16,
                        right: 16,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'La mejor garantía para pedir un crédito educativo.',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CrqsForm(
                          creditRequest: SoCreditRequest.empty(),
                          creditRequestDetail: SoCreditRequestDetail.empty(),
                        )),
              ).then((value) => setState(() {
                    _futureSoCreditRequests = fetchSoCreditRequests();
                  })),
              leading: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CrqsForm(
                            creditRequest: SoCreditRequest.empty(),
                            creditRequestDetail: SoCreditRequestDetail.empty(),
                          )),
                ).then((value) => setState(() {
                      _futureSoCreditRequests = fetchSoCreditRequests();
                    })),
                icon: const Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.teal,
                ),
              ),
              title: const Text('Solicitar nuevo crédito'),
              subtitle: const Text(
                  'Haz clic aquí para solicitar un crédito con la garantía de Edupass'),
              trailing: const Icon(
                Icons.add_circle_outline,
                color: Colors.green,
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  // Obtiene el listado con formato
  Widget getListWidget(List<SoCreditRequest> soWFlowStepList) {
    return ListView.builder(
      itemCount: soWFlowStepList.length,
      itemBuilder: (context, index) {
        final item = soWFlowStepList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                      gradient: LinearGradient(
                          begin: AlignmentDirectional.topEnd,
                          end: AlignmentDirectional.bottomEnd,
                          colors: [
                            Color.fromRGBO(0, 130, 146, 1),
                            // Color.fromRGBO(225, 158, 110, 1),
                            // Color.fromRGBO(243, 129, 48, 1),
                            // Color.fromRGBO(21, 67, 96, 1),
                            // Color.fromRGBO(171, 178, 185, 1)
                            Color.fromRGBO(112, 169, 179, 1.0)
                          ])),
                  child: SizedBox(
                    height: 140,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.fitWidth,
                          color: Colors.white,
                        )),
                        Positioned(
                            bottom: 6,
                            left: 16,
                            right: 16,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Crédito Educativo - ${item.code}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    fetchCreditRequestDetail(item.id.toString()).then((value) {
                      if (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CrqsForm(
                                    creditRequest: item,
                                    creditRequestDetail: soCreditRequestDetail,
                                  )),
                        ).then((value) => setState(() {
                              _futureSoCreditRequests = fetchSoCreditRequests();
                            }));
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'Error al obrtener información, intentelo más tarde');
                      }
                    });
                  },
                  leading: IconButton(
                    //onPressed: () {Navigator.pushNamed(context, '/wflowstep', arguments: {'id': item.id});},
                    onPressed: () {
                      fetchCreditRequestDetail(item.id.toString())
                          .then((value) {
                        if (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CrqsForm(
                                      creditRequest: item,
                                      creditRequestDetail:
                                          soCreditRequestDetail,
                                    )),
                          ).then((value) => setState(() {
                                _futureSoCreditRequests =
                                    fetchSoCreditRequests();
                              }));
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'Error al obrtener información, intentelo más tarde');
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.teal,
                    ),
                  ),
                  title: Text(
                      'Estatus: ${SoCreditRequest.getStatusText(item.status)}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monto financiado: ' +
                          NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                              .format(item.amountRequired)),
                      // Text('Estatus: ${SoCreditRequest.getStatusText(item.status)}'),
                    ],
                  ),
                  // trailing: const Icon(Icons.monetization_on_outlined, color: Colors.indigo,),
                  trailing: CircularPercentIndicator(
                    radius: 28.0,
                    lineWidth: 10.0,
                    animation: true,
                    percent: (item.status == SoCreditRequest.STATUS_EDITION)
                        ? 0.35
                        : (item.status == SoCreditRequest.STATUS_REVISION)
                            ? 0.70
                            : (item.status == SoCreditRequest.STATUS_AUTHORIZED)
                                ? 1.0
                                : 0.0,
                    center: (item.status == SoCreditRequest.STATUS_EDITION)
                        ? const Text('35%')
                        : (item.status == SoCreditRequest.STATUS_REVISION)
                            ? const Text('70%')
                            : (item.status == SoCreditRequest.STATUS_AUTHORIZED)
                                ? const Text('100%')
                                : const Icon(Icons.cancel_outlined),
                    progressColor: Colors.blue,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  /*PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.indigo),
                    itemBuilder: (_){
                      return [
                        const PopupMenuItem(
                            value: 'sponsors',
                            child: Text("Ver Sponsors")
                        )
                      ];
                    },
                    onSelected: (String value) => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CreditRequestGuaranteeList(soCreditRequest: item))
                    ),
                  ),*/
                ),
                const SizedBox(
                  height: 10,
                )
                /*ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){},
                        child: const Text('Ver más')
                    )
                  ],
                )*/
              ],
            ),
          ),
        );
      },
    );
  }

  // Obtiene el listado con formato
  Widget getList(List<SoCreditRequest> soWFlowStepList) {
    return ListView.builder(
      itemCount: soWFlowStepList.length,
      itemBuilder: (context, index) {
        final item = soWFlowStepList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    fetchCreditRequestDetail(item.id.toString()).then((value) {
                      if (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CrqsForm(
                                creditRequest: item,
                                creditRequestDetail: soCreditRequestDetail,
                              )),
                        ).then((value) => setState(() {
                          _futureSoCreditRequests = fetchSoCreditRequests();
                        }));
                      } else {
                        Fluttertoast.showToast(
                            msg:
                            'Error al obrtener información, intentelo más tarde');
                      }
                    });
                  },
                  leading: IconButton(
                    //onPressed: () {Navigator.pushNamed(context, '/wflowstep', arguments: {'id': item.id});},
                    onPressed: () {
                      fetchCreditRequestDetail(item.id.toString()).then((value) {
                        if (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CrqsForm(
                                  creditRequest: item,
                                  creditRequestDetail: soCreditRequestDetail,
                                )),
                          ).then((value) => setState(() {
                            _futureSoCreditRequests = fetchSoCreditRequests();
                          }));
                        } else {
                          Fluttertoast.showToast(
                              msg:
                              'Error al obrtener información, intentelo más tarde');
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.teal,
                    ),
                  ),
                  title: Text(
                      'Estatus: ${SoCreditRequest.getStatusText(item.status)}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monto financiado: ' +
                          NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                              .format(item.amountRequired)),
                      // Text('Estatus: ${SoCreditRequest.getStatusText(item.status)}'),
                    ],
                  ),
                  // trailing: const Icon(Icons.monetization_on_outlined, color: Colors.indigo,),
                  trailing: CircularPercentIndicator(
                    radius: 28.0,
                    lineWidth: 10.0,
                    animation: true,
                    percent: (item.status == SoCreditRequest.STATUS_EDITION)
                        ? 0.35
                        : (item.status == SoCreditRequest.STATUS_REVISION)
                            ? 0.70
                            : (item.status == SoCreditRequest.STATUS_AUTHORIZED)
                                ? 1.0
                                : 0.0,
                    center: (item.status == SoCreditRequest.STATUS_EDITION)
                        ? const Text('35%')
                        : (item.status == SoCreditRequest.STATUS_REVISION)
                            ? const Text('70%')
                            : (item.status == SoCreditRequest.STATUS_AUTHORIZED)
                                ? const Text('100%')
                                : const Icon(Icons.cancel_outlined),
                    progressColor: Colors.blue,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  /*PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.indigo),
                    itemBuilder: (_){
                      return [
                        const PopupMenuItem(
                            value: 'sponsors',
                            child: Text("Ver Sponsors")
                        )
                      ];
                    },
                    onSelected: (String value) => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CreditRequestGuaranteeList(soCreditRequest: item))
                    ),
                  ),*/
                ),
                const SizedBox(
                  height: 10,
                )
                /*ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){},
                        child: const Text('Ver más')
                    )
                  ],
                )*/
              ],
            ),
          ),
        );
      },
    );
  }

  // Actualiza al arrastrar hacia abajo
  Future<void> _pullRefresh() async {
    List<SoCreditRequest> freshFutureSoWFlowSteps =
        await fetchSoCreditRequests();
    setState(() {
      _futureSoCreditRequests = Future.value(freshFutureSoWFlowSteps);
    });
  }

  //Petición de datos de un cliente especifico
  Future<bool> fetchCustomer(String id) async {
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
      Navigator.pushNamed(context, AppRoutes.initialRoute);
      return false;
    }
    //Si no hay errores se guarda el obejto devuelto
    soCustomer = SoCustomer.fromJson(jsonDecode(response.body));
    return true;
  }

  //Petición de datos de detalles de solicitud de crédito parametro id del la solicitud
  Future<bool> fetchCreditRequestDetail(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcrqd;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?id=' +
            id.toString()));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      Navigator.pushNamed(context, AppRoutes.initialRoute);
      return false;
    }
    setState(() {
      soCreditRequestDetail =
          SoCreditRequestDetail.fromJson(jsonDecode(response.body));
    });

    return true;
  }
}

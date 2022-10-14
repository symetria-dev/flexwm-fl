import 'dart:convert';

import 'package:flexwm/models/crqg.dart';
import 'package:flexwm/screens/crqg_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;
import '../models/cust.dart';

class CreditRequestGuarantee extends StatefulWidget {
  final int forceFilter;
  const CreditRequestGuarantee({Key? key, required this.forceFilter})
      : super(key: key);

  @override
  State<CreditRequestGuarantee> createState() => _CreditRequestGuaranteeState();
}

class _CreditRequestGuaranteeState extends State<CreditRequestGuarantee> {
  final List<SoCreditRequestGuarantee> _creditRequestGuarantee = [];
  SoCreditRequestGuarantee soCreditRequestGuarantee =
      SoCreditRequestGuarantee.empty();
  //variables para el manejo de lcientes avales
  final List<SoCustomer> _soCustomerList = [];
  int idCustomer = 0;
  int idCustomerGuarantee = 0;
  SoCustomer soCustomer = SoCustomer.empty();
  int idCreditRequest = 0;
  //key para formulario nuevo registro de aval
  final _formKeyCustCrqg = GlobalKey<FormState>();
  final _formKeyRolRelation = GlobalKey<FormState>();
  //Se crean controllers para asignar valores en campos generales de aval
  late String role = SoCreditRequestGuarantee.ROLE_COACREDITED;
  late String relation = SoCreditRequestGuarantee.RELATION_ACCREDITED;
  final textFisrtNameCntrll = TextEditingController();
  final textFatherLastNameCntrll = TextEditingController();
  final textMotherLastNameCntrll = TextEditingController();
  final textBirthdateCntrll = TextEditingController();
  final textCellphoneCntrll = TextEditingController();
  final textEmailCntrll = TextEditingController();
  final textRfcCntrll = TextEditingController();
  final textCurpCntrll = TextEditingController();
  late String maritalStatus = '';
  late String regimenMarital = '';
  String msjResponsServer = '';

  @override
  void initState() {
    idCustomer = params.idLoggedUser;
    idCreditRequest = widget.forceFilter;
    role = SoCreditRequestGuarantee.ROLE_COACREDITED;
    relation = SoCreditRequestGuarantee.RELATION_ACCREDITED;
    regimenMarital = SoCreditRequestGuarantee.REGIMEN_CONJUGAL_SOCIETY;
    fetchSoCreditRequestGuarantee(idCreditRequest);
    fetchSoCustomers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _creditRequestGuarantee.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index < _creditRequestGuarantee.length) {
          SoCreditRequestGuarantee nextSoCreditRequest =
              SoCreditRequestGuarantee(
            _creditRequestGuarantee[index].id,
            _creditRequestGuarantee[index].relation,
            _creditRequestGuarantee[index].customerId,
            _creditRequestGuarantee[index].creditRequestId,
            _creditRequestGuarantee[index].role,
            _creditRequestGuarantee[index].economicDependents,
            _creditRequestGuarantee[index].typeHousing,
            _creditRequestGuarantee[index].yearsResidence,
            _creditRequestGuarantee[index].ciec,
            _creditRequestGuarantee[index].accountStatement,
            _creditRequestGuarantee[index].payrollReceipts,
            _creditRequestGuarantee[index].heritage,
            _creditRequestGuarantee[index].employmentStatus,
            _creditRequestGuarantee[index].company,
            _creditRequestGuarantee[index].economicActivity,
            _creditRequestGuarantee[index].yearsEmployment,
            _creditRequestGuarantee[index].creditCards,
            _creditRequestGuarantee[index].rent,
            _creditRequestGuarantee[index].creditAutomotive,
            _creditRequestGuarantee[index].creditFurniture,
            _creditRequestGuarantee[index].personalLoans,
            _creditRequestGuarantee[index].verifiableIncome,
            _creditRequestGuarantee[index].soCustomer,
            _creditRequestGuarantee[index].identification,
            _creditRequestGuarantee[index].proofIncome,
            _creditRequestGuarantee[index].fiscalSituation,
            _creditRequestGuarantee[index].verifiableIncomeFile,
            _creditRequestGuarantee[index].declaratory,
          );
          return Slidable(
            endActionPane:
                ActionPane(motion: const DrawerMotion(), children: <Widget>[
              SlidableAction(
                  icon: Icons.delete_forever,
                  foregroundColor: Colors.red,
                  label: 'Eliminar',
                  onPressed: (_) {
                    deleteSoCreditRequestGuarantee(
                            _creditRequestGuarantee[index].id)
                        .then((value) {
                      if (value) {
                        //Se actualiza la lista del subcatalogo
                        _creditRequestGuarantee.clear();
                        setState(() {
                          fetchSoCreditRequestGuarantee(idCreditRequest);
                        });
                      }
                    });
                  }),
            ]),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreditRequestGuarateeForm(
                            soCreditRequestGuarantee: nextSoCreditRequest,
                            creditRequestId: idCreditRequest),
                      ));
                },
                leading: const Icon(
                  Icons.assignment_ind,
                  size: 50,
                ),
                title: Text(index.toString() +
                    ':' +
                    nextSoCreditRequest.soCustomer.firstName +
                    ' ' +
                    nextSoCreditRequest.relation),
                subtitle: Text(nextSoCreditRequest.soCustomer.firstName),
                trailing: null,
              ),
            ),
          );
        } else {
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Agregar Aval',
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                              _soCustomerList.clear();
                              setState(() {
                                fetchSoCustomers().then((value) =>
                                    showModalCustomerSponsors(context));
                              });
                              })
                      ],
                    ),
                  )),
              const SizedBox(
                height: 20,
              )
            ],
          );
        }
      },
    );
  }

  FloatingActionButton _buttonSponsors() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreditRequestGuarateeForm(
                  soCreditRequestGuarantee: SoCreditRequestGuarantee.empty(),
                  creditRequestId: idCreditRequest),
            )).then((value) {
              _creditRequestGuarantee.clear();
              _soCustomerList.clear();
              setState(() {
                fetchSoCustomers();
                fetchSoCreditRequestGuarantee(idCreditRequest);
              });
            });
      },
      child: const Icon(Icons.add),
    );
  }

  //Modal de avales/clientes registrados
  void showModalCustomerSponsors(BuildContext context) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return FractionallySizedBox(
                heightFactor: 0.7,
                child: Scaffold(
                  floatingActionButton: _buttonSponsors(),
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          height: 50,
                          child: Center(
                            child: Text('Avales registrados'),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(height: 10,),
                        if(_soCustomerList.isNotEmpty)
                        Container(
                          height: size.height*0.5,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _soCustomerList.length,
                            itemBuilder: (BuildContext context, int index) {
                              SoCustomer nextSoCustomer =
                                  SoCustomer(
                                    _soCustomerList[index].id,
                                    _soCustomerList[index].code,
                                    _soCustomerList[index].displayName,
                                    _soCustomerList[index].legalName,
                                    _soCustomerList[index].logo,
                                    _soCustomerList[index].phone,
                                    _soCustomerList[index].email,
                                    _soCustomerList[index].referralId,
                                    _soCustomerList[index].referralComments,
                                    _soCustomerList[index].customerType,
                                    _soCustomerList[index].rfc,
                                    _soCustomerList[index].firstName,
                                    _soCustomerList[index].fatherLastName,
                                    _soCustomerList[index].salesManId,
                                    _soCustomerList[index].nss,
                                    _soCustomerList[index].stablishMentDate,
                                    _soCustomerList[index].birthdate,
                                    _soCustomerList[index].passw,
                                    _soCustomerList[index].passwconf,
                                    _soCustomerList[index].curp,
                                    _soCustomerList[index].recommendedBy,
                                    _soCustomerList[index].motherlastname,
                                    _soCustomerList[index].maritalStatusId,
                                    _soCustomerList[index].mobile,
                                    _soCustomerList[index].maritalRegimen,
                              );
                              return Slidable(
                                endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: <Widget>[
                                      SlidableAction(
                                          icon: Icons.delete_forever,
                                          foregroundColor: Colors.red,
                                          label: 'Eliminar',
                                          onPressed: (_) {
                                          /*  deleteSoCreditRequestGuarantee(
                                                    _creditRequestGuarantee[index]
                                                        .id)
                                                .then((value) {
                                              if (value) {
                                                //Se actualiza la lista del subcatalogo
                                                _creditRequestGuarantee.clear();
                                                setState(() {
                                                  fetchSoCreditRequestGuarantee(
                                                      idCreditRequest);
                                                });
                                              }
                                            });*/
                                          }),
                                    ]),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: ListTile(
                                    onTap: () {

                                    },
                                    leading: const Icon(
                                      Icons.assignment_ind,
                                      size: 50,
                                    ),
                                    title: Text(index.toString() +
                                        ':' +
                                        nextSoCustomer.firstName +
                                        ' ' +
                                        nextSoCustomer.fatherLastName),
                                    subtitle: Text(
                                        nextSoCustomer.rfc),
                                    trailing: IconButton(
                                      onPressed: () {
                                        showAlertDialog(context, nextSoCustomer);
                                      },
                                      icon: const Icon(Icons.add_circle, color: Colors.teal,),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if(_soCustomerList.isEmpty)
                          const Center(
                            child: Text('0 Avales registrados'),
                          ),
                        const SizedBox(height: 50,)
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        }).whenComplete(_onBottomSheetClosed);
  }

  //Funcion que se ejecuta al cerrar modalbottomsheet
  void _onBottomSheetClosed() {
    //Se actualiza la lista del subcatalogo
    _creditRequestGuarantee.clear();
    setState(() {
      fetchSoCreditRequestGuarantee(idCreditRequest);
    });
  }

  //Alert confirmación agregar aval
  showAlertDialog(BuildContext context, SoCustomer soCustomer) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirmar"),
      onPressed: () {
        Navigator.pop(context);
        idCustomerGuarantee = soCustomer.id;
        _showModalBottomFormAddCrqg();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
          "¿Desea agregar a ${soCustomer.firstName} como su aval en esta solicitud?"),
      actions: [
        cancelButton,
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

  //modal datos para asignar aval a solicitud de crédito
  void _showModalBottomFormAddCrqg() {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Padding(
                //Funcion para mover widget a la altura del teclado
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 5,
                    right: 5),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text('Asignación de Aval'),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.blueGrey,
                      ),
                      formRolRelation(setState),
                    ],
                  ),
                ),
              ),
            );
          });
        }).whenComplete(_onBottomSheetClosed);
  }

  //Forma para la asignación de aval a solicitud de crédito
  Widget formRolRelation(StateSetter setState) {
    return Form(
        key: _formKeyRolRelation,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                    child: Text(
                  "Rol preliminar del crédito",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                )),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: DropdownButton(
                      value: role,
                      items: SoCreditRequestGuarantee.getRoleOptions.map((e) {
                        return DropdownMenuItem(
                          child: Text(e['label']),
                          value: e['value'],
                        );
                      }).toList(),
                      onChanged: (Object? value) {
                        setState(() {
                          role = '$value';
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                    child: Text(
                  "Relación con el estudiante",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                )),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: DropdownButton(
                      value: relation,
                      items:
                          SoCreditRequestGuarantee.getRelationOptions.map((e) {
                        return DropdownMenuItem(
                          child: Text(e['label']),
                          value: e['value'],
                        );
                      }).toList(),
                      onChanged: (Object? value) {
                        setState(() {
                          relation = '$value';
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKeyRolRelation.currentState!.validate()) {
                    updateCreditRequestGuarantee().then((value) {
                      if (value) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: msjResponsServer);
                      } else {
                        // Error al guardar
                        Fluttertoast.showToast(msg: msjResponsServer);
                      }
                    });
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
        ));
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

  // Genera la peticion de datos al servidor
  Future<List<SoCustomer>> fetchSoCustomers() async {
    String url = params.getAppUrl(params.instance) +
        'restcust'
            ';' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
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
    _soCustomerList.addAll(
        parsed.map<SoCustomer>((json) => SoCustomer.fromJson(json)).toList());
    setState(() {});
    return parsed.map<SoCustomer>((json) => SoCustomer.fromJson(json)).toList();
  }

  Future<bool> deleteSoCreditRequestGuarantee(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcrqg;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?id=' +
        forceFilter.toString() +
        '&' +
        params.deleteFilter +
        '=' +
        forceFilter.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScOk) {
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro eliminado correctamente')),
      );
      return true;
    } else {
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ocurrió un error al eliminar el registro')),
      );
      return false;
    }
  }

  // Actualiza el wflowstep en el servidor
  Future<bool> addCust(BuildContext context) async {
    soCustomer.firstName = textFisrtNameCntrll.text;
    soCustomer.fatherLastName = textFatherLastNameCntrll.text;
    soCustomer.motherlastname = textMotherLastNameCntrll.text;
    soCustomer.birthdate = textBirthdateCntrll.text;
    soCustomer.mobile = textCellphoneCntrll.text;
    soCustomer.email = textEmailCntrll.text;
    soCustomer.rfc = textRfcCntrll.text;
    soCustomer.curp = textCurpCntrll.text;
    soCustomer.maritalStatusId = int.parse(maritalStatus);
    soCustomer.maritalRegimen = regimenMarital;
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
      soCustomer = SoCustomer.fromJson(jsonDecode(response.body));
      // Muestra mensaje
      msjResponsServer = 'Nuevo aval registrado y asignado con exito.';
      return true;
    } else {
      // Muestra mensaje
      msjResponsServer = response.body.toString();
      return false;
    }
  }

  Future<bool> updateCreditRequestGuarantee() async {
    soCreditRequestGuarantee.customerId = idCustomerGuarantee;
    soCreditRequestGuarantee.creditRequestId = idCreditRequest;
    soCreditRequestGuarantee.relation = relation;
    soCreditRequestGuarantee.role = role;
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcrqg;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
            params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCreditRequestGuarantee),
    );

    if (response.statusCode == params.servletResponseScOk) {
      // Muestra mensaje
      msjResponsServer = 'Nuevo aval registrado con exito.';
      return true;
    } else {
      // Muestra mensaje
      msjResponsServer = response.body.toString();
      return false;
    }
  }
}

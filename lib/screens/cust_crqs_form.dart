
import 'dart:convert';

import 'package:flexwm/models/crqs.dart';
import 'package:flexwm/routes/routes.dart';
import 'package:flexwm/screens/crqs_list.dart';
import 'package:flexwm/screens/cust_credit_form.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flexwm/widgets/auth_listbackground.dart';
import 'package:flutter/material.dart';

import 'package:flexwm/ui/input_decorations.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../models/cust.dart';
import '../routes/app_routes.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/sub_catalog_widget.dart';
import 'cuad_screen.dart';
import 'curl_screen.dart';

class CustCrqsForm extends StatefulWidget {

  const CustCrqsForm({Key? key,}) : super(key: key);

  @override
  _CustCrqsForm createState() => _CustCrqsForm();

}

class _CustCrqsForm extends State<CustCrqsForm> {
  //objeto para obtener los datos del cliente
  SoCustomer soCustomer = SoCustomer.empty();
  //controllers para campos del formulario
  final textRfcCntrll = TextEditingController();
  final textCurpCntrll = TextEditingController();
  //key para validación del formulario
  final _formKeyCustDetail = GlobalKey<FormState>();
  //id del cliente logeado
  late int idCustomer = 0;
  //id de referencia (Como conoció la empresa)
  late int referralId = 0;
  //addresses registradas
  late int custAddresses = 0;

  @override
  void initState(){
    //Se obtiene el cliente que se encuentra loggeado
    idCustomer = params.idLoggedUser;
    //Se obtiene el cliente y se guarda en el objeto
    fetchCustomer(idCustomer.toString()).then((value) {
      if(value){
        if(soCustomer.rfc != '') textRfcCntrll.text = soCustomer.rfc;
        if(soCustomer.curp != '') textCurpCntrll.text = soCustomer.curp;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarStyle.authAppBarFlex(title: 'Datos Personales'),
        body: AuthFormBackground(
          child: AuthListBackground(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  CardContainer(
                    child: addCustForm(),
                    ),
                ],
              ),
            ),
          ),
          ),
        );
  }

  Form addCustForm(){
    return Form(
      key: _formKeyCustDetail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [

          const SizedBox( height: 10 ),
          const Text('Datos Adicionales', style: TextStyle(color: Colors.grey, fontSize: 20)),
          const SizedBox( height: 10 ),
          TextFormField(
            decoration: InputDecorations.authInputDecoration(
                labelText: 'RFC*',
                prefixIcon: Icons.perm_identity_outlined),
            controller: textRfcCntrll,
            validator: ( value ) {
              return (value != null && value.isNotEmpty && value.length > 12 && value.length < 14)
                  ? null
                  : 'Por favor ingrese un rfc válido';
            },
          ),

          const SizedBox(height: 10,),

          TextFormField(
            decoration: InputDecorations.authInputDecoration(
                labelText: 'CURP*',
                prefixIcon: Icons.perm_identity_outlined),
            controller: textCurpCntrll,
            validator: ( value ) {
              return ( value != null && value.isNotEmpty && value.length > 17)
                  ? null
                  : 'Por favor ingrese un curp válido';
            },
          ),
          const SizedBox(height: 10,),
          SubCatalogContainerWidget(
              title: 'Domicilio(s)*',
              child: CustomerAddress(
                forceFilter: idCustomer,
                callback: (int addresses){
                  setState(() {
                    custAddresses = addresses;
                  });
                },
              )
          ),
          const SizedBox(height: 10,),
/*          SubCatalogContainerWidget(
              title: 'Referencias*',
              child: CustomerRelative(
                forceFilter: idCustomer,
              )
          ),*/
          DropdownWidget(
            callback: (String id) {
              setState(() {
                referralId = int.parse(id);
              });
            },
            programCode: 'REFE',
            label: 'Referencia*',
            dropdownValue: referralId.toString(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKeyCustDetail.currentState!.validate()) {
                  if(custAddresses>0){
                    if(referralId > 0){
                      // Actualiza registro
                      addCust(context);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Favor de seleccionar referencia')),
                      );
                    }
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Favor de agregar por lo menos un domicilio')),
                    );
                  }
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
    );
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

  // Actualiza el customer en el servidor
  Future<bool> addCust(BuildContext context,) async {
    soCustomer.rfc = textRfcCntrll.text;
    soCustomer.curp = textCurpCntrll.text;
    soCustomer.referralId = referralId;
/*    if(isSwitched){
      soCustomer.creditBureau = 1;
    }else{
      soCustomer.creditBureau = 0;
    }*/
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
      showAlertDialog(context);
      return true;
    } else {
      // Error al guardar
      print(response.body.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.body.toString())),
      );

      return false;
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancelar"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continuar"),
      onPressed:  () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustDataForm(creditRequest: SoCreditRequest.empty(),)),
        ).then((value) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreditRequestList()),
        ));
        },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Datos Actualizados Correctamente"),
      content: const Text("Ya cuenta con los datos básicos para realizar una Solicitud de Crédito"
          "¿Desea realizar una solicitud de crédito?"),
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

}

import 'dart:convert';

import 'package:flexwm/models/curl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;

import '../ui/input_decorations.dart';

class CustRelativeForm extends StatefulWidget{
  //Se recibe objeto para el fomulario
  final SoCustomerRelative soCustRelative;
  const CustRelativeForm({Key? key, required this.soCustRelative}) : super(key: key);

  @override
  State<CustRelativeForm> createState() => _CustRelativeFormState();
}

class _CustRelativeFormState extends State<CustRelativeForm>{
  //Se crean controllers para asignar valores en campos
  late String type = '';
  final textNameCntrll = TextEditingController();
  final textFatherLastNameCntrll = TextEditingController();
  final textMotherLastNameCntrll = TextEditingController();
  final textEmailCntrll = TextEditingController();
  final textNumberCntrll = TextEditingController();
  final textCellphoneCntrll = TextEditingController();
  // final textCntrll = TextEditingController();
  // final textInteriorNumberCntrll = TextEditingController();

  //key para el formulario
  final _formKey = GlobalKey<FormState>();
  //Objeto de tipo para manipular info
  SoCustomerRelative soCustRelative = SoCustomerRelative.empty();
  //Variables de campos cambiantes
  bool isSwitched = false;
  int responsible = 0;

  @override
  void initState(){
    if(widget.soCustRelative.id > 0 ){
      soCustRelative = widget.soCustRelative;
      type = widget.soCustRelative.type;
      textNameCntrll.text = widget.soCustRelative.fullName;
      textFatherLastNameCntrll.text = widget.soCustRelative.fatherLastName;
      textMotherLastNameCntrll.text = widget.soCustRelative.motherLastName;
      textEmailCntrll.text = widget.soCustRelative.email;
      textNumberCntrll.text = widget.soCustRelative.number;
      textCellphoneCntrll.text = widget.soCustRelative.cellPhone;
      if(widget.soCustRelative.responsible == 1) {
        isSwitched = true;
        responsible = 1;
      }
    }else{
      soCustRelative.customerId = params.idLoggedUser;
      type = 'P';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                      child: Text("Tipo*",
                        style: TextStyle(color: Colors.grey,fontSize: 15),
                      )
                  ),
                  DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: DropdownButton(
                        value: type,
                        items: SoCustomerRelative.getTypeOptions.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['label']),
                            value: e['value'],
                          );
                        }).toList(),
                        onChanged: (Object? value) {
                          setState(() {
                            type = '$value';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textNameCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Nombre",
                    labelText: "Nombre*",
                    prefixIcon: Icons.account_circle_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre válido';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textFatherLastNameCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Apellido Paterno",
                    labelText: "Apellido Paterno",
                    prefixIcon: Icons.account_circle_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
/*                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },*/
              ),
              const SizedBox(height: 10,),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textMotherLastNameCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Apellido Materno",
                    labelText: "Apellido Materno",
                    prefixIcon: Icons.account_circle_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
     /*           validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },*/
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textEmailCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Email",
                    labelText: "Email",
                    prefixIcon: Icons.email_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
/*                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },*/
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.phone,
                controller: textNumberCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Teléfono",
                    labelText: "Teléfono",
                    prefixIcon: Icons.phone_enabled_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
/*                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },*/
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.phone,
                controller: textCellphoneCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "T. Celular",
                    labelText: "T. Celular*",
                    prefixIcon: Icons.phone_iphone_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un Teléfono celular válido';

                },
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      if(value) {
                        responsible = 1;
                      } else {
                        responsible = 0;
                      }
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  ),
                  const Expanded(
                      child: Text("Responsable",
                        style: TextStyle(color: Colors.grey),
                      )
                  )
                ],
              ),
              // if(widget.soCustAddress.id < 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        updateCustomerRelative();
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
        )
    );
  }

  void updateCustomerRelative() async {
    soCustRelative.type = type;
    soCustRelative.fullName = textNameCntrll.text;
    soCustRelative.fatherLastName = textFatherLastNameCntrll.text;
    soCustRelative.motherLastName = textMotherLastNameCntrll.text;
    soCustRelative.email = textEmailCntrll.text;
    soCustRelative.cellPhone = textCellphoneCntrll.text;
    soCustRelative.number = textNumberCntrll.text;
    soCustRelative.responsible = responsible;

    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcurl;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCustRelative),
    );

    if (response.statusCode == params.servletResponseScOk) {
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado')),
      );

      Navigator.pop(context);
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

import 'dart:convert';

import 'package:flexwm/providers/cust_provider.dart';
import 'package:flexwm/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flexwm/ui/input_decorations.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../models/cust.dart';

class NewCustForm extends StatefulWidget {

  const NewCustForm({Key? key,
  }) : super(key: key);

  @override
  _NewCustForm createState() => _NewCustForm();

}

class _NewCustForm extends State<NewCustForm>{
  bool stepForm = false;
  //controllers para manejo de datos
  final nameCtrll = TextEditingController();
  final lastNameCtrll = TextEditingController();
  final custTypeController = TextEditingController();
  final dateContr = TextEditingController();
  final legalNameCtrll = TextEditingController();
  final emailCtrll = TextEditingController();
  final cellPhoneCtrll = TextEditingController();
  final textMotherLastNameCntrll = TextEditingController();
  final textPhoneContrll = TextEditingController();

  //Keys para formularios
  final _firstForm = GlobalKey<FormState>();
  final _secondForm = GlobalKey<FormState>();
  //mostrar carga visual
  bool isLoading = false;

  @override
  void initState() {
    custTypeController.text = SoCustomer.TYPE_PERSON;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(Icons.arrow_back,color: Colors.grey,),
          onPressed: (){
            if(stepForm){
              setState(() {
                stepForm = false;
              });
            }else{
              Navigator.pop(context);
            }
          },
          mini: true,
        ),
      ),
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox( height: 250 ),

              CardContainer(
                child: Column(
                  children: [

                    const SizedBox( height: 10 ),
                    const Text('Registro Cliente Nuevo', style: TextStyle(color: Colors.grey, fontSize: 20)),
                    const SizedBox( height: 20 ),

                    if(!stepForm)
                     stepOneForm()
                    else
                     stepTwoForm()
                  ],
                )
              ),

              const SizedBox( height: 50 ),
            ],
          ),
        )
      )
   );
  }

  Widget stepOneForm(){
    return Container(
      child: Form(
        key: _firstForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              controller: nameCtrll,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Nombre",
                  labelText: "*Nombre",
                  prefixIcon: Icons.account_circle_outlined
              ),
              validator: ( value ) {

                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un nombre válido';

              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              controller: lastNameCtrll,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Apellido Paterno",
                  labelText: "*Apellido Paterno",
                  prefixIcon: Icons.account_circle_outlined
              ),
              validator: ( value ) {

                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un apellido válido';

              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              controller: textMotherLastNameCntrll,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Apellido Materno",
                  labelText: "*Apellido Materno",
                  prefixIcon: Icons.account_circle_outlined
              ),
              validator: ( value ) {

                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un apellido válido';

              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(height: 10,),
                const Expanded(
                    child: Text("Tipo Cliente*",
                      style: TextStyle(color: Colors.grey,fontSize: 15),
                    )
                ),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: DropdownButton(
                      value: custTypeController.text,
                      items: SoCustomer.getTypeCustomer.map((e) {
                        return DropdownMenuItem(
                          child: Text(e['label']),
                          value: e['value'],
                        );
                      }).toList(),
                      onChanged: (Object? value) {
                        setState(() {
                          custTypeController.text = '$value';
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox( height: 40 ),

            MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromRGBO(37, 131, 170, 1),
                child: Container(
                    padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle( color: Colors.white ),
                    )
                ),
                onPressed: () async {
                  if(_firstForm.currentState!.validate()){
                    setState((){
                      stepForm = true;
                    });
                  }
                }
            )

          ],
        ),
      ),
    );
  }

  Widget stepTwoForm (){
    var now = DateTime.now();
    var formatterAno = DateFormat("y");
    return Container(
      child: Form(
        key: _secondForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            if(custTypeController.text == SoCustomer.TYPE_COMPANY)
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: legalNameCtrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Razón Social",
                    labelText: "Razón Social",
                    prefixIcon: Icons.account_circle_outlined
                ),
                validator: ( value ) {

                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese una razón social válida';

                },
              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Seleccione una Fecha",
                    labelText: (custTypeController.text == SoCustomer.TYPE_PERSON)
                        ? "Fecha de Nacimiento"
                        : "Fecha Constitución",
                    prefixIcon: Icons.calendar_today_outlined
                ),
                controller: dateContr,
                readOnly: true,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese una fecha válida';
                },
                onTap: (){
                  showDatePicker(
                    context: context,
                    initialDate: DateTime(int.parse(formatterAno.format(now))-18),
                    firstDate: DateTime(1910),
                    lastDate: DateTime(int.parse(formatterAno.format(now))-18),
                  ).then((DateTime? value){
                    if(value != null){
                      DateTime _formDate = DateTime.now();
                      _formDate = value;
                      final String date = DateFormat('yyyy-MM-dd').format(_formDate);
                      dateContr.text = date;
                    }
                  });
                },
              ),

            const SizedBox(height: 10),

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              controller: emailCtrll,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'tucorreo@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_rounded
              ),
              validator: ( value ) {

                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';

              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.phone,
              controller: textPhoneContrll,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Tel. Fijo',
                  labelText: 'Tel. Fijo',
                  prefixIcon: Icons.phone
              ),
              validator: ( value ) {
                final intNumber = int.tryParse(value!);
                return ( intNumber != null && value.length > 9 )
                    ? null
                    : 'Por favor ingrese un número de teléfono válido';

              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.phone,
              controller: cellPhoneCtrll,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Tel. Celular',
                  labelText: 'Tel. Celular',
                  prefixIcon: Icons.phone_iphone_outlined
              ),
              validator: ( value ) {
                final intNumber = int.tryParse(value!);
                return ( intNumber != null && value.length > 9 )
                    ? null
                    : 'Por favor ingrese un número de teléfono válido';

              },
            ),
            if(isLoading)
              const LinearProgressIndicator(),
            const SizedBox( height: 40 ),
            MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromRGBO(37, 131, 170, 1),
                child: Container(
                    padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                    child: Text(
                      isLoading
                          ? 'Espere'
                          : 'Agregar',
                      style: const TextStyle( color: Colors.white ),
                    )
                ),
                onPressed: () async {
                  if(_secondForm.currentState!.validate()){
                    setState(() {
                      isLoading = true;
                    });
                    addCust(context);
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  // Actualiza el wflowstep en el servidor
  void addCust(BuildContext context) async {
    SoCustomer soCustomer = SoCustomer.empty();
    soCustomer.customerType = custTypeController.text;
    soCustomer.legalName = legalNameCtrll.text;
    soCustomer.firstName = nameCtrll.text;
    soCustomer.fatherLastName = lastNameCtrll.text;
    soCustomer.email = emailCtrll.text;
    soCustomer.mobile = cellPhoneCtrll.text;
    soCustomer.birthdate = dateContr.text;
    soCustomer.phone = textPhoneContrll.text;
    soCustomer.motherlastname = textMotherLastNameCntrll.text;
    print('params instance -> ${params.instance}');
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
      setState((){isLoading = false;});
      // Si fue exitoso obtiene la respuesta
      soCustomer = SoCustomer.fromJson(jsonDecode(response.body));

      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente "' + soCustomer.email + '" registrado')),
      );
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favor de revisar su correo para activar su cuenta')),
      );
      // Regresa al login
      //Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginForm())
      );
    } else {
      setState((){isLoading = false;});
      // Error al guardar
      Navigator.pop(context);
      print('Error al Guardar ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al Guardar ${response.body}')),
      );
    }
  }
}
import 'dart:convert';

import 'package:flexwm/screens/autocomplete_example.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/cust.dart';
import '../providers/cust_provider.dart';
import '../ui/input_decorations.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../ui/input_decorations_invalid.dart';

class CustStepsForm extends StatelessWidget {
  const CustStepsForm({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _activeStepIndex = 0;
  bool _valid = false;
  late int salesManId = 0;
//fomr 3
  final leadController = TextEditingController();
  final notasRefController = TextEditingController();
  //form 0
  final custTypeController = TextEditingController();
  final displayNameController = TextEditingController();
  final legalNameController = TextEditingController();
  //form 1
  final firstNameController = TextEditingController();
  final fatherLastController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  //form 2
  final nssController = TextEditingController();
  final dateContr = TextEditingController();

  void _showModalFuenteOp(BuildContext context, CustFormProvider newCustForm) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 50,
                child: Center(
                  child: Text('Fuente de Lead'),
                ),
              ),
              const Divider(thickness: 2,color: Colors.blueGrey,),
              for(final opt in newCustForm.custLeadList)
                ListTile(
                  leading: const Icon(Icons.circle_outlined),
                  title:  Text(opt.label),
                  onTap: () {
                    newCustForm.referralId = opt.value;
                    newCustForm.referralLabel = opt.label;
                    leadController.text = opt.label;
                    Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 30,)
            ],
          );
        });
  }

  void _showModalBottomSheet(BuildContext context, CustFormProvider newCustForm) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 50,
                child: Center(
                  child: Text('Seleccione el tipo de cliente'),
                ),
              ),
              const Divider(thickness: 2,color: Colors.blueGrey,),
              for(final opt in newCustForm.custTypeList)
                ListTile(
                  leading: const Icon(Icons.circle_outlined),
                  title:  Text(opt.label),
                  onTap: () {
                    newCustForm.customerType = opt.value;
                    newCustForm.customerTypeName = opt.label;
                    custTypeController.text = opt.label;
                    Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 30,)
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    final newCustForm = Provider.of<CustFormProvider>(context);
    //form 0
    if(newCustForm.customerType != '') custTypeController.text = newCustForm.customerTypeName;
    if(newCustForm.displayName != '') displayNameController.text = newCustForm.displayName!;
    if(newCustForm.legalName != '') legalNameController.text = newCustForm.legalName!;
    // form 1
    if(newCustForm.firstName != '') firstNameController.text = newCustForm.firstName;
    if(newCustForm.fatherLastName != '') fatherLastController.text = newCustForm.fatherLastName;
    if(newCustForm.phone != '') phoneController.text = newCustForm.phone;
    if(newCustForm.email != '') emailController.text = newCustForm.email;
    //form 2
    if(newCustForm.nss != '') nssController.text = newCustForm.nss!;
    if(newCustForm.stablishMentDate != '') dateContr.text = newCustForm.stablishMentDate!;
    //form 3
    if(newCustForm.referralLabel != '') leadController.text = newCustForm.referralLabel;
    if(newCustForm.referralComments != '') notasRefController.text = newCustForm.referralComments!;
    newCustForm.salesManId = 97;
    List<Step> stepList() => [
      Step(
        state: (!_valid) ?_activeStepIndex <= 0 ? StepState.indexed : StepState.complete :StepState.error,
        isActive: _activeStepIndex >= 0,
        title: const Text('General'),
        content: Column(
          children: [
            TextFormField(
              decoration: (!_valid)
                  ? InputDecorations.authInputDecoration(
                  labelText: 'Tipo Cliente*',
                  sufixIcon: Icons.arrow_drop_down_circle_outlined)
                  : InputDecorationsInvalid.authInputDecoration(
                  labelText: 'Tipo Cliente*',
                  sufixIcon: Icons.arrow_drop_down_circle_outlined,),
              readOnly: true,
              controller: custTypeController,
              validator: ( value ) {
                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor seleccione tipo de cliente';
              },
              onTap: () => _showModalBottomSheet(context,newCustForm),
            ),
            const SizedBox(height: 10,),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              controller: displayNameController,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Nombre Comercial",
                  labelText: "Nombre Comercial",
                  prefixIcon: Icons.account_circle_outlined
              ),
              onChanged: ( value ) => newCustForm.displayName = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              // initialValue: newCustForm.legalName,
              controller: legalNameController,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Razón Social",
                  labelText: "Razón Social",
                  prefixIcon: Icons.ballot_outlined
              ),
              onChanged: ( value ) => newCustForm.legalName = value,
            ),
            const SizedBox(height: 10),
            /*TextFormField(
              autocorrect: false,
              readOnly: true,
              initialValue: "Cristian : Hernández",
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Vendedor",
                  labelText: "Vendedor*",
                  prefixIcon: Icons.assignment_ind_outlined
              ),
              validator: ( value ) {
                newCustForm.salesManId = 97;
                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un nombre valido';

              },
            ),*/
            AutocompleteExampleApp(
              label: 'Vendedor',
              programCode: 'USER',
              callback: (int id){
                salesManId = id;
              },
              autoValue: salesManId,
            )
          ],
        ),
      ),
      Step(
          state:
          (!_valid) ?_activeStepIndex <= 1 ? StepState.editing : StepState.complete :StepState.error,
          isActive: _activeStepIndex >= 1,
          title: const Text('Datos de Contacto'),
          content: Container(
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  controller: firstNameController,
                  decoration: (!_valid)
                      ?InputDecorations.authInputDecoration(
                      hintText: "Nombre",
                      labelText: "Nombre*",
                      prefixIcon: Icons.account_circle_outlined
                      )
                      :InputDecorationsInvalid.authInputDecoration(
                      hintText: "Nombre",
                      labelText: "Nombre*",
                      prefixIcon: Icons.account_circle_outlined
                      ),
                  onChanged: ( value ) => newCustForm.firstName = value,
                  validator: ( value ) {

                    return ( value != null && value.isNotEmpty )
                        ? null
                        : 'Por favor ingrese un nombre valido';

                  },
                ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    // initialValue: newCustForm.fatherLastName,
                    controller: fatherLastController,
                    decoration: (!_valid)
                        ?InputDecorations.authInputDecoration(
                        hintText: "Apellido Paterno*",
                        labelText: "Apellido Paterno",
                        prefixIcon: Icons.account_box_outlined
                        )
                        :InputDecorationsInvalid.authInputDecoration(
                        hintText: "Apellido Paterno*",
                        labelText: "Apellido Paterno",
                        prefixIcon: Icons.account_box_outlined
                        ),
                    onChanged: ( value ) => newCustForm.fatherLastName = value,
                    validator: ( value ) {

                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un apellido valido';

                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    // initialValue: newCustForm.phone,
                    controller: phoneController,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: "Teléfono",
                        labelText: "Teléfono",
                        prefixIcon: Icons.phone_iphone_outlined
                    ),
                    onChanged: ( value ) => newCustForm.phone = value,
                  ),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    // initialValue: newCustForm.email,
                    controller: emailController,
                    decoration: (!_valid)
                          ?InputDecorations.authInputDecoration(
                              hintText: 'tucorreo@gmail.com',
                              labelText: 'Email*',
                              prefixIcon: Icons.alternate_email_rounded
                          )
                          :InputDecorationsInvalid.authInputDecoration(
                          hintText: 'tucorreo@gmail.com',
                          labelText: 'Email*',
                          prefixIcon: Icons.alternate_email_rounded
                          ),
                    onChanged: ( value ) => newCustForm.email = value,
                    validator: ( value ) {

                      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp  = RegExp(pattern);

                      return regExp.hasMatch(value ?? '')
                          ? null
                          : 'El valor ingresado no luce como un correo';

                    },
                  ),
              ],
            ),
          )),
      Step(
          state:
          _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text('Datos de Adicionales'),
          content: Container(
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  // initialValue: newCustForm.nss,
                  controller: nssController,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: "Cta. Softrax",
                      labelText: "Cta. Softrax",
                      prefixIcon: Icons.add_alarm_outlined
                  ),
                  onChanged: ( value ) => newCustForm.nss = value,
                ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: "Seleccione una Fecha",
                        labelText: "Cuenta desde",
                        prefixIcon: Icons.calendar_today_outlined
                    ),
                    controller: dateContr,
                    readOnly: true,
                    onTap: (){
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2025),
                      ).then((DateTime? value){
                        if(value != null){
                          DateTime _formDate = DateTime.now();
                          _formDate = value;
                          final String date = DateFormat('yyyy-MM-dd').format(_formDate);
                          newCustForm.stablishMentDate = date;
                          dateContr.text = date;
                        }
                      });
                    },
                  ),
              ],
            ),
          )),
      Step(
          state: (!_valid) ?StepState.complete :StepState.error,
          isActive: _activeStepIndex >= 3,
          title: const Text('Datos de Referencia'),
          content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: (!_valid)
                        ?InputDecorations.authInputDecoration(
                        labelText: 'Fuente de Lead*',
                        sufixIcon: Icons.arrow_drop_down_circle_outlined
                        )
                        :InputDecorationsInvalid.authInputDecoration(
                        labelText: 'Fuente de Lead*',
                        sufixIcon: Icons.arrow_drop_down_circle_outlined
                        ),
                    controller: leadController,
                    readOnly: true,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor seleccione un dato';
                    },
                    onTap: () => _showModalFuenteOp(context,newCustForm),
                  ),
                    const SizedBox(height: 10),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      // initialValue: newCustForm.referralComments,
                      controller: notasRefController,
                      onChanged: (value) => newCustForm.referralComments = value,
                      decoration: InputDecorations.authInputDecoration(
                          hintText: "Notas Red.",
                          labelText: "Notas Red.",
                          prefixIcon: Icons.note_outlined
                      ),
                    ),
                ],
              )))
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Clientes', style: TextStyle(color: Colors.white),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 130, 146, 1),
                    Color.fromRGBO(112, 169, 179, 1.0)
                  ]
              )
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            newCustForm.vaciar();
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AuthFormBackground(
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _activeStepIndex,
          steps: stepList(),
          onStepContinue: () {
            if (_activeStepIndex < (stepList().length - 1)) {
              setState(() {
                _activeStepIndex += 1;
              });
            } else {
              print('Submited');
            }
          },
          onStepCancel: () {
            if (_activeStepIndex == 0) {
              return;
            }

            setState(() {
              _activeStepIndex -= 1;
            });
          },
          onStepTapped: (int index) {
            setState(() {
              _activeStepIndex = index;
            });
          },
          controlsBuilder: (context, details) {
            final isLastStep = _activeStepIndex == stepList().length - 1;
            return Row(
              children: [
                if(!isLastStep)
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: (isLastStep)
                        ? const Text('Guardar')
                        : const Text('Siguiente'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (_activeStepIndex > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Atras'),
                    ),
                  )
              ],
            );
          },
        ),
      ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.save_outlined,
            color: Color.fromRGBO(93, 109, 126, 1),
          ),
          backgroundColor: Colors.blueGrey.shade50,
          onPressed: () {
            newCustForm.salesManId = salesManId;
            if (newCustForm.isValidForm()) {
              addCust(context, newCustForm);
            } else {
              setState(() {
                _valid = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Favor de llenar los campos obligatorios')),
              );
            }
          },
        ));
  }
}

// Actualiza el wflowstep en el servidor
void addCust(BuildContext context, CustFormProvider custFormProv) async {
  SoCustomer soUser = SoCustomer.empty();
  soUser.customerType = custFormProv.customerType;
  soUser.displayName = custFormProv.displayName!;
  soUser.legalName = custFormProv.legalName!;
  soUser.salesManId = custFormProv.salesManId;
  soUser.firstName = custFormProv.firstName;
  soUser.fatherLastName = custFormProv.fatherLastName;
  soUser.email = custFormProv.email;
  soUser.phone = custFormProv.phone;
  soUser.nss = custFormProv.nss!;
  soUser.stablishMentDate = custFormProv.stablishMentDate!;
  soUser.referralId = custFormProv.referralId;
  soUser.referralComments = custFormProv.referralComments!;


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
    body: jsonEncode(soUser),
  );

  if (response.statusCode == params.servletResponseScOk) {
    // Si fue exitoso obtiene la respuesta
    soUser = SoCustomer.fromJson(jsonDecode(response.body));

    custFormProv.vaciar();
    // Muestra mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cliente "' + soUser.email + '" regitrado')),
    );
    // Regresa al listado
    Navigator.pop(context);
    // Navigator.pushNamed(context, '/photos');
  } else if (response.statusCode == params.servletResponseScNotAcceptable ||
      response.statusCode == params.servletResponseScForbidden) {
    // Error al guardar
    custFormProv.vaciar();
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
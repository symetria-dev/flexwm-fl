
import 'dart:convert';

import 'package:flexwm/providers/cust_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flexwm/ui/input_decorations.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../models/cust.dart';

class NewUserForm extends StatelessWidget {

  final bool step1;

  const NewUserForm({
    Key? key,
    required this.step1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newCustForm = Provider.of<CustFormProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(Icons.arrow_back,color: Colors.grey,),

          onPressed: (){
            if(step1) newCustForm.vaciar();
            Navigator.pop(context);
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

                    if(step1)
                     _NewUSerForm()
                    else
                     _NewUSerForm2()
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
}


class _NewUSerForm extends StatelessWidget {

  final nameCtrll = TextEditingController();
  final lastNameCtrll = TextEditingController();
  final custTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final newCustForm = Provider.of<CustFormProvider>(context);

    if(newCustForm.firstName != '') nameCtrll.text = newCustForm.firstName;
    if(newCustForm.fatherLastName != '') lastNameCtrll.text = newCustForm.fatherLastName;
    if(newCustForm.customerType != '') custTypeController.text = newCustForm.customerTypeName;

    return Container(
      child: Form(
        key: newCustForm.firstFormKey,
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
              onChanged: ( value ) {
                newCustForm.firstName = value;
                },
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
              controller: lastNameCtrll,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Apellido Paterno",
                  labelText: "*Apellido Paterno",
                  prefixIcon: Icons.account_circle_outlined
              ),
              onChanged: ( value ) => newCustForm.fatherLastName = value,
              validator: ( value ) {

                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un nombre valido';

              },
            ),

            const SizedBox(height: 10),

            TextFormField(
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Tipo Cliente*',
                  sufixIcon: Icons.arrow_drop_down_circle_outlined),
              readOnly: true,
              controller: custTypeController,
              validator: ( value ) {
                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor seleccione tipo de cliente';
              },
              onTap: () => _showModalBottomSheet(context,newCustForm),
            ),

/*            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: ( value ) => newUserForm.password = value,
              validator: ( value ) {

                String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    :'Contraseña invalida';

              },
            ),*/

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
                if(!newCustForm.isValidFirstForm()){
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewUserForm(step1: false,))
                );
              }
            )

          ],
        ),
      ),
    );
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
}

class _NewUSerForm2 extends StatelessWidget {

  final dateContr = TextEditingController();
  final legalNameCtrll = TextEditingController();
  final emailCtrll = TextEditingController();
  final phonCtrll = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final newCustForm = Provider.of<CustFormProvider>(context);

    if(newCustForm.birthdate != '') dateContr.text = newCustForm.birthdate!;
    if(newCustForm.legalName != '') legalNameCtrll.text = newCustForm.legalName!;
    if(newCustForm.email != '') emailCtrll.text = newCustForm.email;
    if(newCustForm.phone != '') phonCtrll.text = newCustForm.phone;

    return Container(
      child: Form(
        key: newCustForm.secondFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            if(newCustForm.customerType == SoCustomer.TYPE_COMPANY)
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              controller: legalNameCtrll,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Razón Social",
                  labelText: "Razón Social",
                  prefixIcon: Icons.account_circle_outlined
              ),
              onChanged: ( value ) => newCustForm.legalName = value,
              validator: ( value ) {

                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un nombre valido';

              },
            ),
            if(newCustForm.customerType == SoCustomer.TYPE_PERSON)
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Seleccione una Fecha",
                  labelText: "Fecha de Nacimiento",
                  prefixIcon: Icons.calendar_today_outlined
              ),
              controller: dateContr,
              readOnly: true,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Por favor ingrese una fecha valida';
              },
              onTap: (){
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1910),
                  lastDate: DateTime(2025),
                ).then((DateTime? value){
                  if(value != null){
                    DateTime _formDate = DateTime.now();
                    _formDate = value;
                    final String date = DateFormat('yyyy-MM-dd').format(_formDate);
                    newCustForm.birthdate = date;
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
              onChanged: ( value ) => newCustForm.email = value,
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
              controller: phonCtrll,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Tel. Celular',
                  labelText: 'Tel. Celular',
                  prefixIcon: Icons.phone_iphone_outlined
              ),
              onChanged: ( value ) => newCustForm.phone = value,
              validator: ( value ) {
                final intNumber = int.tryParse(value!);
                return ( intNumber != null && value.length > 9 )
                    ? null
                    : 'Por favor ingrese un número de teléfono valido';

              },
            ),

            const SizedBox( height: 40 ),

            MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromRGBO(37, 131, 170, 1),
                child: Container(
                    padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                    child: Text(
                      newCustForm.isLoading
                          ? 'Espere'
                          : 'Agregar',
                      style: const TextStyle( color: Colors.white ),
                    )
                ),
                onPressed: () async {

                  FocusScope.of(context).unfocus();

                  if( !newCustForm.isValidSecondForm() ) {
                    return;
                  }
                  newCustForm.isLoading = true;

                  addCust(context, newCustForm);

                  newCustForm.isLoading = false;
                  // Navigator.pushReplacementNamed(context, 'home');
                }
            )

          ],
        ),
      ),
    );


  }

}

// Actualiza el wflowstep en el servidor
void addCust(BuildContext context, CustFormProvider custFormProv) async {
  SoCustomer soUser = SoCustomer.empty();
  soUser.customerType = custFormProv.customerType;
  soUser.legalName = custFormProv.legalName!;
  soUser.firstName = custFormProv.firstName;
  soUser.fatherLastName = custFormProv.fatherLastName;
  soUser.email = custFormProv.email;
  soUser.phone = custFormProv.phone;
  soUser.birthdate = custFormProv.birthdate!;
  soUser.salesManId = 97;


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
    //Navigator.pop(context);
     Navigator.pushNamed(context, '/login');
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
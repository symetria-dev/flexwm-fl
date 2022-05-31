
import 'dart:convert';

import 'package:flexwm/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flexwm/providers/login_form_provider.dart';
import 'package:provider/provider.dart';

import 'package:flexwm/ui/input_decorations.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

class NewUserForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back,color: Colors.grey,),

          onPressed: (){
            Navigator.pop(context);
          },
          mini: true,
        ),
      ),*/
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox( height: 250 ),

              CardContainer(
                child: Column(
                  children: [

                    const SizedBox( height: 10 ),
                    const Text('Nuevo usuario', style: TextStyle(color: Colors.grey, fontSize: 20)),
                    const SizedBox( height: 20 ),
                    
                    ChangeNotifierProvider(
                      create: ( _ ) => UserFormProvider(),
                      child: _NewUSerForm()
                    )


                  ],
                )
              ),

              // SizedBox( height: 50 ),
              // Text('Crear una nueva cuenta', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold ),),
              const SizedBox( height: 50 ),
            ],
          ),
        )
      )
   );
  }
}


class _NewUSerForm extends StatelessWidget {

  SoUser soUser = SoUser.empty();

  @override
  Widget build(BuildContext context) {

    final newUserForm = Provider.of<UserFormProvider>(context);

    return Container(
      child: Form(
        key: newUserForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Nombre",
                  labelText: "Nombre",
                  prefixIcon: Icons.account_circle_outlined
              ),
              onChanged: ( value ) => newUserForm.name = value,
              validator: ( value ) {

                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un nombre valido';

              },
            ),

            const SizedBox(height: 10),

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'tucorreo@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: ( value ) => newUserForm.email = value,
              validator: ( value ) {

                  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp  = RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';

              },
            ),

            SizedBox( height: 10 ),

            TextFormField(
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
            ),

            const SizedBox( height: 10 ),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Confirmar Contraseña',
                  prefixIcon: Icons.lock_outline
              ),
              onChanged: ( value ) => newUserForm.passwordConf = value,
              validator: ( value ) {

                String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    :'Contraseña invalida';

              },
            ),

            const SizedBox( height: 30 ),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color.fromRGBO(37, 131, 170, 1),
              child: Container(
                padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                child: Text(
                  newUserForm.isLoading
                    ? 'Espere'
                    : 'Agregar',
                  style: const TextStyle( color: Colors.white ),
                )
              ),
              onPressed: () async {

                FocusScope.of(context).unfocus();

                if( !newUserForm.isValidForm() ) {
                  return;
                } else if(newUserForm.password != newUserForm.passwordConf){
                  // Muestra mensaje
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Las contraseñas no coinciden')),
                  );
                  return;
                }

                newUserForm.isLoading = true;

                addUSer(context, newUserForm);

                newUserForm.isLoading = false;
                // Navigator.pushReplacementNamed(context, 'home');
              }
            )

          ],
        ),
      ),
    );
  }

  // Actualiza el wflowstep en el servidor
  void addUSer(BuildContext context, UserFormProvider loginForm) async {
    soUser.email = loginForm.email;
    soUser.password = loginForm.password;
    soUser.passwordConf = loginForm.passwordConf;
    soUser.firstname = loginForm.name;

    // Envia la sesion como Cookie, con el nombre en UpperCase
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restuser;' +
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
      soUser = SoUser.fromJson(jsonDecode(response.body));

      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario "' + soUser.email + '" regitrado')),
      );

      // Regresa al listado
      Navigator.pop(context);
      Navigator.pushNamed(context, '/');
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
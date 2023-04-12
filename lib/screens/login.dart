// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'package:flexwm/screens/reset_pwd.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flexwm/models/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flexwm/common/params.dart' as params;

import 'new_cust_form.dart';

// Create a Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Forma de wflowstep con estado
class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final instanceController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  SoLogin soLogin = SoLogin.empty();
  //Progresindicator envio de datos
  bool sendingData = false;

  @override
  void initState(){
    // Primero libera la sesion existente
    doLogout();
    // Asigna datos previos de persistencia
    setPrevData();
    sendingData = false;
    // instanceController.text = '-edupass';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SharedPreferences.setMockInitialValues({});
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250,),

              CardContainer(
                child: Column(

                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox( height: 10 ),
                    const Text('Inicio de Sesión', style: TextStyle(color: Colors.grey, fontSize: 20)),
                    const SizedBox( height: 20 ),
/*                Flexible(
                      child:Image.asset('images/logo.png'),
                    ),*/
/*                Text(
                      'App FlexWM',
                      style: Theme.of(context).textTheme.headline1,
                    ),*/
                    getLoginForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Prepara la forma
  Widget getLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
         /* TextFormField(
            //initialValue: soWFlowStep.name,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresar Instancia';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Instancia',
            ),
            controller: instanceController,
          ),*/
          TextFormField(
            //initialValue: soWFlowStep.name,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresar Correo';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
            controller: emailController,
          ),
          TextFormField(
            //initialValue: soWFlowStep.description,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresar contraseña';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Password',
            ),
            obscureText: true,
            controller: passwordController,
          ),
          if(sendingData)
            const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    sendingData = true;
                  });
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  doLogin();
                }
              },
              child: const Text('Ingresar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Nuevo Registro | ',
                      style: const TextStyle(color: Colors.blue,fontSize: 16),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NewCustForm())
                          );
                        }
                  ),
                  TextSpan(
                      text: 'Olvide mi Password',
                      style: const TextStyle(color: Colors.blue,fontSize: 16),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ResetPassword())
                          );
                        }
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  // Envia datos de logout al servidor
  void doLogout() async {
    // Si hay sesion abierta
    if (params.instance != '') {
      await http.Client().get(Uri.parse(
          params.getAppUrl(params.instance) + 'restlogout;' +
              params.jSessionIdQuery + '=' + params.jSessionId));
    }
  }

  // Envia datos de login al servidor
  void doLogin() async {
    soLogin.email = emailController.text;
    soLogin.password = passwordController.text;
    instanceController.text = params.instance;

    final response = await http.post(
      //TODO colocar de forma dinamica que tipo de usuario hara login
      Uri.parse(params.getAppUrl(instanceController.text) + 'restlogincust'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(soLogin),
    );

    if (response.statusCode == 200) {
      soLogin = SoLogin.fromJson(jsonDecode(response.body));
      doContinue();
      Navigator.pushReplacementNamed(context, '/crqs_list');
      //setState(() {sendingData = false;});
    } else {

      print(response.body.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de Login')),
      );

      passwordController.text = '';
      setState(() {sendingData = false;});
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Error de Login: ' + response.statusCode.toString());
    }
  }

  // Obtiene instancia y email de persistencia
  void setPrevData() async {
    final prefs = await SharedPreferences.getInstance();

    String instance = prefs.getString('instance') ?? '';
    String email = prefs.getString('email') ?? '';

   /* if (instance != '') {
      instanceController.text = instance;
    } else {
      instanceController.text = '_flexwm-js';
    }*/

    if (email != '') {
      emailController.text = email;
      passwordController.text = '2020Cris*';
    }
  }

  // Asigna email y nombres a persistencia
  void doContinue() async {
    // Obtiene datos de persistencia
    final prefs = await SharedPreferences.getInstance();
    // Asigna valores persistentes
    prefs.setString('instance', instanceController.text);
    prefs.setString('email', soLogin.email);

    params.jSessionId = soLogin.jSessionId;
    params.instance = instanceController.text;
    params.firstname = soLogin.firstname;
    params.lastname = soLogin.lastname;
    params.email = soLogin.email;
    params.photoUrl = soLogin.photoUrl;
    //TODO detectar tipo de login de forma dinamica
    params.loggedCust = true;
    params.idLoggedUser = soLogin.idLoggedUser;
  }
}
// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flexwm/models/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flexwm/common/params.dart' as params;

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

  @override
  void dispose() {
    // Limpia controladores al eliminar pantalla
    instanceController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SharedPreferences.setMockInitialValues({});

    // Primero libera la sesion existente
    doLogout();

    return Scaffold(
      backgroundColor: params.bgColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/logo.png'),
              Text(
                'App FlexWM',
                style: Theme.of(context).textTheme.headline1,
              ),
              getLoginForm(),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Prepara la forma
  Widget getLoginForm() {
    // Asigna datos previos de persistencia
    setPrevData();

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
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
          ),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
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
    soLogin.email = emailController.text;
    soLogin.password = passwordController.text;

    final response = await http.post(
      Uri.parse(params.getAppUrl(instanceController.text) + 'restlogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(soLogin),
    );

    if (response.statusCode == 200) {
      soLogin = SoLogin.fromJson(jsonDecode(response.body));
      doContinue();
      Navigator.pushReplacementNamed(context, '/wflowsteps');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de Login')),
      );

      passwordController.text = '';
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

    if (instance != '') {
      instanceController.text = instance;
    } else {
      instanceController.text = '_flexwm-js';
    }

    if (email != '') {
      emailController.text = email;
      passwordController.text = 'Viruliento99';
    } else {
      emailController.text = 'mlopez@flexwm.com';
      passwordController.text = 'Viruliento99\$';
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
  }
}
// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  SoLogin soLogin = SoLogin.empty();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.setMockInitialValues({});

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/logo.png'),
              Text(
                'Welcome',
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
    previousEmail();

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
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

  // Envia datos de login al servidor
  void doLogin() async {
    soLogin.email = emailController.text;
    soLogin.password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://localhost:8080/flexwm-js/restlogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(soLogin),
    );

    if (response.statusCode == 200) {
      soLogin = SoLogin.fromJson(jsonDecode(response.body));
      doContinue();

      Navigator.pushReplacementNamed(context, '/catalog');
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

  // Obtiene email de persistencia
  void previousEmail() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // set value
    String email = prefs.getString('email') ?? '';

    if (email != '') {
      emailController.text = email;
    } else {
      emailController.text = 'mlopez@flexwm.com!';
      passwordController.text = 'Viruliento99';
    }
  }

  // Asigna email y nombres a persistencia
  void doContinue() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString('email', soLogin.email);

    params.jSessionId = soLogin.jSessionId;
    params.firstname = soLogin.firstname;
    params.lastname = soLogin.lastname;
    params.email = soLogin.email;
  }
}

import 'package:flexwm/routes/routes.dart';
import 'package:flexwm/widgets/auth_background.dart';
import 'package:flexwm/widgets/card_container.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../ui/input_decorations.dart';

class ResetPassword extends StatefulWidget{

  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetoPassword createState() => _ResetoPassword();
  
}

class _ResetoPassword extends State<ResetPassword>{
  //controllers para el manejo de datos
  final emailCtrll = TextEditingController();
  //key del formulario
  final _resetPswForm = GlobalKey<FormState>();
  //mostrar carga visual
  bool isLoading = false;

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
              Navigator.pop(context);
          },
          mini: true,
        ),
      ),
      body: AuthBackground(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox( height: 250,),

                CardContainer(
                    child: Column(
                      children: [
                        const SizedBox( height: 10 ),
                        const Text('Solicitar reestablecer password', style: TextStyle(color: Colors.grey, fontSize: 20)),
                        const SizedBox( height: 20 ),
                          stepForm()
                      ],
                    )
                ),
                const SizedBox(height: 50,),
              ],
            ),
          )
      ),
    );
  }

  Widget stepForm(){
    return Container(
      child: Form(
          key: _resetPswForm,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
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
              const SizedBox(height: 20,),
              if(isLoading)
                const LinearProgressIndicator(),
              const SizedBox( height: 20 ),
              MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  // color: Colors.deepOrange,
                  color: Colors.blueGrey,
                  child: Container(
                      padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                      child: Text(
                        isLoading
                            ? 'Espere'
                            : 'Solicitar',
                        style: const TextStyle( color: Colors.white ),
                      )
                  ),
                  onPressed: () async {
                    if(_resetPswForm.currentState!.validate()){
                      setState(() {
                        isLoading = true;
                      });
                      addCust(context);
                    }
                  }
              )
            ],
          )
      ),
    );
  }

  // Actualiza el wflowstep en el servidor
  void addCust(BuildContext context) async {
    SoCustomer soCustomer = SoCustomer.empty();
    soCustomer.email = emailCtrll.text;
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

      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Su solicitud ha sido enviada con éxito')),
      );
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favor de revisar su correo para restablecer password')),
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
      print('Error al Guardar ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al solicitar restablecer contraseña')),
      );
    }
  }
}
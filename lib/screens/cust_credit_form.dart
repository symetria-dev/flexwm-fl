
import 'dart:convert';

import 'package:flexwm/models/crqs.dart';
import 'package:flexwm/routes/routes.dart';
import 'package:flexwm/screens/cuad_screen.dart';
import 'package:flexwm/screens/curl_screen.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flexwm/widgets/sub_catalog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'package:flexwm/ui/input_decorations.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../routes/app_routes.dart';
import '../widgets/card_stepcontainer.dart';
import '../widgets/dropdown_widget.dart';


class CustDataForm extends StatefulWidget {
  final bool step1;

  const CustDataForm({Key? key, required this.step1}) : super(key: key);

  @override
  _CustDataFormState createState() => _CustDataFormState();

}

class _CustDataFormState extends State<CustDataForm>{
  //objeto para obtener los datos del cliente
  SoCustomer soCustomer = SoCustomer.empty();
  //objeto para los datos de la solicitud del credito
  SoCreditRequest soCreditRequest = SoCreditRequest.empty();
  //Indice indicador de paso activo
  int _activeStepIndex = 0;

  //controllers para campos del formulario
  final textRfcCntrll = TextEditingController();
  final textCurpCntrll = TextEditingController();
  bool isSwitched = false;
  //controllers campos step2
  final textMontoCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  late String creditDestiny = '';
  int monthSelected = 0;
  final textPagoMonthCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  int currencyId = 0;
  int creditTypeId = 0;
  int orderTypeId = 0;
  int creditProfileId = 0;
  int wflowTypeId = 0;

  //keys para validaciones de formularios en cada paso
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  final _formKeyStep4 = GlobalKey<FormState>();

  late int idCustomer = 0;
  //Valor del checkbox buro de crédito

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

    creditDestiny = 'D';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //lista de pasos para formularios
    List<Step> stepList()=> [
      stepDataAditional(),
      stepCreditRequest(),
      stepMoreDataCust(),
      stepEmploymentSituation(),
    ];

   return Scaffold(
     appBar: AppBarStyle.authAppBarFlex(title: "Datos Personales"),
     body: AuthFormBackground(
       child: Stepper(
         steps: stepList(),
         type: StepperType.horizontal,
         currentStep: _activeStepIndex,
         onStepContinue: () {
           if(validStep(_activeStepIndex)) {
             setState(() {
               _activeStepIndex += 1;
             });
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
           return;
           //Funcion para ir al step al dar click en el icono
           /*          setState(() {
              _activeStepIndex = index;
            });*/
         },
         controlsBuilder: (context, details) {
           //valor del último paso
           final isLastStep = _activeStepIndex == stepList().length - 1;
           return Row(
             children: [
               const SizedBox(height: 100,),
               //Si es el último paso muestra Guardar en el texto del botón
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
   );
  }

  //Validaciones para avanzar step
   bool validStep (int step) {
    bool valid = false;
    switch (step){
      case 0:
        if(_formKeyStep1.currentState!.validate()) {
          soCustomer.rfc = textRfcCntrll.text;
          soCustomer.curp = textCurpCntrll.text;
          //Se guardan los datos y se valida si no hubo errores al guardar
          // addCust(context, soCustomer).then((value) {
          //   if(value){
          //     return true;
          //   }else{
          //     return false;
          //   }
          // });

        }else{
          return false;
        }
        break;
      case 1:
        if(_formKeyStep2.currentState!.validate()){
         /* addCreditRequest().then((value) {
            if(value){valid = true;}else{valid = false;}
          });*/
          return true;
        }else{
          return valid;
        }
    }
    return true;
  }

  Step stepDataAditional() {
    return Step(
      state:  _activeStepIndex <= 0 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >=0,
        title: const Text(''),
        content: CardStepContainer(
          child: Form(
            key: _formKeyStep1,
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
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese un rfc valido';
                      },
                ),

                const SizedBox(height: 10,),

                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'CURP*',
                      prefixIcon: Icons.perm_identity_outlined),
                  controller: textCurpCntrll,
                    validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese un curp valido';
                      },
                ),
                const SizedBox(height: 10,),
                SubCatalogContainerWidget(
                    title: 'Domicilio(s)*',
                    child: CustomerAddress(
                        forceFilter: idCustomer,
                    )
                ),
                const SizedBox(height: 10,),
                SubCatalogContainerWidget(
                    title: 'Referencias*',
                    child: CustomerRelative(
                        forceFilter: idCustomer,
                    )
                ),
                const SizedBox(height: 10,),

                Row(
                  children: [
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        if(!isSwitched){
                          _confirmPassword();
                        }else {
                          setState(() {
                            isSwitched = value;
                          });
                        }
                      },
                    ),
                    const Expanded(
                        child: Text("Confirmación de autorización para revisar "
                            "buro de credito",
                          style: TextStyle(color: Colors.grey),
                        )
                    )
                  ],
                ),
              ],),
          ),
        )
    );
  }

  //Funcion para validad contraseña
  Future<void> _confirmPassword() async{
    bool passValid = false;
    final textPassCntrll = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirme su Contraseña'),
            content: TextField(
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Contraseña'
              ),
              controller: textPassCntrll,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    if(textPassCntrll.text == soCustomer.passw){
                      setState(() {
                        isSwitched = true;
                        // Muestra mensaje
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contraseña Correcta')),
                        );
                        Navigator.pop(context);
                      });
                    }else{
                      // Muestra mensaje
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contraseña Inconrrecta')),
                      );
                      Navigator.pop(context);
                    }
                  },
                textColor: Colors.blue,
                  child: const Text('Confirmar'),
              )
            ],
          );
        }
    );
  }


  Step stepCreditRequest() {
    return Step(
      state: _activeStepIndex <=1 ? StepState.indexed : StepState.complete,
      isActive: _activeStepIndex >= 1,
        title: const Text(""),
        content: CardStepContainer(
          child: Form(
              key: _formKeyStep2,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [

                const SizedBox( height: 10 ),
                const Text('Solicitud de Credito', style: TextStyle(color: Colors.grey, fontSize: 20)),
                const SizedBox( height: 10 ),
                DropdownWidget(
                  callback: (String id) {
                    setState(() {
                      currencyId = int.parse(id);
                    });
                  },
                  programCode: 'CURE',
                  label: 'Divisa',
                  dropdownValue: soCreditRequest.currencyId.toString(),
                ),
                const SizedBox( height: 10 ),
          /*      TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Destino del crédito*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  *//* validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese un rfc valido';
                      },*//*
                ),*/
                Row(
                  children: [
                    const Expanded(
                        child: Text("Destino del Crédito*",
                          style: TextStyle(color: Colors.grey,fontSize: 15),
                        )
                    ),
                    DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        child: DropdownButton(
                          value: creditDestiny,
                          items: SoCreditRequest.getDestinyOptions.map((e) {
                            return DropdownMenuItem(
                              child: Text(e['label']),
                              value: e['value'],
                            );
                          }).toList(),
                          onChanged: (Object? value) {
                            setState(() {
                              creditDestiny = '$value';
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                DropdownWidget(
                  callback: (String id) {
                    setState(() {
                      creditTypeId = int.parse(id);
                    });
                  },
                  programCode: 'CRTY',
                  label: 'Tipo de Crédito',
                  dropdownValue: soCreditRequest.creditTypeId.toString(),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Monto solicitado*',
                      prefixIcon: Icons.monetization_on_outlined),
                  controller: textMontoCntrll,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10, ),
                const Text('Plazo solicitado (meses)', style: TextStyle(color: Colors.grey, fontSize: 15)),
                const SizedBox( height: 10,),
                Wrap(
                  spacing: 6,
                  direction: Axis.horizontal,
                  children: plazosChips(),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Pago mensual deseado*',
                      prefixIcon: Icons.payments_outlined),
                  controller: textPagoMonthCntrll,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox( height: 10 ),
                DropdownWidget(
                  callback: (String id) {
                    setState(() {
                      orderTypeId = int.parse(id);
                    });
                  },
                  programCode: 'ORTP',
                  label: 'Tipos de Pedidos',
                  dropdownValue: soCreditRequest.oderTypeId.toString(),
                ),
                const SizedBox( height: 10 ),
                DropdownWidget(
                  callback: (String id) {
                    setState(() {
                      creditProfileId = int.parse(id);
                    });
                  },
                  programCode: 'CRPF',
                  label: 'Perfiles de Crédito',
                  dropdownValue: soCreditRequest.creditProfileId.toString(),
                ),
                const SizedBox( height: 10 ),
                DropdownWidget(
                  callback: (String id) {
                    setState(() {
                      wflowTypeId = int.parse(id);
                    });
                  },
                  programCode: 'WFTY',
                  label: 'Tipos Wflow',
                  dropdownValue: soCreditRequest.wflowTypeId.toString(),
                ),
                const SizedBox(height: 30,)
              ])
          ),
        )
    );
  }

  List<Widget> plazosChips(){
    List<String> _chipsList = ["6","9","12","18","24","30","36","48"];
    List<Widget> chips = [];
    for(int i=0;i<_chipsList.length;i++){
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10,right: 5),
        child: ChoiceChip(
            label: Text(_chipsList[i]),
            labelStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.blueGrey,
            selected: monthSelected == i,
          onSelected: (bool value){
              setState((){
                monthSelected = i;
              });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  Step stepMoreDataCust() {
    return Step(
        state: _activeStepIndex <= 2 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 2,
        title: const Text(""),
        content: CardStepContainer(
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [

                const SizedBox( height: 10 ),
                const Text('Datos Personales', style: TextStyle(color: Colors.grey, fontSize: 20)),
                const SizedBox( height: 10 ),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Datos escolares*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /* validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese un rfc valido';
                      },*/
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Información familiar*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 30,)
              ])
          ),
        )
    );
  }

  Step stepEmploymentSituation() {
    return Step(
        state: _activeStepIndex <= 3 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 3,
        title: const Text(""),
        content: CardStepContainer(
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [

                const SizedBox( height: 10 ),
                const Text('Situación Laboral', style: TextStyle(color: Colors.grey, fontSize: 20)),
                const SizedBox( height: 10 ),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Estatus laboral*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /* validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese un rfc valido';
                      },*/
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Nombre de la empresa*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Giro/Actividad económica*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Años en el empleo*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 30,),
                const Text("Información Económica"),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Ingreso mensual neto*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Otros ingresos*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Pago mensual aproximado*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Tarjetas de credito*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Renta o crédito hipotcario*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Crédito automotríz*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Crédito de muebles o línea blanca*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Préstamos personales*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 30,),
              ])
          ),
        )
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
  //Petición de datos de una solicitud de credito especifica
  Future<bool> fetchCreditRequest(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcrqs;' +
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
  Future<bool> addCust(BuildContext context, SoCustomer soCustomer) async {

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados correctamente')),
      );
      return true;
    } else {
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al Guardar')),
      );

      return false;
    }
  }

  // Actualiza el customer en el servidor
  Future<bool> addCreditRequest() async {
    soCreditRequest.amountRequired = textMontoCntrll.numberValue;
    soCreditRequest.destiny = creditDestiny;
    soCreditRequest.deadlineRequired = monthSelected;
    soCreditRequest.monthlyPayment = textPagoMonthCntrll.numberValue;
    soCreditRequest.currencyId = currencyId;
    soCreditRequest.creditTypeId = creditTypeId;
    soCreditRequest.oderTypeId = orderTypeId;
    soCreditRequest.creditProfileId = creditProfileId;
    soCreditRequest.wflowTypeId = wflowTypeId;

    // Envia la sesion como Cookie, con el nombre en UpperCase
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcrqs;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCreditRequest),
    );

    if (response.statusCode == params.servletResponseScOk) {

      // Si fue exitoso obtiene la respuesta
      soCreditRequest = SoCreditRequest.fromJson(jsonDecode(response.body));

      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados correctamente')),
      );
      return true;
    } else {
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al Guardar')),
      );
      return false;
    }
  }
}



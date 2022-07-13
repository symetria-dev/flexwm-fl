
import 'dart:convert';

import 'package:flexwm/providers/cust_provider.dart';
import 'package:flexwm/routes/routes.dart';
import 'package:flexwm/screens/cuad_screen.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flexwm/widgets/sub_catalog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flexwm/ui/input_decorations.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../widgets/card_stepcontainer.dart';


class CustDataForm extends StatefulWidget {
  final bool step1;
  const CustDataForm({Key? key, required this.step1}) : super(key: key);

  @override
  _CustDataFormState createState() => _CustDataFormState();

}

class _CustDataFormState extends State<CustDataForm>{
  //Indice indicador de paso activo
  int _activeStepIndex = 0;

  late int idCustomer = 0;
  bool isSwitched = false;

  @override
  void initState(){
    print("cust_credit");
    print(params.idLoggedUser);
    idCustomer = params.idLoggedUser;
    print(idCustomer);
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
             setState(() {
               _activeStepIndex += 1;
             });
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

  Step stepDataAditional() {
    return Step(
        title: const Text(''),
        content: CardStepContainer(
          child: Form(
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
                  // controller: custTypeController,
                  /* validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese un rfc valido';
                      },*/
                ),

                const SizedBox(height: 10,),

                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'CURP*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10,),
                SubCatalogContainerWidget(
                    title: 'Domicilio(s)*',
                    child: CustomerAddress(
                        forceFilter: idCustomer,
                    )
                ),
                const SizedBox(height: 10,),

                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Referencias*',
                      prefixIcon: Icons.perm_identity_outlined),
                  // controller: custTypeController,
                  /*  validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor seleccione tipo de cliente';
                      },*/
                ),
                const SizedBox(height: 10,),

                Row(
                  children: [
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
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

  Step stepCreditRequest() {
    return Step(
        title: const Text(""),
        content: CardStepContainer(
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [

                const SizedBox( height: 10 ),
                const Text('Solicitud de Credito', style: TextStyle(color: Colors.grey, fontSize: 20)),
                const SizedBox( height: 10 ),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Destino del crédito*',
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
                      labelText: 'Monto solicitado*',
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
                      labelText: 'Plazo solicitado*',
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
                      labelText: 'Pago mensual deseado*',
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

  Step stepMoreDataCust() {
    return Step(
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
}


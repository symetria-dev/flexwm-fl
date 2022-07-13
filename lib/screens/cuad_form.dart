import 'dart:convert';

import 'package:flexwm/models/cuad.dart';
import 'package:flexwm/screens/autocomplete_example.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;

import '../ui/input_decorations.dart';

class CustAddressForm extends StatefulWidget{
  //Se recibe objeto para el fomulario
  final SoCustAddres soCustAddress;
  const CustAddressForm({Key? key, required this.soCustAddress}) : super(key: key);

  @override
  State<CustAddressForm> createState() => _CustAddressFormState();
}

class _CustAddressFormState extends State<CustAddressForm>{
  //Se crean controllers para asignar valores en campos
  late String type = '';
  final textStreetCntrll = TextEditingController();
  final textNumberCntrll = TextEditingController();
  final textNeighborhoodCntrll = TextEditingController();
  final textZipCntrll = TextEditingController();
  final textDescriptionCntrll = TextEditingController();
  final textCityCntrll = TextEditingController();
  final textDeliveryAddressCntrll = TextEditingController();
  final textInteriorNumberCntrll = TextEditingController();

  //key para el formulario
  final _formKey = GlobalKey<FormState>();
  //Objeto de tipo para manipular info
  SoCustAddres soCustAddres = SoCustAddres.empty();
  //Variables de campos cambiantes
  int cityId = 0;
  bool isSwitched = false;
  int deliveryAddress = 0;

  @override
  void initState(){
    if(widget.soCustAddress.id > 0 ){
      soCustAddres = widget.soCustAddress;
      type = widget.soCustAddress.type;
      textStreetCntrll.text = widget.soCustAddress.street;
      textNumberCntrll.text = widget.soCustAddress.number;
      textNeighborhoodCntrll.text = widget.soCustAddress.neighborhood;
      textZipCntrll.text = widget.soCustAddress.zip;
      textDescriptionCntrll.text = widget.soCustAddress.description;
      textCityCntrll.text = widget.soCustAddress.cityId.toString();
      if(widget.soCustAddress.deliveryAddress == 1) {
        isSwitched = true;
        deliveryAddress = 1;
      }
      textInteriorNumberCntrll.text = widget.soCustAddress.interiorNumber;
    }else{
      soCustAddres.customerId = params.idLoggedUser;
      type = 'P';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: DropdownButton(
                        value: type,
                        items: SoCustAddres.getTypeOptions.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['label']),
                            value: e['value'],
                          );
                        }).toList(),
                        onChanged: (Object? value) {
                          setState(() {
                            type = '$value';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textStreetCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Calle",
                    labelText: "Calle*",
                    prefixIcon: Icons.add_road
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textNumberCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "No. exterior",
                    labelText: "No. exterior*",
                    prefixIcon: Icons.add_road
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textInteriorNumberCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "No. interior",
                    labelText: "No. interior",
                    prefixIcon: Icons.add_road
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textNeighborhoodCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Colonia",
                    labelText: "Colonia*",
                    prefixIcon: Icons.add_road
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textZipCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "C.P.",
                    labelText: "C.P.*",
                    prefixIcon: Icons.add_road
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textDescriptionCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Descripción",
                    labelText: "Descripción*",
                    prefixIcon: Icons.add_road
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },
              ),
              const SizedBox(height: 10,),
              AutocompleteExampleApp(
                  programCode: 'CITY',
                  label: 'Ciudad*',
                  callback: (int id){
                    cityId = id;
                    textCityCntrll.text = id.toString();
                  },
                  autoValue: cityId,
                  textValue: textCityCntrll.text,
                  inValid: false
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      if(value) {
                        deliveryAddress = 1;
                      } else {
                        deliveryAddress = 0;
                      }
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  ),
                  const Expanded(
                      child: Text("Dirección de entrega?",
                        style: TextStyle(color: Colors.grey),
                      )
                  )
                ],
              ),
              if(widget.soCustAddress.id < 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        updateCustomerAddress();
                      }
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
    );
  }

  void updateCustomerAddress() async {
    soCustAddres.type = type;
    soCustAddres.street = textStreetCntrll.text;
    soCustAddres.number = textNumberCntrll.text;
    soCustAddres.interiorNumber = textInteriorNumberCntrll.text;
    soCustAddres.neighborhood = textNeighborhoodCntrll.text;
    soCustAddres.zip = textZipCntrll.text;
    soCustAddres.description = textDescriptionCntrll.text;
    soCustAddres.cityId = cityId;
    soCustAddres.deliveryAddress = deliveryAddress;

    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcuad;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCustAddres),
    );

    if (response.statusCode == params.servletResponseScOk) {
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado')),
      );

      Navigator.pop(context);
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
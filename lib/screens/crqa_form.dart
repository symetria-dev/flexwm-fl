import 'dart:convert';

import 'package:flexwm/models/crqa.dart';
import 'package:flexwm/models/crqg.dart';
import 'package:flexwm/screens/autocomplete_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;
import 'package:intl/intl.dart';

import '../ui/input_decorations.dart';

class CreditRequestAssetsForm extends StatefulWidget{
  //Se recibe objeto para el fomulario
  final SoCreditRequestAsset soCreditRequestAsset;
  final SoCreditRequestGuarantee soCreditRequestGuarantee;
  const CreditRequestAssetsForm({Key? key, required this.soCreditRequestAsset,
    required this.soCreditRequestGuarantee, }) : super(key: key);

  @override
  State<CreditRequestAssetsForm> createState() => _CreditRequestAssetsFormState();
}

class _CreditRequestAssetsFormState extends State<CreditRequestAssetsForm>{
  //Se crean controllers para asignar valores en campos
  final textDescriptionCntrll = TextEditingController();
  final textValueCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textPurchaseDateCntrll = TextEditingController();
  final textFolioCntrll = TextEditingController();
  final textDeedNumberCntrll = TextEditingController();
  final textCivicNumberCntrll = TextEditingController();
  final textStreetCntrll = TextEditingController();
  final textExtNumberCntrll = TextEditingController();
  final textIntNumberCntrll = TextEditingController();
  final textZipCntrll = TextEditingController();
  final textInvoiceCntrll = TextEditingController();
  final textBrandCntrll = TextEditingController();
  final textModelCntrll = TextEditingController();
  final textYearCntrll = TextEditingController();
  final textSerialCntrll = TextEditingController();
  final textMotorCntrll = TextEditingController();
  final textCommentsCntrll = TextEditingController();
  final textStatusCntrll = TextEditingController();
  //Variables de campos cambiantes
  int cityId = 0;
  late String type = '';
  int creditRequestId = 0;
  int creditRequestGuarantee = 0;

  //key para el formulario
  final _formKeyInmueble = GlobalKey<FormState>();
  final _formKeyAuto = GlobalKey<FormState>();
  //Objeto de tipo para manipular info
  SoCreditRequestAsset soCreditRequestAsset = SoCreditRequestAsset.empty();

  @override
  void initState(){
    if(widget.soCreditRequestGuarantee.role == SoCreditRequestGuarantee.ROLE_GUARANTEE){
      type = SoCreditRequestAsset.TYPE_PROPERTY;
    }else{
      type = SoCreditRequestAsset.TYPE_AUTO;
    }
    if(widget.soCreditRequestAsset.id > 0 ){
      soCreditRequestAsset = widget.soCreditRequestAsset;
      textDescriptionCntrll.text = widget.soCreditRequestAsset.description;
      textValueCntrll.updateValue(widget.soCreditRequestAsset.value);
      textPurchaseDateCntrll.text = widget.soCreditRequestAsset.purchaseDate;
      textFolioCntrll.text = widget.soCreditRequestAsset.folio;
      textDeedNumberCntrll.text = widget.soCreditRequestAsset.deedNumber;
      textCivicNumberCntrll.text = widget.soCreditRequestAsset.civicNumber;
      textStreetCntrll.text = widget.soCreditRequestAsset.street;
      textExtNumberCntrll.text = widget.soCreditRequestAsset.extNumber;
      textIntNumberCntrll.text = widget.soCreditRequestAsset.intNumber;
      textZipCntrll.text = widget.soCreditRequestAsset.zip;
      textInvoiceCntrll.text = widget.soCreditRequestAsset.invoice;
      textBrandCntrll.text = widget.soCreditRequestAsset.brand;
      textModelCntrll.text = widget.soCreditRequestAsset.model;
      textYearCntrll.text = widget.soCreditRequestAsset.year.toString();
      textSerialCntrll.text = widget.soCreditRequestAsset.serial;
      textMotorCntrll.text = widget.soCreditRequestAsset.motor;
      textCommentsCntrll.text = widget.soCreditRequestAsset.comments;
      textStatusCntrll.text = widget.soCreditRequestAsset.status;
      if(widget.soCreditRequestAsset.cityId > 0) cityId = widget.soCreditRequestAsset.cityId;
    }
    creditRequestGuarantee = widget.soCreditRequestGuarantee.id;
    creditRequestId = widget.soCreditRequestGuarantee.creditRequestId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.soCreditRequestGuarantee.role == SoCreditRequestGuarantee.ROLE_GUARANTEE)
        ? formInmueble()
        : formAuto();
  }

  Widget formInmueble(){
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKeyInmueble,
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              const SizedBox( height: 10 ),
              const Text('Inmueble', style: TextStyle(color: Colors.grey, fontSize: 20)),
              const SizedBox( height: 10 ),
            /*  Row(
                children: [
                  const Expanded(
                      child: Text("Tipo*",
                        style: TextStyle(color: Colors.grey,fontSize: 15),
                      )
                  ),
                  DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: DropdownButton(
                        value: type,
                        items: SoCreditRequestAsset.getTypeOptions.map((e) {
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
              const SizedBox(height: 10,),*/
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textValueCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Valor Comercial",
                    labelText: "Valor Comercial*",
                    prefixIcon: Icons.monetization_on_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un el valor';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textDeedNumberCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "No. Escritura",
                    labelText: "No. Escritura*",
                    prefixIcon: Icons.file_open
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
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Seleccione una Fecha",
                    labelText: "Fecha Escritura",
                    prefixIcon: Icons.calendar_today_outlined),
                controller: textPurchaseDateCntrll,
                readOnly: true,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese una fecha valida';
                },
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1910),
                    lastDate: DateTime(2050),
                  ).then((DateTime? value) {
                    if (value != null) {
                      DateTime _formDate = DateTime.now();
                      _formDate = value;
                      final String date =
                      DateFormat('yyyy-MM-dd').format(_formDate);
                      textPurchaseDateCntrll.text = date;
                    }
                  });
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textFolioCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Folio",
                    labelText: "Folio*",
                    prefixIcon: Icons.numbers_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Seleccione una Fecha",
                    labelText: "Fecha Inscripción",
                    prefixIcon: Icons.calendar_today_outlined),
                controller: textPurchaseDateCntrll,
                readOnly: true,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese una fecha valida';
                },
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1910),
                    lastDate: DateTime(2025),
                  ).then((DateTime? value) {
                    if (value != null) {
                      DateTime _formDate = DateTime.now();
                      _formDate = value;
                      final String date =
                      DateFormat('yyyy-MM-dd').format(_formDate);
                      textPurchaseDateCntrll.text = date;
                    }
                  });
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textValueCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Valor Compra",
                    labelText: "Valor Compra*",
                    prefixIcon: Icons.home_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un valor valido';

                },
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
                      : 'Por favor ingrese una calle valida';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textExtNumberCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "No. Exterior",
                    labelText: "No. Exterior*",
                    prefixIcon: Icons.add_road
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nuúmero valido';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textIntNumberCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "No. Interior",
                    labelText: "No. Interior",
                    prefixIcon: Icons.add_road
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textZipCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "C.P.",
                    labelText: "C.P.*",
                    prefixIcon: Icons.home_work_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un c.p. valido';

                },
              ),
              const SizedBox(height: 10,),
              AutocompleteExampleApp(
                  programCode: 'CITY',
                  label: 'Ciudad*',
                  callback: (int id){
                    cityId = id;
                  },
                  autoValue: cityId,
                  textValue: cityId.toString(),
                  inValid: false
              ),
              // if(widget.soCustAddress.id < 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(_formKeyInmueble.currentState!.validate()){
                      updateCreditRequestAsset();
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

  Widget formAuto(){
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKeyAuto,
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              const SizedBox( height: 10 ),
              const Text('Auto', style: TextStyle(color: Colors.grey, fontSize: 20)),
              const SizedBox( height: 10 ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textInvoiceCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Número de Factura",
                    labelText: "Número de Factura*",
                    prefixIcon: Icons.numbers_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Seleccione una Fecha",
                    labelText: "Fecha Factura",
                    prefixIcon: Icons.calendar_today_outlined),
                controller: textPurchaseDateCntrll,
                readOnly: true,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese una fecha valida';
                },
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1910),
                    lastDate: DateTime(2025),
                  ).then((DateTime? value) {
                    if (value != null) {
                      DateTime _formDate = DateTime.now();
                      _formDate = value;
                      final String date =
                      DateFormat('yyyy-MM-dd').format(_formDate);
                      textPurchaseDateCntrll.text = date;
                    }
                  });
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textValueCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Valor Factura",
                    labelText: "Valor Factura*",
                    prefixIcon: Icons.monetization_on_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un el valor';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textValueCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Valor Comercial",
                    labelText: "Valor Comercial*",
                    prefixIcon: Icons.monetization_on_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un el valor';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textSerialCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "No. de Serie",
                    labelText: "No. de Serie*",
                    prefixIcon: Icons.file_open
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un número valido';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textMotorCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "No. de Motor",
                    labelText: "No. de Motor*",
                    prefixIcon: Icons.file_open
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un número valido';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textBrandCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Marca",
                    labelText: "Marca*",
                    prefixIcon: Icons.numbers_outlined
                ), validator: ( value ) {
                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un la marca';

              },
                // onChanged: ( value ) => newCustForm.firstName = value,
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textModelCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Modelo",
                    labelText: "Modelo*",
                    prefixIcon: Icons.numbers_outlined
                ), validator: ( value ) {
                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un el modelo';

              },
                // onChanged: ( value ) => newCustForm.firstName = value,
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textYearCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Año",
                    labelText: "Año*",
                    prefixIcon: Icons.add_road
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese el año';

                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(_formKeyAuto.currentState!.validate()){
                      updateCreditRequestAsset();
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
  void updateCreditRequestAsset() async {
    soCreditRequestAsset.type = type;
    soCreditRequestAsset.description = textDescriptionCntrll.text;
    soCreditRequestAsset.value = textValueCntrll.numberValue;
    soCreditRequestAsset.purchaseDate = textPurchaseDateCntrll.text;
    soCreditRequestAsset.folio = textFolioCntrll.text;
    soCreditRequestAsset.deedNumber = textDeedNumberCntrll.text;
    soCreditRequestAsset.civicNumber = textCivicNumberCntrll.text;
    soCreditRequestAsset.street = textStreetCntrll.text;
    soCreditRequestAsset.extNumber = textExtNumberCntrll.text;
    soCreditRequestAsset.intNumber = textIntNumberCntrll.text;
    soCreditRequestAsset.zip = textZipCntrll.text;
    soCreditRequestAsset.invoice = textInvoiceCntrll.text;
    soCreditRequestAsset.brand = textBrandCntrll.text;
    soCreditRequestAsset.model = textModelCntrll.text;
    if(textYearCntrll.text != '')soCreditRequestAsset.year = int.parse(textYearCntrll.text);
    soCreditRequestAsset.serial = textSerialCntrll.text;
    soCreditRequestAsset.motor = textMotorCntrll.text;
    soCreditRequestAsset.comments = textCommentsCntrll.text;
    soCreditRequestAsset.status = textStatusCntrll.text;
    if(cityId > 0) soCreditRequestAsset.cityId = cityId;
    soCreditRequestAsset.creditRequestId = creditRequestId;
    soCreditRequestAsset.creditRequestGuaranteeId = creditRequestGuarantee;
    soCreditRequestAsset.description = type;

    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcrqa;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCreditRequestAsset),
    );

    if (response.statusCode == params.servletResponseScOk) {
      Navigator.pop(context);
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado')),
      );

      // Navigator.pop(context);
    } else if (response.statusCode == params.servletResponseScNotAcceptable ||
        response.statusCode == params.servletResponseScForbidden) {
      // Error al guardar
      Fluttertoast.showToast(msg: response.body.toString());
    } else {
      // Aun no se recibe respuesta del servidor
      const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

}
import 'dart:convert';

import 'package:flexwm/models/crqa.dart';
import 'package:flexwm/models/crqg.dart';
import 'package:flexwm/screens/autocomplete_example.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flexwm/widgets/card_stepcontainer.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/data.dart';
import '../routes/app_routes.dart';
import '../ui/input_decorations.dart';
import '../widgets/upload_file_widget.dart';
import '../widgets/upload_file_widgetIcon.dart';

class CreditRequestAssetsForm extends StatefulWidget{
  //Se recibe objeto para el fomulario
  final SoCreditRequestAsset soCreditRequestAsset;
  final SoCreditRequestGuarantee soCreditRequestGuarantee;
  final String? label;
  const CreditRequestAssetsForm({Key? key, required this.soCreditRequestAsset,
    required this.soCreditRequestGuarantee, this.label, }) : super(key: key);

  @override
  State<CreditRequestAssetsForm> createState() => _CreditRequestAssetsFormState();
}

class _CreditRequestAssetsFormState extends State<CreditRequestAssetsForm>{
  //indicador de progress modal overlay
  bool _isInAsyncCall = false;
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
  String cityText = '';
  late String assetType = '-';
  int creditRequestId = 0;
  int creditRequestGuarantee = 0;
  bool firstStep = true;

  //key para el formulario
  final _formKeyInmueble = GlobalKey<FormState>();
  final _formKeyAuto = GlobalKey<FormState>();
  final _assetForm = GlobalKey<FormState>();
  //Objeto de tipo para manipular info
  SoCreditRequestAsset soCreditRequestAsset = SoCreditRequestAsset.empty();
  //mostrar carga visual
  bool isLoading = false;

  //key para subir archivo foto
  final GlobalKey<uploadFileIcon> _keyUploadPhoto = GlobalKey();
  bool isCreated = false;

  @override
  void initState(){
    if(widget.soCreditRequestAsset.id > 0 ){
      isCreated = true;
      soCreditRequestAsset = widget.soCreditRequestAsset;
      assetType = soCreditRequestAsset.type;
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
      if(widget.soCreditRequestAsset.cityId > 0) {
          cityId = widget.soCreditRequestAsset.cityId;
          cityText = widget.label!;
      }
    }
    creditRequestGuarantee = widget.soCreditRequestGuarantee.id;
    creditRequestId = widget.soCreditRequestGuarantee.creditRequestId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarStyle.authAppBarFlex(title: 'Garantía'),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          progressIndicator: const CircularProgressIndicator(),
          child: AuthFormBackground(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30,),
                  CardContainer(
                      child: firstForm(),
                  ),
                  const SizedBox(height: 30,),
                  if(isLoading)
                    const LinearProgressIndicator(),
                  if(soCreditRequestAsset.id < 1 || firstStep)
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
                                : 'Agregar',
                            style: const TextStyle( color: Colors.white ),
                          )
                      ),
                      onPressed: () async {
                        if(_assetForm.currentState!.validate() && assetType != '-'){
                          updateCreditRequestAsset().then((value) {
                            if (value) {
                              setState(() {
                                firstStep = false;
                              });
                              Fluttertoast.showToast(
                                  msg: 'Registro agregado con éxito.');
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Ocurrió un error a guardar registro.');
                            }
                          });
                        }else{
                          Fluttertoast.showToast(msg: 'Seleccione tipo de garantía');
                        }
                      }
                  ),
                  if(soCreditRequestAsset.id > 0 && !firstStep)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            disabledColor: Colors.grey,
                            elevation: 0,
                            // color: Colors.deepOrange,
                            color: Colors.blueGrey,
                            child: Container(
                                padding: const EdgeInsets.symmetric( horizontal: 50, vertical: 15),
                                child: const Text('Volver',
                                  style: TextStyle( color: Colors.white ),
                                )
                            ),
                            onPressed: () async {
                                setState(() {
                                  firstStep=true;
                                });
                            }
                        ),
                        MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            disabledColor: Colors.grey,
                            elevation: 0,
                            // color: Colors.deepOrange,
                            color: Colors.blueGrey,
                            child: Container(
                                padding: const EdgeInsets.symmetric( horizontal: 50, vertical: 15),
                                child: const Text('Guardar',
                                  style: TextStyle( color: Colors.white ),
                                )
                            ),
                            onPressed: () async {
                                if(assetType == SoCreditRequestAsset.TYPE_AUTO && assetType != '-'){
                                  if(_formKeyAuto.currentState!.validate()){
                                    updateCreditRequestAsset().then((value) {
                                      if(value){
                                        Fluttertoast.showToast(msg: 'Registro agregado con éxito.');
                                        Navigator.pop(context);
                                      }else{
                                        Fluttertoast.showToast(msg: 'Ocurrió un error a guardar registro.');
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                }else if(assetType == SoCreditRequestAsset.TYPE_PROPERTY && assetType != '-'){
                                  if(_formKeyInmueble.currentState!.validate()){
                                    updateCreditRequestAsset().then((value) {
                                      if(value){
                                        Fluttertoast.showToast(msg: 'Registro agregado con éxito.');
                                        Navigator.pop(context);
                                      }else{
                                        Fluttertoast.showToast(msg: 'Ocurrió un error a guardar registro.');
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                }else{
                                  Fluttertoast.showToast(msg: 'Seleccione tipo de garantía');
                                }
                              }
                        ),
                      ],
                    ),
                  const SizedBox( height: 40 ),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget firstForm(){
    if(soCreditRequestAsset.id < 1 || firstStep){
      return assetForm();
    }else{
      if(assetType != '-' && assetType == 'A') {
        return formAuto();
      }
      if(assetType != '-' && assetType == 'P') {
        return formInmueble();
      }
    }
    return const Text('');
  }

  Widget assetForm(){
    return Form(
      key: _assetForm,
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      // const Text("Garantía"),
                      // const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Expanded(
                              child: Text("Tipo*",
                                style: TextStyle(color: Colors.grey,fontSize: 15),
                              )
                          ),
                          DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              child: DropdownButton(
                                value: assetType,
                                items: SoCreditRequestAsset.getTypeOptions.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['label']),
                                    value: e['value'],
                                  );
                                }).toList(),
                                onChanged: (Object? value) {
                                  setState(() {
                                    assetType = '$value';
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        controller: textDescriptionCntrll,
                        decoration: InputDecorations.authInputDecoration(
                            hintText: "Descripción",
                            labelText: "Descripción*",
                            prefixIcon: Icons.description
                        ),
                        // onChanged: ( value ) => newCustForm.firstName = value,
                        validator: ( value ) {
                          return ( value != null && value.isNotEmpty )
                              ? null
                              : 'Por favor ingrese una descripción válida';

                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        controller: textValueCntrll,
                        decoration: InputDecorations.authInputDecoration(
                            hintText: "Valor",
                            labelText: "Valor*",
                            prefixIcon: Icons.monetization_on_outlined
                        ),
                        // onChanged: ( value ) => newCustForm.firstName = value,
                        validator: ( value ) {
                          final intNumber = double.tryParse(value!.replaceAll(',', ''));
                          return (intNumber != null && intNumber > 0)
                              ? null
                              : 'Por favor ingrese el valor';
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        decoration: InputDecorations.authInputDecoration(
                            hintText: "Seleccione una Fecha",
                            labelText: "Fecha de Compra*",
                            prefixIcon: Icons.calendar_today_outlined),
                        controller: textPurchaseDateCntrll,
                        readOnly: true,
                        validator: (value) {
                          return (value != null && value.isNotEmpty)
                              ? null
                              : 'Por favor ingrese una fecha válida';
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
                    ],
                  ),
                )
            );
  }

/* updateDataCRQA(){
    fetchCrqa(soCreditRequestAsset.id.toString()).then((value) {
      _keyUploadPhoto.currentState?.updateData(soCreditRequestAsset.photo);
      _keyUploadPhoto.currentState?.updateId(soCreditRequestAsset.id.toString());

    });

  }*/

  updateDataCRQA(){
    fetchCrqa(soCreditRequestAsset.id.toString()).then((value) {
      _keyUploadPhoto.currentState?.updateData(soCreditRequestAsset.photo);
      _keyUploadPhoto.currentState?.updateId(soCreditRequestAsset.id.toString());

    });

  }


  Widget formInmueble(){
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKeyInmueble,
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              UploadFileIcon(
                  key: _keyUploadPhoto,
                  initialRuta: soCreditRequestAsset.photo,
                  programCode: SoCreditRequestAsset.programCode,
                  fielName: 'crqa_photo',
                  label: 'Foto',
                  id: soCreditRequestAsset.id.toString(),
                  idGuarantee: '',
                  callBack: (bool isLoading) {
                    setState(() {
                      _isInAsyncCall = isLoading;
                    });
                    updateDataCRQA();
                  },
                ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textFolioCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Folio real RPP",
                    labelText: "Folio real RPP*",
                    prefixIcon: Icons.numbers_outlined
                ),
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese un folio válido';
                },
                // onChanged: ( value ) => newCustForm.firstName = value,
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
                      : 'Por favor ingrese No. Escritura';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textCivicNumberCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Cta. Catastral",
                    labelText: "Cta. Catastral",
                    prefixIcon: Icons.numbers_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
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
                      : 'Por favor ingrese una calle válida';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
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
                      : 'Por favor ingrese un número válido';

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
                      : 'Por favor ingrese un c.p. válido';

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
                  textValue: cityText,
                  inValid: false
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
              UploadFileIcon(
                  key: _keyUploadPhoto,
                  initialRuta: soCreditRequestAsset.photo,
                  programCode: SoCreditRequestAsset.programCode,
                  fielName: 'crqa_photo',
                  label: 'Foto',
                  id: soCreditRequestAsset.id.toString(),
                  idGuarantee: '',
                  callBack: (bool isLoading) {
                    setState(() {
                      _isInAsyncCall = isLoading;
                    });
                    updateDataCRQA();
                  },
                ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textInvoiceCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Número de Factura",
                    labelText: "Número de Factura*",
                    prefixIcon: Icons.numbers_outlined
                ),
                validator: (value) {
                  return (value != null && value.isNotEmpty && value.length <= 10)
                      ? null
                      : 'Por favor ingrese número de factura (menos o igual a 10 caracteres)';
                },
                // onChanged: ( value ) => newCustForm.firstName = value,
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
                      : 'Por favor ingrese un número válido';

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
                      : 'Por favor ingrese un número válido';

                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textBrandCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Marca",
                    labelText: "Marca*",
                    prefixIcon: Icons.car_crash
                ), validator: ( value ) {
                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese una marca';

              },
                // onChanged: ( value ) => newCustForm.firstName = value,
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textModelCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Modelo",
                    labelText: "Modelo*",
                    prefixIcon: Icons.numbers_outlined
                ), validator: ( value ) {
                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese el modelo';

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
                    prefixIcon: Icons.date_range_outlined
                ),
                // onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {
                  final intNumber = int.tryParse(value!);
                  return (intNumber != null && intNumber > 0)
                      ? null
                      : 'Favor de ingresar un año válido (solo números)';
                },
              ),
            ],
          ),
        )
    );
  }

  //Peticon de datos de una garantia en especifico
  Future<bool> fetchCrqa(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcrqa;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?idAsset=' +
            id.toString()));

    // Si no es exitoso envia a login
    /*if (response.statusCode != params.servletResponseScOk) {
      Navigator.pushNamed(context, AppRoutes.initialRoute);
    }*/

    setState((){
      soCreditRequestAsset = SoCreditRequestAsset.fromJson(jsonDecode(response.body));
    });
    return true;
  }

  Future<bool> updateCreditRequestAsset() async {
    setState(() {
      isLoading = true;
    });
    soCreditRequestAsset.type = assetType;
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
      // Navigator.pop(context);
      // Muestra mensaje
      setState(() {
        isLoading = false;
        isCreated = true;
        soCreditRequestAsset = SoCreditRequestAsset.fromJson(jsonDecode(response.body));
      });
      Fluttertoast.showToast(msg: 'Registro actualizado correctamente');
     /* ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado')),
      );*/

return true;
      // Navigator.pop(context);
    } else if (response.statusCode == params.servletResponseScNotAcceptable ||
        response.statusCode == params.servletResponseScForbidden) {
      // Error al guardar
      print(response.body.toString());
      Fluttertoast.showToast(msg: 'Error al guardar garantía: ${response.body.toString()}');
      return false;
    } else {return false;
      // Aun no se recibe respuesta del servidor
      const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

}
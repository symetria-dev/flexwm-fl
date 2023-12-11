import 'dart:convert';

import 'package:flexwm/models/crqa.dart';
import 'package:flexwm/models/crqg.dart';
import 'package:flexwm/models/cust.dart';
import 'package:flexwm/screens/crqa_form.dart';
import 'package:flexwm/screens/crqa_screen.dart';
import 'package:flexwm/widgets/auth_formbackground.dart';
import 'package:flexwm/widgets/auth_listbackground.dart';
import 'package:flexwm/widgets/card_stepcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/crqs.dart';
import '../models/cuad.dart';
import '../routes/app_routes.dart';
import '../ui/appbar_flexwm.dart';
import '../ui/input_decorations.dart';
import '../widgets/card_container.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/show_image.dart';
import '../widgets/sub_catalog_widget.dart';
import '../widgets/upload_file_widget.dart';
import '../widgets/upload_file_widgetIcon.dart';
import '../widgets/upload_id_photo_widget.dart';
import 'autocomplete_example.dart';
import 'cuad_screen.dart';

class CreditRequestGuarateeForm2 extends StatefulWidget{
  //Se recibe objeto para el fomulario
  final SoCreditRequestGuarantee soCreditRequestGuarantee;
  final int creditRequestId;
  final bool requiredAsset;
  final bool requiredAcredited;
  final int whoProccess;
  const CreditRequestGuarateeForm2({Key? key,
    required this.soCreditRequestGuarantee,
    required this.creditRequestId, required this.requiredAsset,
    required this.requiredAcredited, required this.whoProccess}) : super(key: key);

  @override
  State<CreditRequestGuarateeForm2> createState() => _CreditRequestGuarateeForm2State();
}

class _CreditRequestGuarateeForm2State extends State<CreditRequestGuarateeForm2>{

  final List<SoCustAddres> _customerAddressListData = [];
  //Lista de garantias por solicitud de crédito
  final List<SoCreditRequestAsset> _creditRequestAssetListData = [];
  //Se crean controllers de garantías para asignar valores en campos
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
  //key para subir archivo foto
  final GlobalKey<uploadFileIcon> _keyUploadPhoto = GlobalKey();
  //Objeto de tipo para manipular info
  SoCreditRequestAsset soCreditRequestAsset = SoCreditRequestAsset.empty();

  //Indice indicador de paso activo
  int _activeStepIndex = 0;
  //datos de aval/cliente
  SoCustomer soCustomer = SoCustomer.empty();
  //Se crean controllers para asignar valores en campos generales de aval
  late String role = SoCreditRequestGuarantee.ROLE_ACREDITED;
  late String relation = SoCreditRequestGuarantee.RELATION_SELF;
  final textFisrtNameCntrll = TextEditingController();
  final textFatherLastNameCntrll = TextEditingController();
  final textMotherLastNameCntrll = TextEditingController();
  final textBirthdateCntrll = TextEditingController();
  final textCellphoneCntrll = TextEditingController();
  final textEmailCntrll = TextEditingController();
  final textRfcCntrll = TextEditingController();
  final textCurpCntrll = TextEditingController();
  late String maritalStatus = SoCustomer.MARITALSTATUS_SINGLE;
  late String regimenMarital = SoCustomer.REGIMEN_CONJUGAL_SOCIETY;
  String msjResponsServer = '';

  final textEconomicDepCntrll = TextEditingController();
  final textTypeHousingCntrll = TextEditingController();
  final textYearsResidenceCntrll = TextEditingController();
  late String msjError = '';
  //controllers form financiero
  bool income = false;
  bool employment = false;
  bool expenses = false;

  final textCiecCntrll = TextEditingController();
  final textAccountStatementCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textPayrollReceiptsCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textVerifiableIncomeCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textHeritageCntrll = TextEditingController();
  late String employmentStatus = SoCreditRequestGuarantee.STATUS_EMPLOYEE;
  final textCompanyCntrll = TextEditingController();
  final textEconomicActCntrll = TextEditingController();
  final textYearsEmploymentCntrll = TextEditingController();
  final textCreditCardsCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textRentCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textCreditAutomotiveCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textCreditFurniturCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textPersonalLoansCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textSpouseNameCntrll = TextEditingController();

  //Keys para formularios de información financiera
  final _formKeyTwo = GlobalKey<FormState>();
  //key formulario gatantias
  final _formAssets = GlobalKey<FormState>();
  //key para el formulario general
  final _formKeyOne = GlobalKey<FormState>();
  //key para el formulario general
  final _formKeyOneOne = GlobalKey<FormState>();
  //Objeto de tipo para manipular info
  SoCreditRequestGuarantee soCreditRequestGuarantee = SoCreditRequestGuarantee.empty();

  //key para actualizar widget uploadFile despues de subir archivo
  final GlobalKey<uploadIdPhoto> _keyUploadIdentification = GlobalKey();
  final GlobalKey<uploadIdPhoto> _keyUploadIdentificationBack = GlobalKey();
  final GlobalKey<uploadFile> _keyUploadProofIncome = GlobalKey();
  final GlobalKey<uploadFile> _keyUploadFiscalSituation = GlobalKey();
  final GlobalKey<uploadFile> _keyUploadVerifiableIncome = GlobalKey();
  final GlobalKey<uploadFile> _keyUploadDeclaratory = GlobalKey();
  final GlobalKey<uploadFile> _keyUploadProofAddress = GlobalKey();
  final GlobalKey<uploadFile> _keyUploadIdentityVideo = GlobalKey();
  //indicador de aval creado
  bool avalCreated = false;
  //id aval
  int creditRequestGuaranteeId = 0;
  // id cliente
  int customerId = 0;
  //bandera para editar campos de aval
  bool isSameGuarantee = false;
  //indicador de progress modal overlay
  bool _isInAsyncCall = false;
  //tipo de garantia
  String assetType = '-';
  //key para el formulario
  final _formKeyInmueble = GlobalKey<FormState>();
  final _formKeyAuto = GlobalKey<FormState>();

  String title = '';

  // El solicitante es el acreditado
  bool whoProccess = false;

  @override
  void initState(){
    if(widget.requiredAcredited){
      title = 'Acreditado Titular';
    }else{
      title = 'Coacreditado';
    }

    if(widget.soCreditRequestGuarantee.id > 0 ){
      customerId = widget.soCreditRequestGuarantee.soCustomer.id;

        fetchCrqg(widget.soCreditRequestGuarantee.id.toString()).then((value) {
          avalCreated = true;
          soCreditRequestGuarantee = widget.soCreditRequestGuarantee;
          setState(() {
            creditRequestGuaranteeId = soCreditRequestGuarantee.id;
          });
          if(soCreditRequestGuarantee.creditBureau > 0){
            isSwitched = true;
          }else{
            isSwitched = false;
          }

          if(widget.whoProccess > 0 || soCreditRequestGuarantee.creditBureau > 0){
            whoProccess = true;
          }

          if(soCreditRequestGuarantee.relation == SoCreditRequestGuarantee.RELATION_SELF){
            isSameGuarantee = true;
          }

          fetchSoCreditRequestAssets(soCreditRequestGuarantee.id);

          title = SoCreditRequestGuarantee.getLabelRol(soCreditRequestGuarantee.role);

          if(soCreditRequestGuarantee.relation != '') relation = soCreditRequestGuarantee.relation;
          textEconomicDepCntrll.text = soCreditRequestGuarantee.economicDependents.toString();
          textTypeHousingCntrll.text = soCreditRequestGuarantee.typeHousing;
          textYearsResidenceCntrll.text = soCreditRequestGuarantee.yearsResidence.toString();
          if(soCreditRequestGuarantee.role != '') role = soCreditRequestGuarantee.role;
          soCustomer = soCreditRequestGuarantee.soCustomer;
          fetchSoCustomerAddress(soCustomer.id).then((value) {

            if(soCustomer.curp != '' && _customerAddressListData.isNotEmpty){
              _activeStepIndex = 2;
            }else if(soCustomer.mobile != '' && soCustomer.email != '' ){
              _activeStepIndex=1;
            }else{
              _activeStepIndex = 0;
            }
            textFisrtNameCntrll.text = soCreditRequestGuarantee.soCustomer.firstName;
            textFatherLastNameCntrll.text = soCreditRequestGuarantee.soCustomer.fatherLastName;
            textMotherLastNameCntrll.text = soCreditRequestGuarantee.soCustomer.motherlastname;
            textBirthdateCntrll.text = soCreditRequestGuarantee.soCustomer.birthdate;
            textCellphoneCntrll.text = soCreditRequestGuarantee.soCustomer.mobile;
            textEmailCntrll.text = soCreditRequestGuarantee.soCustomer.email;
            textRfcCntrll.text = soCreditRequestGuarantee.soCustomer.rfc;
            textCurpCntrll.text = soCreditRequestGuarantee.soCustomer.curp;
            if(soCreditRequestGuarantee.soCustomer.maritalStatus != '') {
              setState((){
                maritalStatus = soCreditRequestGuarantee.soCustomer.maritalStatus;
              });
            }
            if(soCreditRequestGuarantee.soCustomer.maritalRegimen != '') regimenMarital = soCreditRequestGuarantee.soCustomer.maritalRegimen;
            if(soCreditRequestGuarantee.soCustomer.spouseName != '') textSpouseNameCntrll.text = soCreditRequestGuarantee.soCustomer.spouseName;
            if(soCreditRequestGuarantee.accountStatement > 0.0) textAccountStatementCntrll.updateValue(soCreditRequestGuarantee.accountStatement);
            if(soCreditRequestGuarantee.payrollReceipts > 0.0) textPayrollReceiptsCntrll.updateValue(soCreditRequestGuarantee.payrollReceipts);
            if(soCreditRequestGuarantee.typeHousing != '') textTypeHousingCntrll.text = soCreditRequestGuarantee.typeHousing;
            if(soCreditRequestGuarantee.heritage != '') textHeritageCntrll.text = soCreditRequestGuarantee.heritage;
            if(soCreditRequestGuarantee.economicDependents >= 0) {
              textEconomicDepCntrll.text = soCreditRequestGuarantee.economicDependents.toString();
            } else{
              textEconomicDepCntrll.text = '';
            }
            if(soCreditRequestGuarantee.employmentStatus != '') employmentStatus = soCreditRequestGuarantee.employmentStatus;
            if(soCreditRequestGuarantee.company != '') textCompanyCntrll.text = soCreditRequestGuarantee.company;
            if(soCreditRequestGuarantee.economicActivity != '' && soCreditRequestGuarantee.typeHousing != ''
                && soCreditRequestGuarantee.economicDependents >= 0){
              textEconomicActCntrll.text = soCreditRequestGuarantee.economicActivity;
              //si este dato existe es que ya va en el paso 3 de la forma
              _activeStepIndex = 3;
            }

            if(soCreditRequestGuarantee.yearsEmployment > 0)textYearsEmploymentCntrll.text = soCreditRequestGuarantee.yearsEmployment.toString();
            if(soCreditRequestGuarantee.creditCards > 0.0)textCreditCardsCntrll.updateValue(soCreditRequestGuarantee.creditCards);
            if(soCreditRequestGuarantee.rent > 0.0)textRentCntrll.updateValue(soCreditRequestGuarantee.rent);
            if(soCreditRequestGuarantee.creditAutomotive > 0.0)textCreditAutomotiveCntrll.updateValue(soCreditRequestGuarantee.creditAutomotive);
            if(soCreditRequestGuarantee.creditFurniture > 0.0)textCreditFurniturCntrll.updateValue(soCreditRequestGuarantee.creditFurniture);
            if(soCreditRequestGuarantee.personalLoans > 0.0)textPersonalLoansCntrll.updateValue(soCreditRequestGuarantee.personalLoans);
            if(soCreditRequestGuarantee.verifiableIncome > 0.0)textVerifiableIncomeCntrll.updateValue(soCreditRequestGuarantee.verifiableIncome);
            if(soCreditRequestGuarantee.ciec != '') textCiecCntrll.text = soCreditRequestGuarantee.ciec;

          });
          updateDataCrqg();
        });
      }else{
      maritalStatus = SoCreditRequestGuarantee.STATUS_SINGLE;
      regimenMarital = SoCreditRequestGuarantee.REGIMEN_CONJUGAL_SOCIETY;
      relation = SoCreditRequestGuarantee.RELATION_SELF;
      if(widget.requiredAcredited){
        role = SoCreditRequestGuarantee.ROLE_ACREDITED;
      }else{
        role = SoCreditRequestGuarantee.ROLE_COACREDITED;
      }
      soCreditRequestGuarantee.customerId = params.idLoggedUser;
      soCreditRequestGuarantee.creditRequestId = widget.creditRequestId;
    }
    super.initState();
  }

  //navbar bottom
  int _currentTabIndex = 0;
  //indicador de envio de datos
  bool sendingData = false;
  //addresses registradas
  late int custAddresses = 0;
//check para revisión buro de crédito
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {

    //lista de pasos para formularios
    List<Step> stepList()=> [
      stepOne(),
      stepOneOne(),
      stepTwo(),
      stepThree(),
      // stepEmploymentSituation(),
      if(widget.requiredAsset || _creditRequestAssetListData.isNotEmpty)
        stepFour(),
      if(!widget.requiredAsset && _creditRequestAssetListData.isEmpty)
        finalStep(),
    ];

    return Scaffold(
      appBar: AppBarStyle.authAppBarFlex(title: title,),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        progressIndicator: const CircularProgressIndicator(),
        child: AuthFormBackground(
          child: Stepper(
            steps: stepList(),
            type: StepperType.horizontal,
            currentStep: _activeStepIndex,
            onStepContinue: (){
             if(validStep(_activeStepIndex)) {
                  setState(() {
                    // _activeStepIndex += 1;
                  });
              }
            },
            onStepCancel: () {
              final isLastStep = _activeStepIndex == stepList().length - 1;
              if (_activeStepIndex == 0) {
                return;
              }
              //uncionalidad para guardar garantía y redireccionar
              if(isLastStep){
                Navigator.pop(context);
              }else{
                setState(() {
                  _activeStepIndex -= 1;
                });
              }
            },
            onStepTapped: (int index) {
              return;
              //Funcion para ir al step al dar click en el icono
              /*          setState(() {
                _activeStepIndex = index;
              });*/
            },
            controlsBuilder: (context, details){
              //valor del último paso
              final isLastStep = _activeStepIndex == stepList().length - 1;
              return Row(
                children: [
                  const SizedBox(height: 100,),
                  //Si es el último paso muestra Guardar en el texto del botón
                  if (_activeStepIndex > 0)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepCancel,
                        child:  (isLastStep)
                            ? const Text('Guardar')
                            : const Text('Atras'),
                      ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  if(!isLastStep)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: (_activeStepIndex == (stepList().length - 1))
                            ? const Text('Guardar')
                            : const Text('Siguiente'),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );

  }

  bool validStep (int step) {
    bool valid = false;
    switch (step){
      case 0:
          if (_formKeyOne.currentState!.validate()) {
            setState(() {
              sendingData = true;
            });
            addCust(context).then((value) {
              if (value) {
                setState(() {
                  _activeStepIndex += 1;
                  sendingData = false;
                });
              return true;
              } else {
                setState(() {
                  sendingData = false;
                });
                Fluttertoast.showToast(msg: msjResponsServer);
                return false;
              }
            });
          } else {
            Fluttertoast.showToast(msg: 'Favor de llenar todos los campos');
            return false;
          }
        break;
      case 1:
        if(_formKeyOneOne.currentState!.validate() && custAddresses>0){
          setState((){sendingData = true;});
          addCust(context).then((value) {
            if(value){
              updateCreditRequestGuarantee().then((value) {
                if (value) {
                  setState(() {
                    _activeStepIndex += 1;
                    sendingData = false;
                  });
                  return true;
                } else {
                  setState(() {
                    sendingData = false;
                  });
                  Fluttertoast.showToast(msg: msjError);
                  return false;
                }
              });
            }else{
              Fluttertoast.showToast(msg: msjResponsServer);
              return false;
            }
          });
          return false;
        }else{
          Fluttertoast.showToast(msg: 'Favor de llenar todos los campos y agregar'
              ' por lo menos una dirección');
          return false;
        }
        break;
      case 2:
        if(_formKeyTwo.currentState!.validate() ){
          setState(() { sendingData = true;});
          //Se guardan datos de solicitud de crédito
          updateCreditRequestGuarantee().then((value) {
            if(value){
              setState(() {
                _activeStepIndex += 1;
                sendingData = false;
              });
              return true;
            }else{
              setState(() {
                sendingData = false;
              });
              Fluttertoast.showToast(msg: msjError);
              return false;
            }
          });
          break;
        }else{
          Fluttertoast.showToast(msg: 'Favor de llenar todos los campos');
          setState(() {
            sendingData = false;
          });
          return false;
        }
      case 3:
        setState(() {
          sendingData = false;
          _activeStepIndex += 1;
        });
        return true;
    }
    return false;
  }

  Step stepOne(){
    return Step(
        state: _activeStepIndex <=0 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 0,
        title: const Text(""),
        content: CardStepContainer(
            child: Column(
              children: [
                  formunocero(),
              ],
            ),
        )
    );
  }

  Step stepOneOne(){
    return Step(
        state: _activeStepIndex <=1 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 1,
        title: const Text(""),
        content: CardStepContainer(
          child: Column(
            children: [
              formUnoUno(),
            ],
          ),
        )
    );
  }

  Widget formUnoUno(){
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKeyOneOne,
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                      child: Text(
                        "Relación con el solicitante*",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )),
                  DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: DropdownButton(
                        value: relation,
                        items: SoCreditRequestGuarantee.getRelationOptions
                            .map((e) {
                          return DropdownMenuItem(
                            child: Text(e['label']),
                            value: e['value'],
                          );
                        }).toList(),
                        onChanged: (Object? value) {
                          setState(() {
                            relation = '$value';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                // readOnly: isSameGuarantee,
                decoration: InputDecorations.authInputDecoration(
                    labelText: 'RFC con homoclave*',
                    prefixIcon: Icons.perm_identity_outlined),
                controller: textRfcCntrll,
                validator: (value) {
                  return (value != null && value.isNotEmpty && value.length > 12 && value.length < 14)
                      ? null
                      : 'Por favor ingrese un rfc válido';
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                // readOnly: isSameGuarantee,
                decoration: InputDecorations.authInputDecoration(
                    labelText: 'CURP*',
                    prefixIcon: Icons.perm_identity_outlined),
                controller: textCurpCntrll,
                validator: (value) {
                  return (value != null && value.isNotEmpty && value.length > 17 && value.length < 19)
                      ? null
                      : 'Por favor ingrese un curp válido';
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                      child: Text(
                        "Estado Civil*",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )),
                    DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        child: DropdownButton(
                          value: maritalStatus,
                          items: SoCustomer.getStatusOptions
                              .map((e) {
                            return DropdownMenuItem(
                              child: Text(e['label']),
                              value: e['value'],
                            );
                          }).toList(),
                          onChanged: (Object? value) {
                            setState(() {
                              maritalStatus = '$value';
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if(maritalStatus == SoCustomer.MARITALSTATUS_MARRIED)
                Row(
                  children: [
                    const Expanded(
                        child: Text(
                          "Régimen Conyugal*",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        )),
                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          child: DropdownButton(
                            value: regimenMarital,
                            items: SoCustomer.getRegimenOptions
                                .map((e) {
                              return DropdownMenuItem(
                                child: Text(e['label']),
                                value: e['value'],
                              );
                            }).toList(),
                            onChanged: (Object? value) {
                              setState(() {
                                regimenMarital = '$value';
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              if(maritalStatus == SoCustomer.MARITALSTATUS_MARRIED)
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Nombre Conyugue*',
                      prefixIcon: Icons.account_circle),
                  controller: textSpouseNameCntrll,
                  validator: (value) {
                    return (value != null && value.isNotEmpty)
                        ? null
                        : 'Por favor ingrese un nombre válido';
                  },
                ),
              const SizedBox(height: 10,),
              SubCatalogContainerWidget(
                  title: 'Domicilio(s)*',
                  child: CustomerAddress(
                    forceFilter: customerId,
                    callback: (int addresses){
                      setState(() {
                        custAddresses = addresses;
                      });
                    },
                  )
              ),
              const SizedBox(height: 10,),
              if(sendingData)
                const LinearProgressIndicator(),
            ],
          ),
        )
    );
  }

  Widget formunocero(){
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKeyOne,
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              TextFormField(
                readOnly: isSameGuarantee,
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textFisrtNameCntrll,
                decoration: InputDecorations.authInputDecoration(
                    labelText: "Nombre(s)*",
                    prefixIcon: Icons.account_circle_outlined),
                validator: (value) {
                  String? valnom = value;
                  while(valnom!.endsWith(' ')){
                    valnom = valnom!.replaceRange(valnom.length-1, null, '');
                    value = valnom;
                  }
                  return (value != null && value!.isNotEmpty)
                      ? null
                      : 'Por favor ingrese un nombre válido';
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                readOnly: isSameGuarantee,
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textFatherLastNameCntrll,
                decoration: InputDecorations.authInputDecoration(
                    labelText: "Apellido Paterno*",
                    prefixIcon: Icons.account_circle_outlined),
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese un apellido válido';
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                readOnly: isSameGuarantee,
                autocorrect: false,
                keyboardType: TextInputType.name,
                controller: textMotherLastNameCntrll,
                decoration: InputDecorations.authInputDecoration(
                    labelText: "Apellido Materno*",
                    prefixIcon: Icons.account_circle_outlined),
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese un apellido válido';
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Seleccione una Fecha",
                    labelText: "Fecha de Nacimiento*",
                    prefixIcon: Icons.calendar_today_outlined),
                controller: textBirthdateCntrll,
                readOnly: true,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese una fecha válida';
                },
                onTap: () {
                  if(!isSameGuarantee){
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
                        textBirthdateCntrll.text = date;
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                readOnly: isSameGuarantee,
                autocorrect: false,
                keyboardType: TextInputType.phone,
                controller: textCellphoneCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Tel. Celular',
                    labelText: 'Tel. Celular*',
                    prefixIcon: Icons.phone_iphone_outlined),
                validator: (value) {
                  final intNumber = int.tryParse(value!.replaceAll('-', ''));
                  return (intNumber != null && value.length > 9)
                      ? null
                      : 'Por favor ingrese un número de teléfono válido';
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                readOnly: isSameGuarantee,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                controller: textEmailCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'tucorreo@gmail.com',
                    labelText: 'Correo electrónico*',
                    prefixIcon: Icons.alternate_email_rounded),
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingresado no luce como un correo';
                },
              ),
              const SizedBox(height: 10,),
              if(sendingData)
                const LinearProgressIndicator(),
            ],
          ),
        )
    );
  }

  Step stepTwo(){
    return Step(
        state: _activeStepIndex <= 2 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 2,
        title: const Text(""),
        content: CardStepContainer(
            child:  Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKeyTwo,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  if(whoProccess || soCreditRequestGuarantee.creditBureau > 0
                      || soCreditRequestGuarantee.customerId == params.idLoggedUser)
                  Row(
                    children: [
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          print('quien procesa --- $whoProccess');
                          if(whoProccess || soCreditRequestGuarantee.customerId == params.idLoggedUser) {
                            if (!isSwitched ) {
                              _confirmPassword();
                            }
                            // setState(() {
                            //   isSwitched = value;
                            // });
                          }
                        },
                      ),
                      const Expanded(
                          child: Text("Confirmación de autorización para revisar "
                              "buro de credito",
                            style: TextStyle(color: Colors.grey),
                          )
                      ),
                    ],
                  ),
                  if(!whoProccess && soCreditRequestGuarantee.role == SoCreditRequestGuarantee.ROLE_ACREDITED
                      && soCreditRequestGuarantee.customerId != params.idLoggedUser)
                    const Row(
                      children: [
                        Expanded(
                            child: Text("Favor de revisar su correo, se envió una solicitud para su autorización de revisión en buro de crédito",
                              style: TextStyle(color: Colors.grey),
                            )
                        ),
                      ],
                    ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Dependientes Económicos*',
                        prefixIcon: Icons.business_sharp),
                    controller: textEconomicDepCntrll,
                    validator: ( value ) {
                      final intNumber = int.tryParse(value!);
                      return (intNumber != null && intNumber >= 0)
                          ? null
                          : 'Por favor ingrese un número válido';
                    },
                  ),
                /*  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Ingresos Comprobables*',
                        prefixIcon: Icons.monetization_on_outlined),
                    controller: textVerifiableIncomeCntrll,
                    validator: ( value ) {
                      final intNumber = double.tryParse(value!.replaceAll(',', ''));
                      return (intNumber != null && intNumber > 0)
                          ? null
                          : 'Por favor ingrese un valor';
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Estados de Cuenta',
                        prefixIcon: Icons.monetization_on_outlined),
                    controller: textAccountStatementCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un valor';
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Recibos de Nómina',
                        prefixIcon: Icons.monetization_on_outlined),
                    controller: textPayrollReceiptsCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un valor';
                    },
                  ),*/
                  //TODO: Cambiar tipo de los siguientes 2 campos
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Tipo de Vivienda*',
                        prefixIcon: Icons.business_sharp),
                    controller: textTypeHousingCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un valor';
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Patrimonio a tu nombre*',
                        prefixIcon: Icons.business_sharp),
                    controller: textHeritageCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un valor';
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Ingresos Comprobables',
                        prefixIcon: Icons.monetization_on_outlined),
                    controller: textVerifiableIncomeCntrll,
                    validator: ( value ) {
                      final intNumber = double.tryParse(value!.replaceAll(',', ''));
                      return (intNumber != null && intNumber >= 0)
                          ? null
                          : 'Por favor ingrese un valor';
                    },
                  ),
                  const SizedBox(height: 10,),
                  const Text("Datos empleo:"),
                  Row(
                    children: [
                      const SizedBox(height: 10,),
                      const Expanded(
                          child: Text("Estatus Laboral*",
                            style: TextStyle(color: Colors.grey,fontSize: 15),
                          )
                      ),
                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          child: DropdownButton(
                            value: employmentStatus,
                            items: SoCreditRequest.getEmploymentStatus.map((e) {
                              return DropdownMenuItem(
                                child: Text(e['label']),
                                value: e['value'],
                              );
                            }).toList(),
                            onChanged: (Object? value) {
                              setState(() {
                                employmentStatus = '$value';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Nombre de la empresa*',
                        prefixIcon: Icons.business_sharp),
                    controller: textCompanyCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese nombre de la empresa';
                    },
                  ),
                  const SizedBox(height: 10, ),
                  TextFormField(
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Giro/Actividad económica*',
                        prefixIcon: Icons.account_balance_wallet_outlined),
                    controller: textEconomicActCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor indique el giro/actividad de la empresa';
                    },
                  ),
                  const SizedBox( height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Antigüedad*',
                        prefixIcon: Icons.timer_outlined),
                    controller: textYearsEmploymentCntrll,
                    validator: ( value ) {
                      final intNumber = int.tryParse(value!);
                      return (intNumber != null && value.length > 0)
                          ? null
                          : 'Por favor ingrese un número válido';
                    },
                  ),
                  //TODO: Agregar campos nuevos - puesto, dirección empresa, profesión
                  const SizedBox(height: 10,),
                  const Text("Gastos Promedio Mensuales"),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Tarjetas de crédito',
                        prefixIcon: Icons.money_off_outlined),
                    controller: textCreditCardsCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un número válido';
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                          labelText: 'Renta o crédito hipotcario',
                          prefixIcon: Icons.money_off_outlined),
                      controller: textRentCntrll,
                      validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese un número válido';
                      }
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Crédito automotríz',
                        prefixIcon: Icons.money_off_outlined),
                    controller: textCreditAutomotiveCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un número válido';
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Crédito de muebles o línea blanca',
                        prefixIcon: Icons.money_off_outlined),
                    controller: textCreditFurniturCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un número válido';
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Préstamos personales',
                        prefixIcon: Icons.money_off_outlined),
                    controller: textPersonalLoansCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un número válido';
                    },
                  ),
                  if(sendingData)
                    const LinearProgressIndicator(),
                /*  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKeyTwo.currentState!.validate()){
                          income = false;
                          employment= false;
                          expenses = false;
                          updateCreditRequestGuarantee().then((value) {
                            if(value){
                              // Error al guardar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Registro actualizado con éxito.')),
                              );
                            }else{
                              // Error al guardar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al Guardar')),
                              );
                            }
                          });
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
                  ),*/
                ],
              ),
            ),
        )
    );
  }

  //Funcion para validad contraseña
  Future<void> _confirmPassword() async{
    final textPassCntrll = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirme su Contraseña \n*contraseña con la que ingresó a la aplicación'),
            content: TextField(
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Contraseña'
              ),
              controller: textPassCntrll,
            ),
            actions: <Widget>[
              TextButton(
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
                      const SnackBar(content: Text('Contraseña Incorrecta')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Confirmar'),
              )
            ],
          );
        }
    );
  }

  //Funcion para validad contraseña
  Future<void> _emailMsg() async{
    final textPassCntrll = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Se enviará un correo electrónico a ${soCustomer.email} para validar la autorización'),
            /*content: TextField(
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Contraseña'
              ),
              controller: textPassCntrll,
            ),*/
            actions: <Widget>[
              TextButton(
                onPressed: (){
                  setState(() {
                    isSwitched = false;
                    Navigator.pop(context);
                  });
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: (){
                    setState(() {
                      isSwitched = true;
                      Navigator.pop(context);
                    });
                },
                child: const Text('Confirmar'),
              )
            ],
          );
        }
    );
  }

  Step stepThree(){
    return Step(
        state: _activeStepIndex <= 3 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 3,
        title: const Text(""),
        content: CardStepContainer(
            child: Form(
                child:Column(
                  children: [
                    UploadIdPhoto(
                      key: _keyUploadIdentification,
                      initialRuta: soCreditRequestGuarantee.identification,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_identification',
                      label: 'Identificación parte frontal',
                      id: creditRequestGuaranteeId.toString(),
                      callBack: (bool isLoading) {
                        setState(() {
                          _isInAsyncCall = isLoading;
                        });
                        updateDataCrqg();
                      },
                      idGuarantee: soCreditRequestGuarantee.id.toString(),),
                    UploadIdPhoto(
                      key: _keyUploadIdentificationBack,
                      initialRuta: soCreditRequestGuarantee.identificationBack,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_identificationback',
                      label: 'Identificación parte trasera',
                      id: creditRequestGuaranteeId.toString(),
                      callBack: (bool isLoading) {
                        setState(() {
                          _isInAsyncCall = isLoading;
                        });
                        updateDataCrqg();
                      },
                      idGuarantee: soCreditRequestGuarantee.id.toString(),),
                    UploadFile(
                      key: _keyUploadProofIncome,
                      initialRuta: soCreditRequestGuarantee.proofIncome,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_proofincome',
                      label: 'Comprobante de Ingresos',
                      id: creditRequestGuaranteeId.toString(),
                      callBack: (bool isLoading) {
                        setState(() {
                          _isInAsyncCall = isLoading;
                        });
                        updateDataCrqg();
                      },
                      idGuarantee: '',),
                    UploadFile(
                      key: _keyUploadFiscalSituation,
                      initialRuta: soCreditRequestGuarantee.fiscalSituation,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_fiscalsituation',
                      label: 'Constancia de Situación Fiscal',
                      id: creditRequestGuaranteeId.toString(),
                      callBack: (bool isLoading) {
                        setState(() {
                          _isInAsyncCall = isLoading;
                        });
                        updateDataCrqg();
                      },
                      idGuarantee: '',),
                    UploadFile(
                      key: _keyUploadVerifiableIncome,
                      initialRuta: soCreditRequestGuarantee.verifiableIncomeFile,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_verifiableincomefile',
                      label: 'Otros Ingresos Comprobables',
                      id: creditRequestGuaranteeId.toString(),
                      callBack: (bool isLoading) {
                        setState(() {
                          _isInAsyncCall = isLoading;
                        });
                        updateDataCrqg();
                      },
                      idGuarantee: '',
                    ),
                    UploadFile(
                      key: _keyUploadDeclaratory,
                      initialRuta: soCreditRequestGuarantee.declaratory,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_declaratory',
                      label: 'Declaratorias',
                      id: creditRequestGuaranteeId.toString(),
                      callBack: (bool isLoading) {
                        setState(() {
                          _isInAsyncCall = isLoading;
                        });
                        updateDataCrqg();
                      },
                      idGuarantee: '',),
                    UploadFile(
                      key: _keyUploadProofAddress,
                      initialRuta: soCreditRequestGuarantee.proofAddress,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_proofaddress',
                      label: 'Comprobante de Domicilio',
                      id: creditRequestGuaranteeId.toString(),
                      callBack: (bool isLoading) {
                        setState(() {
                          _isInAsyncCall = isLoading;
                        });
                        updateDataCrqg();
                      },
                      idGuarantee: '',),
                    UploadFile(
                      key: _keyUploadIdentityVideo,
                      initialRuta: soCreditRequestGuarantee.identityVideo,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_identityvideo',
                      label: 'Video de Identidad',
                      id: creditRequestGuaranteeId.toString(),
                      callBack: (bool isLoading) {
                        setState(() {
                          _isInAsyncCall = isLoading;
                        });
                        updateDataCrqg();
                      },
                      idGuarantee: soCreditRequestGuarantee.id.toString(),),
                    const SizedBox(width: 10,),
                  ],
                )
            ),
        )
    );
  }

  Step stepFour(){
    return Step(
        state: _activeStepIndex <=4 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 4,
        title: const Text(""),
        content: SizedBox(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: getFormAsset(),
            )
        )
    );
  }

  Widget getFormAsset(){
    if(soCreditRequestGuarantee.id > 0){
      return CreditRequestAsset(
          soCreditRequestGuarantee: soCreditRequestGuarantee);
    }
    return const Text('');
  }

  Step finalStep() {
    return Step(
        state: _activeStepIndex <=4 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 4,
        title: const Text(""),
        content: const CardStepContainer(
          child: Text('Se han guardado sus datos correctamente'),
        )
    );
  }

  updateDataCRQA(){
    /*fetchCrqa(soCreditRequestAsset.id.toString()).then((value) {
      _keyUploadPhoto.currentState?.updateData(soCreditRequestAsset.photo);
      _keyUploadPhoto.currentState?.updateId(soCreditRequestAsset.id.toString());

    });*/

  }

  Widget formInmueble(){
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKeyInmueble,
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textFolioCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Folio",
                    labelText: "Folio*",
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
                    labelText: "Cta. Catastral*",
                    prefixIcon: Icons.numbers_outlined
                ),
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese Cta. Catastral.';
                },
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
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: textInvoiceCntrll,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Número de Factura",
                    labelText: "Número de Factura*",
                    prefixIcon: Icons.numbers_outlined
                ),
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese número de factura';
                },
                // onChanged: ( value ) => newCustForm.firstName = value,
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
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
                keyboardType: TextInputType.number,
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
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese el año';

                },
              ),
            ],
          ),
        )
    );
  }

  Widget noSponsor(){
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 150),
        child: Text('Complete los datos iniciales del aval.'),
      ),
    );
  }

  //funcion para actualizar widget hijo mediante el callback (uploadfile)
  updateDataCrqg(){
    print('updatedatacrqg -----');
    //indicamos que se esta realizando el proceso de subir archivo
    //Se ejecuta el metodo de consulta para actualizar los datos del aval.
    fetchCrqg(creditRequestGuaranteeId.toString()).then((value) {
      _keyUploadIdentification.currentState?.updateData(soCreditRequestGuarantee.identification);
      _keyUploadIdentificationBack.currentState?.updateData(soCreditRequestGuarantee.identificationBack);
      _keyUploadProofIncome.currentState?.updateData(soCreditRequestGuarantee.proofIncome);
      _keyUploadFiscalSituation.currentState?.updateData(soCreditRequestGuarantee.fiscalSituation);
      _keyUploadVerifiableIncome.currentState?.updateData(soCreditRequestGuarantee.verifiableIncomeFile);
      _keyUploadDeclaratory.currentState?.updateData(soCreditRequestGuarantee.declaratory);
      _keyUploadProofAddress.currentState?.updateData(soCreditRequestGuarantee.proofAddress);
      _keyUploadIdentityVideo.currentState?.updateData(soCreditRequestGuarantee.identityVideo);
      avalCreated = true;

      //Se ejecuta el metodo de consulta para actualizar el id del aval.
      _keyUploadIdentification.currentState?.updateId(soCreditRequestGuarantee.id.toString());
      _keyUploadIdentificationBack.currentState?.updateId(soCreditRequestGuarantee.id.toString());
      _keyUploadProofIncome.currentState?.updateId(soCreditRequestGuarantee.id.toString());
      _keyUploadFiscalSituation.currentState?.updateId(soCreditRequestGuarantee.id.toString());
      _keyUploadVerifiableIncome.currentState?.updateId(soCreditRequestGuarantee.id.toString());
      _keyUploadDeclaratory.currentState?.updateId(soCreditRequestGuarantee.id.toString());
      _keyUploadProofAddress.currentState?.updateId(soCreditRequestGuarantee.id.toString());
      _keyUploadIdentityVideo.currentState?.updateId(soCreditRequestGuarantee.id.toString());
    });
  }

  Widget formDatosGenerales(){
    return SingleChildScrollView(
      child: Column(
        children: const [
          SizedBox(height: 40,),
          CardContainer(
            child: Text(''),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }

  // Actualiza el wflowstep en el servidor
  Future<bool> addCust(BuildContext context) async {
    soCustomer.firstName = textFisrtNameCntrll.text;
    soCustomer.fatherLastName = textFatherLastNameCntrll.text;
    soCustomer.motherlastname = textMotherLastNameCntrll.text;
    soCustomer.birthdate = textBirthdateCntrll.text;
    soCustomer.mobile = textCellphoneCntrll.text;
    soCustomer.email = textEmailCntrll.text;
    soCustomer.rfc = textRfcCntrll.text;
    soCustomer.curp = textCurpCntrll.text;
    soCustomer.maritalStatus = maritalStatus;
    if(maritalStatus == SoCustomer.MARITALSTATUS_MARRIED){
      soCustomer.maritalRegimen = regimenMarital;
      soCustomer.spouseName = textSpouseNameCntrll.text;
    }else{
      soCustomer.maritalRegimen = '';
      soCustomer.spouseName = '';
    }
    soCustomer.recommendedBy = params.idLoggedUser;
    soCustomer.customerType = SoCustomer.TYPE_PERSON;
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
      if(soCustomer.id>0){
        msjResponsServer = 'Registro actualizado con éxito.';
      }else{
        msjResponsServer = 'Nuevo aval registrado.';
      }
      setState(() {
        soCustomer = SoCustomer.fromJson(jsonDecode(response.body));
        customerId = soCustomer.id;
      });
      // Muestra mensaje

      return true;
    } else {
      setState(() {
        sendingData = false;
      });
      // Muestra mensaje
      print(response.body.toString());
      msjResponsServer = response.body.toString();
      return false;
    }
  }

  Future<bool> updateCreditRequestGuarantee() async {

    soCreditRequestGuarantee.customerId = soCustomer.id;
    soCustomer.firstName = textFisrtNameCntrll.text;
    soCustomer.fatherLastName = textFatherLastNameCntrll.text;
    soCustomer.motherlastname = textMotherLastNameCntrll.text;
    soCustomer.birthdate = textBirthdateCntrll.text;
    soCustomer.mobile = textCellphoneCntrll.text;
    soCustomer.email = textEmailCntrll.text;
    soCustomer.rfc = textRfcCntrll.text;
    soCustomer.curp = textCurpCntrll.text;
    soCustomer.maritalStatus = maritalStatus;
    if(maritalStatus == SoCustomer.MARITALSTATUS_MARRIED){
      soCustomer.maritalRegimen = regimenMarital;
      soCustomer.spouseName = textSpouseNameCntrll.text;
    }else{
      soCustomer.maritalRegimen = '';
      soCustomer.spouseName = '';
    }
    soCreditRequestGuarantee.soCustomer = soCustomer;
    soCreditRequestGuarantee.creditRequestId = widget.creditRequestId;
    soCreditRequestGuarantee.role = role;
    if(textEconomicDepCntrll.text != '') soCreditRequestGuarantee.economicDependents = int.parse(textEconomicDepCntrll.text);
    soCreditRequestGuarantee.typeHousing = textTypeHousingCntrll.text;
    if (textYearsResidenceCntrll.text != '') soCreditRequestGuarantee.yearsResidence = int.parse(textYearsResidenceCntrll.text);
    soCreditRequestGuarantee.relation = relation;

    //datos guarantee
    soCreditRequestGuarantee.ciec = textCiecCntrll.text;
    soCreditRequestGuarantee.verifiableIncome = textVerifiableIncomeCntrll.numberValue;
    soCreditRequestGuarantee.accountStatement = textAccountStatementCntrll.numberValue;
    soCreditRequestGuarantee.payrollReceipts = textPayrollReceiptsCntrll.numberValue;
    soCreditRequestGuarantee.heritage = textHeritageCntrll.text;
    soCreditRequestGuarantee.employmentStatus = employmentStatus;
    soCreditRequestGuarantee.company = textCompanyCntrll.text;
    soCreditRequestGuarantee.economicActivity = textEconomicActCntrll.text;
    if(textYearsEmploymentCntrll.text != '')soCreditRequestGuarantee.yearsEmployment = int.parse(textYearsEmploymentCntrll.text);
    soCreditRequestGuarantee.creditCards = textCreditCardsCntrll.numberValue;
    soCreditRequestGuarantee.rent = textRentCntrll.numberValue;
    soCreditRequestGuarantee.creditAutomotive = textCreditAutomotiveCntrll.numberValue;
    soCreditRequestGuarantee.creditFurniture = textCreditFurniturCntrll.numberValue;
    soCreditRequestGuarantee.personalLoans = textPersonalLoansCntrll.numberValue;
    soCreditRequestGuarantee.typeHousing = textTypeHousingCntrll.text;
    if(isSwitched){
      soCreditRequestGuarantee.creditBureau = 1;
    }else{
      soCreditRequestGuarantee.creditBureau = 0;
    }

    if(role == SoCreditRequestGuarantee.ROLE_ACREDITED && !whoProccess
        && !isSwitched && soCreditRequestGuarantee.customerId != params.idLoggedUser){
      soCreditRequestGuarantee.sendMailBureau = 1;
    }else{
      soCreditRequestGuarantee.sendMailBureau = 0;
    }

    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcrqg;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCreditRequestGuarantee),
    );

    if (response.statusCode == params.servletResponseScOk) {
      if(soCustomer.id>0){
        msjResponsServer = 'Registro actualizado con éxito.';
      }else{
        msjResponsServer = ' Nuevo aval asignado con éxito.';
      }
      setState((){
        avalCreated = true;
        soCreditRequestGuarantee = SoCreditRequestGuarantee.fromJson(jsonDecode(response.body));
        if(soCreditRequestGuarantee.creditBureau > 0){
          isSwitched = true;
        }
        creditRequestGuaranteeId = soCreditRequestGuarantee.id;
      });
      if(soCreditRequestGuarantee.creditBureau < 1 && !whoProccess && soCreditRequestGuarantee.customerId != params.idLoggedUser){
        showAlertDialogSendMail(context, "Favor de revisar su correo, se envió una solicitud para su autorización de revisión en buro de crédito");
      }
      // Muestra mensaje
/*      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado')),
      );*/
      return true;
    } else {
      print(response.body.toString());
      msjError = response.body.toString();
      // Error al guardar
/*      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al Guardar')),
      );*/
      return false;
    }
  }

  showAlertDialogSendMail(BuildContext context, String text) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(text),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) => Navigator.pop(context));
  }

  //Peticon de datos de un cliente especifico
  Future<bool> fetchCrqg(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcrqg;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?id=' +
            id.toString()));
print('fetchcrqg $id');
    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      Navigator.pushNamed(context, AppRoutes.initialRoute);
    }

    setState((){
      soCreditRequestGuarantee = SoCreditRequestGuarantee.fromJson(jsonDecode(response.body));
    });
    return true;
  }

  //Consulta las garantias por solicitud
  Future<List<SoCreditRequestAsset>> fetchSoCreditRequestAssets(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcrqa;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        'ff' +
        '=' +
        forceFilter.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    _creditRequestAssetListData.addAll(
        parsed.map<SoCreditRequestAsset>((json) => SoCreditRequestAsset.fromJson(json)).toList());
    setState((){});
    return parsed
        .map<SoCreditRequestAsset>((json) => SoCreditRequestAsset.fromJson(json))
        .toList();
  }

  Future<List<SoCustAddres>> fetchSoCustomerAddress(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcuad;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        params.forceFilter +
        '=' +
        forceFilter.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    _customerAddressListData.addAll(
        parsed.map<SoCustAddres>((json) => SoCustAddres.fromJson(json)).toList());
    setState((){});
    return parsed
        .map<SoCustAddres>((json) => SoCustAddres.fromJson(json))
        .toList();
  }

}


import 'dart:convert';

import 'package:flexwm/main.dart';
import 'package:flexwm/models/crqd.dart';
import 'package:flexwm/models/crqg.dart';
import 'package:flexwm/models/crqs.dart';
import 'package:flexwm/routes/routes.dart';
import 'package:flexwm/screens/chat_prueba.dart';
import 'package:flexwm/screens/crqg_form.dart';
import 'package:flexwm/screens/crqg_screen.dart';
import 'package:flexwm/screens/crqs_list.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flexwm/widgets/auth_listbackground.dart';
import 'package:flexwm/widgets/sub_catalog_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'package:flexwm/ui/input_decorations.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../routes/app_routes.dart';
import '../widgets/card_stepcontainer.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/upload_file_widget.dart';
import '../widgets/upload_id_photo_widget.dart';
import 'cust_crqs_form.dart';
import 'info_cqrs_screen.dart';


class CustDataForm extends StatefulWidget {
  final SoCreditRequest creditRequest;
  const CustDataForm({Key? key, required this.creditRequest,}) : super(key: key);

  @override
  _CustDataFormState createState() => _CustDataFormState();

}

class _CustDataFormState extends State<CustDataForm>{
  late int creditRequestId = 0;
  //objeto para los datos de la solicitud del credito
  SoCreditRequest soCreditRequest = SoCreditRequest.empty();
  //objeto para los datos de detalle solicitud de crédito
  SoCreditRequestDetail soCreditRequestDetail = SoCreditRequestDetail.empty();
  //objeto para los datis de perfil de crédito
  SoCreditRequestGuarantee soCreditRequestGuarantee = SoCreditRequestGuarantee.empty();
  //Indice indicador de paso activo
  int _activeStepIndex = 0;

  //controllers campos step2
  final textMontoCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  late int creditDestiny = 0;
  int monthSelected = 0;
  int deadLine = 0;
  final textPagoMonthCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  int creditTypeId = 0;
  //controllers campos step 3
  final textEducationalInstitutionCntrll = TextEditingController();
  late String institutionType = '';
  final textDateStartCntrll = TextEditingController();
  final textDateEndCntrll = TextEditingController();
  final textInstitutionCntrll = TextEditingController();
  final textLocationCntrll = TextEditingController();
  final textPeriodCntrll = TextEditingController();
  final textDegreeCntrll = TextEditingController();

  //controllers step perfil crediticio
  // int verifiableIncome = 0;
  late String rolePreliminar = '';
  late String relation = '';

  //controllers financiamiento en el extranjero
   bool visaFees = false;
   bool planeTickets = false;
  final textProgramCostCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textMaintenanceCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textStudiesPlaceCntrll = TextEditingController();
  late int engagementAgencyId = -1;
  late int countryId = -1;
  final textCityCntrll = TextEditingController();
  final textEngagementSchollCntrll = TextEditingController();
  final textDateProbablyTravelCntrll = TextEditingController();
  final textEducationalProgramCntrll = TextEditingController();
  final textVerifiableIncomeCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  //keys para validaciones de formularios en cada paso
  final _formKeyCrqs = GlobalKey<FormState>();
  final _formKeyCrqs2 = GlobalKey<FormState>();
  final _formKeyCude = GlobalKey<FormState>();
  // final _formKeyStep4 = GlobalKey<FormState>();
  final _formKeyCreditProfile = GlobalKey<FormState>();
  final _formKeyCrqd = GlobalKey<FormState>();

  late int idCustomer = 0;
  //Valor del checkbox buro de crédito

  //Objeto de tipo cliente para validación
  SoCustomer soCustomer = SoCustomer.empty();

  //navbar bottom
  int _currentTabIndex = 0;
  //titulo en appbar dependiendo el tab
  String titleCrqs = 'Solicitud de Crédito';
  String titleCrqg = 'Avales Solicitud';
  String titleCrqd = 'Detalles Solicitud de Crédito';
  //Progresindicator envio de datos
  bool sendingData = false;
  //errores de solicitud
  String errorMsg = '';
  //id de flujo
  int wflowId = 0;
  //id detalles de solicitud
  int creditRequestDetailId = 0;
  // Regimen Fiscal
  String fiscalRegime = SoCreditRequest.FISCALREGIME_PERSON;
  //Validaciones plan de credito
  int _periods = 0;
  double _minAmount = 0.0;
  double _maxAmount = 0.0;
  int _periodsMin = 0;
  int _periodsMax = 0;
  bool _validPeriods = false;
//check para revisión buro de crédito
  bool isSwitched = false;
  //codigo solicitud
  String codeCrqs = '';
  //paso en el que se encuentra la solicitud
  int stepRealized = 0;
  // mensaje recibidos
  bool messages = false;

  @override
  void initState(){
    //Se obtiene el cliente que se encuentra loggeado
    idCustomer = params.idLoggedUser;
    fetchCustomer(idCustomer.toString()).then((value) {
      if(soCustomer.curp.isEmpty || soCustomer.rfc.isEmpty){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustCrqsForm()),
        ).then((value) => Navigator.push(context, MaterialPageRoute(
            builder: (context) => const CreditRequestList()
        )));
      }
    });
    super.initState();
    institutionType = SoCreditRequestDetail.INSTITUTION_TYPE_NATIONAL;
    //Se inicializa step 2 y 4
    if(widget.creditRequest.id > 0){

      getData();

      soCreditRequest = widget.creditRequest;
      if(soCreditRequest.soWFlow.userMsgs){
        setState(() {
          messages = true;
        });
      }

      if(soCreditRequest.creditBureau > 0 && soCreditRequest.creditMotiveId > 0){
        setState(() {
          _activeStepIndex = 1;
          stepRealized = 1;
        });
      }

      codeCrqs = soCreditRequest.code;
      fiscalRegime = soCreditRequest.fiscalRegime;
      if(soCreditRequest.creditMotiveId > 0){
        creditDestiny = soCreditRequest.creditMotiveId;
      }
      creditTypeId = soCreditRequest.creditTypeId;
      textMontoCntrll.updateValue(soCreditRequest.amountRequired);
      deadLine = soCreditRequest.deadlineRequired;
      textPagoMonthCntrll.updateValue(soCreditRequest.monthlyPayment);

      if(soCreditRequest.creditBureau == 1) isSwitched = true;

      fetchCreditRequestDetail(soCreditRequest.id.toString()).then((value) {
        if(value){
          if(soCreditRequest.status != SoCreditRequest.STATUS_EDITION){
            if(soCreditRequestDetail.educationalInstitutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL){
                _currentTabIndex = 4;
            }else{
              _currentTabIndex =3;
            }
          }

            if(soCreditRequestDetail.educationalInstitution != '' &&
                soCreditRequestDetail.educationalInstitutionType != '' &&
                soCreditRequestDetail.dateStartInstitution != '' &&
                soCreditRequestDetail.dateEndInstitution != ''){
              if(soCreditRequest.creditBureau > 0){
                if( soCreditRequestDetail.institution != '' &&
                    soCreditRequestDetail.location != '' &&
                    soCreditRequestDetail.degreeObtained != '' &&
                    stepRealized >=1){
                  setState(() {
                    _activeStepIndex = 3;
                    stepRealized = 3;
                  });
                  if(soCreditRequestDetail.educationalInstitutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL){
                    setState(() {
                      institutionType = soCreditRequestDetail.educationalInstitutionType;
                      _currentTabIndex = 4;
                    });
                  }else{
                    setState((){
                      _currentTabIndex = 3;
                    });
                  }
                }else{
                  setState(() {
                    _activeStepIndex = 2;
                    stepRealized = 2;
                  });
                }
              }else{
                setState(() {
                  _activeStepIndex = 0;
                  stepRealized = 0;
                });
               Fluttertoast.showToast(msg: 'Favor de confirmar buro de crédito.');
              }

              textInstitutionCntrll.text = soCreditRequestDetail.institution;
              textLocationCntrll.text = soCreditRequestDetail.location;
              textPeriodCntrll.text = soCreditRequestDetail.period.toString();
              textDegreeCntrll.text = soCreditRequestDetail.degreeObtained;
            }
            if(soCreditRequestDetail.educationalInstitution != '' ) textEducationalInstitutionCntrll.text = soCreditRequestDetail.educationalInstitution;
            if(soCreditRequestDetail.educationalInstitutionType != '' ) institutionType = soCreditRequestDetail.educationalInstitutionType;
            if(soCreditRequestDetail.dateStartInstitution != '' ) textDateStartCntrll.text = soCreditRequestDetail.dateStartInstitution.replaceAll(' 00:00', '');
            if(soCreditRequestDetail.dateEndInstitution != '' ) textDateEndCntrll.text = soCreditRequestDetail.dateEndInstitution.replaceAll(' 00:00', '');
            setState((){creditRequestDetailId = soCreditRequestDetail.id;});
            // updateDataCrqs();
            if(soCreditRequestDetail.visaFees > 0 ) visaFees = true;
            if(soCreditRequestDetail.planeTickets > 0 ) planeTickets = true;
            if(soCreditRequestDetail.programCost > 0.0 ) textProgramCostCntrll.updateValue(soCreditRequestDetail.programCost);
            if(soCreditRequestDetail.maintenance > 0.0 ) textMaintenanceCntrll.updateValue(soCreditRequestDetail.maintenance);
            textStudiesPlaceCntrll.text = soCreditRequestDetail.studiesPlace;
            if(soCreditRequestDetail.engagementAgencyId > 0) engagementAgencyId = soCreditRequestDetail.engagementAgencyId;
            textEngagementSchollCntrll.text = soCreditRequestDetail.engagementSchool;
            textDateProbablyTravelCntrll.text = soCreditRequestDetail.dateProbablyTravel;
            textEducationalProgramCntrll.text = soCreditRequestDetail.educationalProgram;
            countryId = soCreditRequestDetail.countryId;
            textCityCntrll.text = soCreditRequestDetail.city;
        }
      });
      //step 3
      rolePreliminar = SoCreditRequestGuarantee.ROLE_ACREDITED;
      relation = SoCreditRequestGuarantee.RELATION_SELF;
    }else{
      creditDestiny = 0;
      rolePreliminar = SoCreditRequestGuarantee.ROLE_ACREDITED;
      relation = SoCreditRequestGuarantee.RELATION_SELF;
    }
  }
  @override
  Widget build(BuildContext context) {
    //lista de pasos para formularios
    List<Step> stepList()=> [
      stepCreditRequest(),
      stepCreditRequestDetail(),
      stepMoreDataCust(),
      // stepEmploymentSituation(),
      finalStep(),
    ];
    //lista de widgets para selección de body dependiendo tab seleccionado
    final _crqsTabPages = <Widget>[
      formCreditRequest(stepList()),
      if(institutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL)
      AuthListBackground(child: formCrqd()),
      AuthListBackground(child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: CreditRequestGuarantee(forceFilter: soCreditRequest.id, requiredAsset: false,whoProccess: 0,),
      )),
      AuthListBackground(child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: ChatPrueba(forceFilter: wflowId),
      ),),
      AuthListBackground(child: CreditRequestInfoScreen(soCreditRequest: soCreditRequest,
        step: stepRealized, requiredAsset: true, requiredGuarantees: 0,)
      ),
    ];

    //Iconos para barra de navegación inferior
    final _crqsBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_sharp), label: 'Solicitud'),
      if(institutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL)
        const BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active), label: 'Detalles'),
      const BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Avales'),
      BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.chat),
              if(messages)
              const Positioned(  // draw a red marble
                top: 0.0,
                right: 0.0,
                child: Icon(Icons.brightness_1, size: 12.0,
                    color: Colors.redAccent),
              ),
            ],
          ),
          // Icon(Icons.chat),
          label: 'Chat'),
      const BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Info'),
    ];

    updateCrqsInfo(){

    }
    //Bottom navigation bar
    final bottomNavBar = BottomNavigationBar(
      items: _crqsBottmonNavBarItems,
      unselectedItemColor: Colors.grey,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if(soCreditRequest.id > 0){
          if(soCreditRequest.status == SoCreditRequest.STATUS_EDITION){
            setState(() {
              creditRequestDetailId = soCreditRequestDetail.id;
              wflowId = soCreditRequest.wFlowId;
              _currentTabIndex = index;
            });
          }else{
            if(index == _crqsBottmonNavBarItems.length-2 ||
                index == _crqsBottmonNavBarItems.length-1){
              setState(() {
                creditRequestDetailId = soCreditRequestDetail.id;
                wflowId = soCreditRequest.wFlowId;
                _currentTabIndex = index;
              });
              if(index == _crqsBottmonNavBarItems.length-2){
                setState(() {
                  messages = false;
                });
              }
            }else{
              setState(() {
                creditRequestDetailId = soCreditRequestDetail.id;
                wflowId = soCreditRequest.wFlowId;
                _currentTabIndex = _crqsBottmonNavBarItems.length-1;
              });
              Fluttertoast.showToast(msg: 'Su solicitud se encuentra en revisión, ya no puede editar su información.');
            }
          }
        }else{
          Fluttertoast.showToast(msg: 'Complete el paso 1 para poder continuar con su registro.');
        }
      },
    );

   return Scaffold(
     appBar: AppBarStyle.authAppBarFlex(title: 'Solicitud de Crédito $codeCrqs'),
     body: AuthFormBackground(
       child: _crqsTabPages[_currentTabIndex]
     ),
     // floatingActionButton: (_currentTabIndex== stepList().length - 1) ? _buttonSponsors() : null,
     // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
     bottomNavigationBar: bottomNavBar,
   );
  }

/*  FloatingActionButton _buttonSponsors () {
    return FloatingActionButton(
      onPressed: () =>
          Fluttertoast.showToast(msg: 'Dummy floating action button'),
      child: const Icon(Icons.add),
    );
  }*/

  //Validaciones para avanzar step
   bool validStep (int step) {
    setState(() {
      sendingData = true;
    });
    bool valid = false;
    switch (step){
      case 0:
        if(_formKeyCrqs.currentState!.validate() && isSwitched && creditDestiny > 0) {
          if (deadLine <= _periods) {
            if(_validPeriods){
            addCreditRequest().then((value) {
              if (value) {
                setState(() {
                  // fetchCreditRequestDetail(soCreditRequest.id.toString()).then((value) => updateDataCrqs());
                  _activeStepIndex += 1;
                  stepRealized = 1;
                  sendingData = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Datos actualizados correctamente')),
                );
              } else {
                setState(() {
                  sendingData = false;
                });
                return false;
              }
            });
            }else{
              setState(() {
                sendingData = false;
              });
              Fluttertoast.showToast(msg: 'Lo sentimos, el plan de crédito seleccionado \n '
                  'no permite este plazo, intente con un plazo diferente.');
              return false;
            }
          } else {
            setState(() {
              sendingData = false;
            });
            Fluttertoast.showToast(
                msg: 'Lo sentimos, el plan de crédito seleccionado \n '
                    'solo le permite un plazo máximo de $_periods meses.');
            return false;
          }

        }else{
          setState(() {
            sendingData = false;
          });
          Fluttertoast.showToast(
              msg: 'Favor de llenar todos los campos \n '
                  'y confirmar autorización para revisar buro de crédito.');
          return false;
        }
        break;
      case 1:
        if(_formKeyCrqs2.currentState!.validate()){
          //Se guardan datos de solicitud de crédito
          addCreditRequestDetail().then((value) {
            if(value){
              setState(() {
                sendingData = false;
                _activeStepIndex += 1;
                stepRealized = 2;
                });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Datos actualizados correctamente')),
              );
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('error $errorMsg')),
              );
              setState(() {
                sendingData = false;
              });return false;
            }
          });
          break;
        }else{
          setState(() {
            sendingData = false;
          });return false;
        }
      case 2:
        if(_formKeyCude.currentState!.validate()){
           addCreditRequestDetail().then((value) {
            if(value){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Datos actualizados correctamente')),
              );
              setState(() {
                sendingData = false;
                _activeStepIndex += 1;
                stepRealized = 3;
              });
            }else{sendingData = false;return false;}
          });setState(() {
             sendingData = false;
           });break;
        }else{
          setState(() {
            sendingData = false;
          });return false;
        }
    }
    return false;
  }
  
  Widget formCreditRequest(List<Step> stepList){
    return Stepper(
      steps: stepList,
      type: StepperType.horizontal,
      currentStep: _activeStepIndex,
      onStepContinue: () {
        if(validStep(_activeStepIndex)) {
          setState(() {
            // _activeStepIndex += 1;
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
        final isLastStep = _activeStepIndex == stepList.length - 1;
        return Row(
          children: [
            const SizedBox(height: 100,),
            //Si es el último paso muestra Guardar en el texto del botón
            if (_activeStepIndex > 0)
              Expanded(
                child: ElevatedButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Atras'),
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            if(!isLastStep)
              Expanded(
                child: ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: (_activeStepIndex == (stepList.length - 2))
                      ? const Text('Guardar')
                      : const Text('Siguiente'),
                ),
              ),
          ],
        );
      },
    );
  }

  Step stepCreditRequest() {
    return Step(
      state: _activeStepIndex <=0 ? StepState.indexed : StepState.complete,
      isActive: _activeStepIndex >= 0,
        title: const Text(""),
        content: CardStepContainer(
          child: Form(
                key: _formKeyCrqs,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(children: [
                  const SizedBox( height: 10 ),
                  DropdownWidget(
                    callback: (String id) {
                      setState(() {
                        creditDestiny = int.parse(id);
                      });
                    },
                    programCode: 'CRMT',
                    label: 'Destino del Crédito*',
                    dropdownValue: soCreditRequest.creditMotiveId.toString(),
                  ),
                  const SizedBox(height: 10,),
                  DropdownWidget(
                    callback: (String id) {
                      setState(() {
                        creditTypeId = int.parse(id);
                      });
                    },
                    programCode: 'CRTY',
                    label: 'Plan de Crédito',
                    dropdownValue: soCreditRequest.creditTypeId.toString(),
                    validations: (int periods, double minAmount, double maxAmount,int periodsMin, int periodsMax){
                      setState((){
                        _periods = periods;
                        _minAmount = minAmount;
                        _maxAmount = maxAmount;
                        _periodsMin = periodsMin;
                        _periodsMax = periodsMax;
                      });
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Monto solicitado*',
                        prefixIcon: Icons.monetization_on_outlined),
                    controller: textMontoCntrll,
                    validator: ( value ) {
                      final intNumber = double.tryParse(value!.replaceAll(',', ''));
                      return (intNumber != null && intNumber >= _minAmount &&
                      intNumber <= _maxAmount)
                          ? null
                          : 'Lo sentimos, el plan de crédito seleccionado requiere\n'
                          'un monto mínimo de $_minAmount y máximo $_maxAmount';
                    },
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
                    validator: ( value ) {
                      final intNumber = double.tryParse(value!.replaceAll(',', ''));
                      return (intNumber != null && intNumber > 0)
                          ? null
                          : 'Por favor indique su pago mensual deseado';
                    },
                  ),
                 /* const SizedBox( height: 10 ),
                  DropdownWidget(
                    callback: (String id) {
                      setState(() {
                        creditProfileId = int.parse(id);
                      });
                    },
                    programCode: 'CRPF',
                    label: 'Perfiles de Crédito',
                    dropdownValue: soCreditRequest.creditProfileId.toString(),
                  ),*/
                  const SizedBox( height: 10 ),
                  Row(
                    children: [
                      const Expanded(
                          child: Text("Regimen Fiscal*",
                            style: TextStyle(color: Colors.grey,fontSize: 15),
                          )
                      ),
                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          child: DropdownButton(
                            value: fiscalRegime,
                            items: SoCreditRequest.getFiscalRegime.map((e) {
                              return DropdownMenuItem(
                                child: Text(e['label']),
                                value: e['value'],
                              );
                            }).toList(),
                            onChanged: (Object? value) {
                              setState(() {
                                fiscalRegime = '$value';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
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
                      ),
                    ],
                  ),
                  if(sendingData)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 30,)
                ]),

            ),
          ),
        );
  }

  //Funcion para validad contraseña
  Future<void> _confirmPassword() async{
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


  List<Widget> plazosChips(){
    List<int> _chipsList = [6,9,12,18,24,30,36,48];
    List<Widget> chips = [];
    for(int i=0;i<_chipsList.length;i++){
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10,right: 5),
        child: ChoiceChip(
            label: Text(_chipsList[i].toString()),
            labelStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.blueGrey,
            selected: deadLine == _chipsList[i],
          onSelected: (bool value){
              /*  if(_chipsList[i] == _profilePeriods[ii]){
                  setState(() { _validPeriods = true; });
                  break;
                }else{
                  setState(() { _validPeriods = false; });
                }*/
              if(_chipsList[i] <= _periods){
                if(_chipsList[i] <= _periodsMax && _chipsList[i] >= _periodsMin){
                  setState((){
                    _validPeriods = true;
                    monthSelected = i;
                    deadLine = _chipsList[i];
                  });
                }else{
                  setState((){
                    _validPeriods = false;
                  });
                  Fluttertoast.showToast(msg: 'Lo sentimos, el plan de crédito seleccionado \n '
                      'no permite este plazo, intente con un plazo diferente.');
                }
              }else{
                Fluttertoast.showToast(msg: 'Lo sentimos, el plan de crédito seleccionado \n '
                    'solo le permite un plazo máximo de $_periods meses.');
              }
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  Step stepCreditRequestDetail(){
    return Step(
      state: _activeStepIndex <= 1 ? StepState.indexed : StepState.complete,
      isActive: _activeStepIndex >= 1,
      title: const Text(""),
      content: CardStepContainer(
        child: Form(
          key: _formKeyCrqs2,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [

              const SizedBox( height: 10 ),
              const Text('Solicitud de Credito', style: TextStyle(color: Colors.grey, fontSize: 20)),
              const SizedBox( height: 10 ),
              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                    labelText: '*Institución Educativa*',
                    hintText: 'Nombre',
                    prefixIcon: Icons.gite_outlined),
                controller: textEducationalInstitutionCntrll,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese una institución';
                },
              ),
              const SizedBox( height: 10 ),
              Row(
                children: [
                  const Expanded(
                      child: Text("Tipo de Institución Educativa*",
                        style: TextStyle(color: Colors.grey,fontSize: 15),
                      )
                  ),
                  DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      child: DropdownButton(
                        value: institutionType,
                        items: SoCreditRequestDetail.getInstitutionType.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['label']),
                            value: e['value'],
                          );
                        }).toList(),
                        onChanged: (Object? value) {
                          setState(() {
                            institutionType = '$value';
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
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Seleccione una Fecha",
                    labelText: "Fecha Inicio",
                    prefixIcon: Icons.calendar_today_outlined
                ),
                controller: textDateStartCntrll,
                readOnly: true,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese una fecha válida';
                },
                onTap: (){
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1910),
                    lastDate: DateTime(2025),
                  ).then((DateTime? value){
                    if(value != null){
                      DateTime _formDate = DateTime.now();
                      _formDate = value;
                      final String date = DateFormat('yyyy-MM-dd').format(_formDate);
                      textDateStartCntrll.text = date;
                    }
                  });
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Seleccione una Fecha",
                    labelText: "Fecha Término",
                    prefixIcon: Icons.calendar_today_outlined
                ),
                controller: textDateEndCntrll,
                readOnly: true,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Por favor ingrese una fecha válida';
                },
                onTap: (){
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1910),
                    lastDate: DateTime(2050),
                  ).then((DateTime? value){
                    if(value != null){
                      DateTime _formDate = DateTime.now();
                      _formDate = value;
                      final String date = DateFormat('yyyy-MM-dd').format(_formDate);
                      textDateEndCntrll.text = date;
                    }
                  });
                },
              ),
              if(sendingData)
                const LinearProgressIndicator(),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }

  Step stepMoreDataCust() {
    return Step(
        state: _activeStepIndex <= 2 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 2,
        title: const Text(""),
        content: CardStepContainer(
          child: Form(
            key: _formKeyCude,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(children: [

                // const SizedBox( height: 10 ),
                // const Text('Datos Personales', style: TextStyle(color: Colors.grey, fontSize: 20)),
                const SizedBox( height: 10 ),
                const Text("Datos Escolares del Cliente",
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Institución*',
                      prefixIcon: Icons.gite_outlined),
                  controller: textInstitutionCntrll,
                   validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese una institución';
                      },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Ubicación*',
                      prefixIcon: Icons.location_on_outlined),
                  controller: textLocationCntrll,
                    validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese una ubicación';
                      },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Periodo*',
                      prefixIcon: Icons.calendar_month_outlined),
                  controller: textPeriodCntrll,
                    validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese un periodo';
                      },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecorations.authInputDecoration(
                      labelText: 'Grado Obtenido*',
                      prefixIcon: Icons.school_outlined),
                  controller: textDegreeCntrll,
                    validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese un grado obtenido';
                      },
                ),
                const SizedBox( height: 10 ),
               /* const Text("Documentos",
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
                const SizedBox(height: 10,),
                UploadIdPhoto(
                  key: _keyUploadIdentification,
                    initialRuta: soCreditRequestDetail.identification,
                    programCode: SoCreditRequestDetail.programCode,
                    fielName: 'crqd_identification',
                    id: soCreditRequestDetail.id.toString(),
                    label: 'Identificación parte frontal',
                callBack: updateDataCrqs,),
                UploadIdPhoto(
                  key: _keyUploadIdentificationBack,
                  initialRuta: soCreditRequestDetail.identificationBack,
                  programCode: SoCreditRequestDetail.programCode,
                  fielName: 'crqd_identificationback',
                  label: 'Identificación parte trasera',
                  id: soCreditRequestDetail.id.toString(),
                  callBack: updateDataCrqs,),*/
                if(sendingData)
                  const LinearProgressIndicator(),
                const SizedBox(height: 30,)
              ])
          ),
        )
    );
  }

/*  updateDataCrqs(){
     fetchCreditRequestDetail(soCreditRequest.id.toString()).then((value) {
       _keyUploadIdentification.currentState?.updateData(soCreditRequestDetail.identification);
       _keyUploadIdentificationBack.currentState?.updateData(soCreditRequestDetail.identificationBack);
       _keyUploadProofAddress.currentState?.updateData(soCreditRequestDetail.proofAddress);
       _keyUploadIdentityVideo.currentState?.updateData(soCreditRequestDetail.identityVideo);

       _keyUploadIdentification.currentState?.updateId(soCreditRequestDetail.id.toString());
       _keyUploadIdentificationBack.currentState?.updateId(soCreditRequestDetail.id.toString());
       _keyUploadProofAddress.currentState?.updateId(soCreditRequestDetail.id.toString());
       _keyUploadIdentityVideo.currentState?.updateId(soCreditRequestDetail.id.toString());
     });
  }*/

  Widget formCrqd(){
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40,),
          CardContainer(
            child: Form(
              key: _formKeyCrqd,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text('Financiamiento en el Extranjero'),
                      ),
                    ),
                    const Divider(thickness: 2,color: Colors.blueGrey,),

                    const Text("Uso de recursos",
                      style: TextStyle(color: Colors.grey,fontSize: 15),
                    ),
                    Row(
                      children: [
                        Switch(
                          value: visaFees,
                          onChanged: (value) {
                            if(!visaFees){
                              setState((){
                                visaFees = value;
                                soCreditRequestDetail.visaFees = 1;
                              });
                            }else {
                              setState(() {
                                visaFees = value;
                                soCreditRequestDetail.visaFees = 0;
                              });
                            }
                          },
                        ),
                        const Expanded(
                            child: Text("Gastos de Visado",
                              style: TextStyle(color: Colors.grey),
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Switch(
                          value: planeTickets,
                          onChanged: (value) {
                            if(!planeTickets){
                              setState((){
                                planeTickets = value;
                                soCreditRequestDetail.planeTickets = 1;
                              });
                            }else {
                              setState(() {
                                planeTickets = value;
                                soCreditRequestDetail.planeTickets = 0;
                              });
                            }
                          },
                        ),
                        const Expanded(
                            child: Text("Boletos de avión",
                              style: TextStyle(color: Colors.grey),
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                          labelText: 'Costo del programa',
                          prefixIcon: Icons.money_off_outlined),
                      controller: textProgramCostCntrll,
                      validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor indique el costo del programa.';
                      },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                          labelText: 'Manutención',
                          prefixIcon: Icons.money_off_outlined),
                      controller: textMaintenanceCntrll,
                      validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor indique los gastos de manuntención.';
                      },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                          labelText: 'Ingresos Comprobables?',
                          prefixIcon: Icons.money_off_outlined),
                      controller: textVerifiableIncomeCntrll,
                      validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor indique sus ingresos comprobables.';
                      },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      decoration: InputDecorations.authInputDecoration(
                          labelText: 'Lugar de Estudios*',
                          prefixIcon: Icons.school_outlined),
                      controller: textStudiesPlaceCntrll,
                      validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor ingrese lugar de estudios';
                      },
                    ),
                    const SizedBox(height: 10,),
                    const Text("Contratación con:",
                      style: TextStyle(color: Colors.grey,fontSize: 15),
                    ),
                    const SizedBox(height: 10,),
                    DropdownWidget(
                      callback: (String id) {
                        setState(() {
                          engagementAgencyId = int.parse(id);
                        });
                      },
                      programCode: 'SUPL',
                      label: 'Agencia',
                      dropdownValue: soCreditRequestDetail.engagementAgencyId.toString(),
                    ),
                    const SizedBox(height: 10,),
                    if(engagementAgencyId <= 0)
                      TextFormField(
                        decoration: InputDecorations.authInputDecoration(
                            labelText: 'Directo con la escuela',
                            prefixIcon: Icons.school_outlined),
                        controller: textEngagementSchollCntrll,
/*                          validator: ( value ) {
                                    return ( value != null && value.isNotEmpty )
                                        ? null
                                        : 'Por favor ingrese lugar de estudios';
                                  },*/
                      ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecorations.authInputDecoration(
                          hintText: "Seleccione una Fecha",
                          labelText: "Fecha Probable de Viaje",
                          prefixIcon: Icons.calendar_today_outlined
                      ),
                      controller: textDateProbablyTravelCntrll,
                      readOnly: true,
                      validator: (value) {
                        return (value != null && value.isNotEmpty)
                            ? null
                            : 'Por favor ingrese una fecha válida';
                      },
                      onTap: (){
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1910),
                          lastDate: DateTime(2050),
                        ).then((DateTime? value){
                          if(value != null){
                            DateTime _formDate = DateTime.now();
                            _formDate = value;
                            final String date = DateFormat('yyyy-MM-dd').format(_formDate);
                            textDateProbablyTravelCntrll.text = date;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      decoration: InputDecorations.authInputDecoration(
                          labelText: 'Programa Educativo',
                          prefixIcon: Icons.school_outlined),
                      controller: textEducationalProgramCntrll,
                      validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor indique el programa educativo';
                      },
                    ),
                    const SizedBox(height: 10,),
                    DropdownWidget(
                      callback: (String id) {
                        setState(() {
                          countryId = int.parse(id);
                        });
                      },
                      programCode: 'CONT',
                      label: 'País',
                      dropdownValue: soCreditRequestDetail.countryId.toString(),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      decoration: InputDecorations.authInputDecoration(
                          labelText: 'Ciudad',
                          prefixIcon: Icons.location_city_outlined),
                      controller: textCityCntrll,
                      validator: ( value ) {
                        return ( value != null && value.isNotEmpty )
                            ? null
                            : 'Por favor indique la ciudad';
                      },
                    ),
                    const SizedBox(height: 10,),
                    if(sendingData)
                      const LinearProgressIndicator(),
                    ElevatedButton(
                      onPressed: () {
                        if(_formKeyCrqd.currentState!.validate()){
                          setState(() {
                            sendingData = true;
                          });
                          addCreditRequest().then((value) {
                            if(value){
                              addCreditRequestDetail().then((value) {
                                if(value){
                                  setState(() {
                                    sendingData = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Datos actualizados correctamente')),
                                  );
                                }else{
                                  setState(() {
                                    sendingData = false;
                                  });
                                  Fluttertoast.showToast(msg: 'Error al guardar los datos');
                                }
                              });
                            }else{
                              setState(() {
                                sendingData = false;
                              });
                              Fluttertoast.showToast(msg: 'Error al guardar los datos');
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
                  ],
                ),
            ),
          ),
          const SizedBox(height: 50,),
        ],
      ),
    );
  }

  Step stepCreditProfile(){
    return Step(
        state: _activeStepIndex <= 2 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 2,
        title: const Text(""),
      content: CardStepContainer(
        child: Form(
          key: _formKeyCreditProfile,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
          children: [
            const SizedBox( height: 10 ),
            const Text('Perfil Crediticio', style: TextStyle(color: Colors.grey, fontSize: 20)),
            const SizedBox(height: 10,),
            SubCatalogContainerWidget(
                title: 'Sponsors',
                child: CreditRequestGuarantee(
                    forceFilter: soCreditRequest.id, requiredAsset: false,whoProccess: 0,
                )
            ),
          ],
        ),
        )
      )
    );
  }

  Step finalStep() {
    return Step(
        state: _activeStepIndex <=3 ? StepState.indexed : StepState.complete,
        isActive: _activeStepIndex >= 3,
        title: const Text(""),
        content: const CardStepContainer(
          child: Text('Se ha guardado su solicitud correctamente'),
        )
    );
  }

  /*//Petición de datos de detalles del cliente parametro id del cliente
  Future<bool> fetchCustomerDetail(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcude;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?id=' +
            id.toString()));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      // Navigator.pushNamed(context, AppRoutes.initialRoute);
      return false;
    }
    //Si no hay errores se guarda el obejto devuelto
    soCustomerDetail = SoCustDetail.fromJson(jsonDecode(response.body));
    return true;
  }*/

  //Petición de datos de detalles de solicitud de crédito parametro id del la solicitud
  Future<bool> fetchCreditRequestDetail(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcrqd;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?id=' +
            id.toString()));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      // Navigator.pushNamed(context, AppRoutes.initialRoute);
      return false;
    }
    //Si no hay errores se guarda el obejto devuelto
    setState((){
      soCreditRequestDetail = SoCreditRequestDetail.fromJson(jsonDecode(response.body));
      creditRequestDetailId = soCreditRequestDetail.id;
    });
    return true;
  }
  //petición de creditrequestguarantees para definir rol preliminar del crédito
  Future<bool> fetchCreditRequestGuarantee(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcrqg;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?id=' +
            id.toString()));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      // Navigator.pushNamed(context, AppRoutes.initialRoute);
      return false;
    }
    setState((){
      //Si no hay errores se guarda el obejto devuelto
      soCreditRequestGuarantee = SoCreditRequestGuarantee.fromJson(jsonDecode(response.body));
    });

    return true;
  }

  // Actualiza la solicitud de credito en el servidor
  Future<bool> addCreditRequest() async {
    soCreditRequest.customerId = idCustomer;
    soCreditRequest.amountRequired = textMontoCntrll.numberValue;
    soCreditRequest.creditMotiveId = creditDestiny;
    soCreditRequest.deadlineRequired = deadLine;
    soCreditRequest.monthlyPayment = textPagoMonthCntrll.numberValue;
    soCreditRequest.creditTypeId = creditTypeId;
    soCreditRequest.fiscalRegime = fiscalRegime;
    if(soCreditRequest.status == ''){
      soCreditRequest.status = SoCreditRequest.STATUS_EDITION;
    }
    if(isSwitched){
      soCreditRequest.creditBureau = 1;
    }else{
      soCreditRequest.creditBureau = 0;
    }

    if(_activeStepIndex == 1) addCreditRequestDetail();

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
      setState((){
      // Si fue exitoso obtiene la respuesta
        soCreditRequest = SoCreditRequest.fromJson(jsonDecode(response.body));
        fetchCreditRequest(soCreditRequest.id.toString());
        codeCrqs = soCreditRequest.code;
        fetchCreditRequestDetail(soCreditRequest.id.toString());
    });
      // Muestra mensaje
     /* ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados correctamente')),
      );*/
      return true;
    } else {
      print(response.body.toString());
      errorMsg = 'Error al guardar solicitud';
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar solicitud')),
      );
      return false;
    }
  }

  //petición de creditrequestguarantees para definir rol preliminar del crédito
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
      // Navigator.pushNamed(context, AppRoutes.initialRoute);
      return false;
    }
    //Si no hay errores se guarda el obejto devuelto

    setState((){
    soCreditRequest= SoCreditRequest.fromJson(jsonDecode(response.body));
      wflowId = soCreditRequest.wFlowId;
    });
    return true;
  }

  /*// Actualiza el customer en el servidor
  Future<bool> addCustomerDetail() async {
    soCustomerDetail.institution = textInstitutionCntrll.text;
    soCustomerDetail.location = textLocationCntrll.text;
    soCustomerDetail.period = textPeriodCntrll.text;
    soCustomerDetail.degreeObtained = textDegreeCntrll.text;
    soCustomerDetail.customerId = params.idLoggedUser;

    // Envia la sesion como Cookie, con el nombre en UpperCase
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcude;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCustomerDetail),
    );

    if (response.statusCode == params.servletResponseScOk) {

      // Si fue exitoso obtiene la respuesta
      soCustomerDetail = SoCustDetail.fromJson(jsonDecode(response.body));

      // Muestra mensaje
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Datos actualizados correctamente')),
      // );
      return true;
    } else {
      errorMsg = response.body.toString();
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ${response.body}')),
      );
      return false;
    }
  }*/

  // Actualiza la solicitud de credito detalle en el servidor
  Future<bool> addCreditRequestDetail() async {
    soCreditRequestDetail.creditRequestId = soCreditRequest.id;
    soCreditRequestDetail.educationalInstitution = textEducationalInstitutionCntrll.text;
    soCreditRequestDetail.educationalInstitutionType = institutionType;
    soCreditRequestDetail.dateStartInstitution = textDateStartCntrll.text;
    soCreditRequestDetail.dateEndInstitution = textDateEndCntrll.text;
    // soCreditRequestDetail.verifiableIncome = verifiableIncome;
    //si es institución internacional
    if(institutionType != SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL){
      soCreditRequestDetail.visaFees = 0;
      soCreditRequestDetail.planeTickets = 0;
      soCreditRequestDetail.programCost = 0;
      soCreditRequestDetail.maintenance = 0;
      soCreditRequestDetail.studiesPlace = '';
      soCreditRequestDetail.engagementAgencyId = 0;
      soCreditRequestDetail.engagementSchool = '';
      soCreditRequestDetail.dateProbablyTravel = '';
      soCreditRequestDetail.educationalProgram = '';
      soCreditRequestDetail.verifiableIncome = 0;
      soCreditRequestDetail.countryId = 0;
      soCreditRequestDetail.city = '';
    }else{
      soCreditRequestDetail.studiesPlace = textStudiesPlaceCntrll.text;
      if(engagementAgencyId > 0){
        soCreditRequestDetail.engagementAgencyId = engagementAgencyId;
        soCreditRequestDetail.engagementSchool = '';
      }else{
        soCreditRequestDetail.engagementAgencyId = -1;
        soCreditRequestDetail.engagementSchool = textEngagementSchollCntrll.text;
      }
      soCreditRequestDetail.programCost = textProgramCostCntrll.numberValue;
      soCreditRequestDetail.maintenance = textMaintenanceCntrll.numberValue;
      soCreditRequestDetail.verifiableIncome = textVerifiableIncomeCntrll.numberValue;
      soCreditRequestDetail.dateProbablyTravel = textDateProbablyTravelCntrll.text;
      soCreditRequestDetail.educationalProgram = textEducationalProgramCntrll.text;
      soCreditRequestDetail.countryId = countryId;
      soCreditRequestDetail.city = textCityCntrll.text;
    }
    soCreditRequestDetail.institution = textInstitutionCntrll.text;
    soCreditRequestDetail.location = textLocationCntrll.text;
    soCreditRequestDetail.period = int.parse(textPeriodCntrll.text);
    soCreditRequestDetail.degreeObtained = textDegreeCntrll.text;

    // Envia la sesion como Cookie, con el nombre en UpperCase
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcrqd;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soCreditRequestDetail),
    );

    if (response.statusCode == params.servletResponseScOk) {

      setState(() {
      // Si fue exitoso obtiene la respuesta
      soCreditRequestDetail = SoCreditRequestDetail.fromJson(jsonDecode(response.body));
        creditRequestDetailId = soCreditRequestDetail.id;
      });
      // Muestra mensaje
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Datos actualizados correctamente')),
      // );
      return true;
    } else {
      print(response.body.toString());
      errorMsg = 'Error al guardar detalles de su solicitud';
      return false;
    }
  }

  // Actualiza la solicitud de credito sponsor preliminar en el servidor
/*  Future<bool> addCreditRequestGuarantee() async {
    soCreditRequestGuarantee.creditRequestId = soCreditRequest.id;
    soCreditRequestGuarantee.customerId = idCustomer;
    soCreditRequestGuarantee.role = rolePreliminar;
    soCreditRequestGuarantee.relation = relation;

    // Envia la sesion como Cookie, con el nombre en UpperCase
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

      // Si fue exitoso obtiene la respuesta
      soCreditRequestGuarantee = SoCreditRequestGuarantee.fromJson(jsonDecode(response.body));

      // Muestra mensaje
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Datos actualizados correctamente')),
      // );
      return true;
    } else {
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al Guardar')),
      );
      return false;
    }
  }*/

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
    setState((){
      soCustomer = SoCustomer.fromJson(jsonDecode(response.body));
    });

    return true;
  }

  Future getData() async {
    late List dataList = [];
    final response = await http.post(
        Uri.parse(params.getAppUrl(params.instance) +
            'dropdownlist;' +
            params.jSessionIdQuery),
        headers: <String, String>{
          'programCode': 'CRTY',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Cookie':
          params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
        },
        body: json.encode(''));


    setState(() {
      dataList = json.decode(response.body);
    });
    for (int i = 0; i < dataList.length; i++) {
      if (int.parse(dataList[i]['id'].toString()) == widget.creditRequest.creditTypeId) {
        setState((){
          _periods = dataList[i]['periods'];
          _minAmount = dataList[i]['minAmount'];
          _maxAmount = dataList[i]['maxAmount'];
          _periodsMin = dataList[i]['periodsMin'];
          _periodsMax = dataList[i]['periodsMax'];
        });
      }
    }
  }
}



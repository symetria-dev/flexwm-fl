
import 'dart:convert';

import 'package:flexwm/main.dart';
import 'package:flexwm/models/crqd.dart';
import 'package:flexwm/models/crqg.dart';
import 'package:flexwm/models/crqs.dart';
import 'package:flexwm/models/crty.dart';
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

import '../models/crqa.dart';
import '../routes/app_routes.dart';
import '../widgets/card_stepcontainer.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/upload_file_widget.dart';
import '../widgets/upload_id_photo_widget.dart';
import 'crqg_form2.dart';
import 'cust_crqs_form.dart';
import 'info_cqrs_screen.dart';


class CrqsForm extends StatefulWidget {
  final SoCreditRequest creditRequest;
  final SoCreditRequestDetail creditRequestDetail;
  const CrqsForm({Key? key, required this.creditRequest,
    required this.creditRequestDetail,}) : super(key: key);

  @override
  _CrqsFormState createState() => _CrqsFormState();

}

class _CrqsFormState extends State<CrqsForm>{
  //Lista de avales
  final List<SoCreditRequestGuarantee> _creditRequestGuarantee = [];
  //Lista de garantias por solicitud de crédito
  final List<SoCreditRequestAsset> _creditRequestAssetListData = [];
  //id de solicitud de crédito
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
  final textCantPeriodoCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  late int creditDestiny = 0;
  int monthSelected = 0;
  int deadLine = 0;
  final textPagoMonthCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  int creditTypeId = 0;
  //controllers campos step 3
  final textEducationalInstitutionCntrll = TextEditingController();
  final textStudentNameCntrll = TextEditingController();
  late String institutionType = '';
  late String periodType = '-';
  final textDateStartCntrll = TextEditingController();
  final textDateEndCntrll = TextEditingController();
  final textInstitutionCntrll = TextEditingController();
  final textLocationCntrll = TextEditingController();
  final textPeriodCntrll = TextEditingController();
  final textDegreeCntrll = TextEditingController();
  final textDisbursementsCntrll = TextEditingController();

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
  final textMonthStayCntrll = TextEditingController();
  late int engagementAgencyId = 0;
  late int countryId = 0;
  final textCityCntrll = TextEditingController();
  final textEngagementSchollCntrll = TextEditingController();
  final textDateProbablyTravelCntrll = TextEditingController();
  final textEducationalProgramCntrll = TextEditingController();
  final textVerifiableIncomeCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final textDisbursementAmountCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  //keys para validaciones de formularios en cada paso
  final _formKeyCrqs = GlobalKey<FormState>();
  final _formKeyCrqs2 = GlobalKey<FormState>();
  final _formKeyCude = GlobalKey<FormState>();
  // final _formKeyStep4 = GlobalKey<FormState>();
  final _formKeyCreditProfile = GlobalKey<FormState>();
  final _formKeyCrqd = GlobalKey<FormState>();
  //key para formulario de periodos
  final _formKeyPeriods = GlobalKey<FormState>();

  late int idCustomer = 0;
  //Valor del checkbox buro de crédito

  //es multidisposicion
  int multiDisposicion = 0;

  //Objeto de tipo cliente para validación
  SoCustomer soCustomer = SoCustomer.empty();
  //Objeto de plan de credito
  SoCreditType soCreditType = SoCreditType.empty();

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
  //check quien cursa el progama
  bool checkWhoStudies = false;
  //check quien formaliza credito
  bool checkWhoProcesses = false;
  //check ingresos comprobables
  bool checkIncome = false;
  //codigo solicitud
  String codeCrqs = '';
  //paso en el que se encuentra la solicitud
  int stepRealized = 0;
  // mensaje recibidos
  bool messages = false;
  //bandera forma internaciones
  bool isForeign = false;
  //total avales registrados
  int allGuarantees = 0;
  //requiere garantía?
  bool requiredAsset = false;
  //debe crear acreditado titular diferente
  bool requiredAcredited = false;

  @override
  void initState(){
    //Se obtiene el cliente que se encuentra loggeado
    idCustomer = params.idLoggedUser;
    fetchCustomer(idCustomer.toString());
    institutionType = SoCreditRequestDetail.INSTITUTION_TYPE_NATIONAL;
    //Si existe el crédito minimo va en el paso 3
    if(widget.creditRequest.id > 0){
      fetchCrqg(widget.creditRequest.id).then((value) {
        if(soCreditRequestGuarantee.verifiableIncome > 0){
          textVerifiableIncomeCntrll.updateValue(soCreditRequestGuarantee.verifiableIncome);
          checkWhoProcesses =true;
          checkIncome = true;
        }
      });
      setState((){
        stepRealized = 2;
        _activeStepIndex = 2;
      });




      //obtener datos de dropdownlist (funcionaba para los planes de crédito)
      getData();

      soCreditRequest = widget.creditRequest;
      if(soCreditRequest.soWFlow.userMsgs){
        setState(() {
          messages = true;
        });
      }

      if(soCreditRequest.status != SoCreditRequest.STATUS_EDITION){
        setState(() {
          stepRealized = 3;
          _activeStepIndex = 3;
          _currentTabIndex = 3;
        });
      }

      codeCrqs = soCreditRequest.code;
      fiscalRegime = soCreditRequest.fiscalRegime;
      if(soCreditRequest.creditMotiveId > 0){
        creditDestiny = soCreditRequest.creditMotiveId;
      }

      if(soCreditRequest.disbursements > 0){
        multiDisposicion = 1;
        textDisbursementsCntrll.text = soCreditRequest.disbursements.toString();
        textCantPeriodoCntrll.updateValue(soCreditRequest.disbursementAmount);
      }

      creditTypeId = soCreditRequest.creditTypeId;
      textMontoCntrll.updateValue(soCreditRequest.amountRequired);
      deadLine = soCreditRequest.deadlineRequired;
      textPagoMonthCntrll.updateValue(soCreditRequest.monthlyPayment);

      if(soCreditRequest.creditBureau == 1) isSwitched = true;
      // textDateStartCntrll.text = soCreditRequest.starDate;

     soCreditRequestDetail = widget.creditRequestDetail;

     periodType = soCreditRequestDetail.periodType;
      textPeriodCntrll.text = soCreditRequestDetail.period.toString();
              textInstitutionCntrll.text = soCreditRequestDetail.institution;
              textLocationCntrll.text = soCreditRequestDetail.location;
              textDegreeCntrll.text = soCreditRequestDetail.degreeObtained;
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
            if(soCreditRequestDetail.engagementAgencyId > 0) {
              setState((){engagementAgencyId = soCreditRequestDetail.engagementAgencyId;});
            }
            if(soCreditRequestDetail.whoProcesses > 0) checkWhoProcesses = true;
            if(soCreditRequestDetail.whoStudies > 0){
              checkWhoStudies = true;
              _activeStepIndex = 3;
              stepRealized = 3;
              _currentTabIndex = 3;
            }else{
              checkWhoStudies = false;
            }
            if(soCreditRequestDetail.studentName != ''){
              textStudentNameCntrll.text = soCreditRequestDetail.studentName;
              _activeStepIndex = 3;
              stepRealized = 3;
              _currentTabIndex = 3;
            }
            textEngagementSchollCntrll.text = soCreditRequestDetail.engagementSchool;
            textDateProbablyTravelCntrll.text = soCreditRequestDetail.dateProbablyTravel;
            textEducationalProgramCntrll.text = soCreditRequestDetail.educationalProgram;
            countryId = soCreditRequestDetail.countryId;
            textCityCntrll.text = soCreditRequestDetail.city;
      textMonthStayCntrll.text = soCreditRequestDetail.monthStay.toString();

      //step 3
      rolePreliminar = SoCreditRequestGuarantee.ROLE_ACREDITED;
      relation = SoCreditRequestGuarantee.RELATION_SELF;
      //Se consulta cuantos avales existen para ver si se redirije a la forma
      fetchSoCreditRequestGuarantee(widget.creditRequest.id).then((value) {
        allGuarantees = _creditRequestGuarantee.length;
        //Obtiene lista de garantías para validar si se requiere o no
        fetchSoCreditRequestAssets(soCreditRequest.id).then((value) {
          fetchCrty(soCreditRequest.creditMotiveId.toString()).then((value) {
            //se válida si se requiere garantía
            if(_creditRequestAssetListData.isEmpty &&
                soCreditRequest.amountRequired > soCreditType.amountAsset){
              setState(() {
                requiredAsset = true;
              });
            }
            //Si no se han registrado el numero de avales requeridos redirecciona a forma de aval
            if(requiredGuarantees() && stepRealized > 2){
              showAlertDialog(context, 'Por los parámetros de tu solicitud se '
                  'requiere agregar acreditados extra, favor de agregarlos en la siguiente pantalla.');
            }
          });
        });
      });
    }else{
      creditDestiny = 0;
      rolePreliminar = SoCreditRequestGuarantee.ROLE_ACREDITED;
      relation = SoCreditRequestGuarantee.RELATION_SELF;
    }
    super.initState();
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
      // if(institutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL)
      // AuthListBackground(child: formCrqd()),
      AuthListBackground(child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: CreditRequestGuarantee(forceFilter: soCreditRequest.id, requiredAsset: requiredAsset,),
      )),
      AuthListBackground(child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: ChatPrueba(forceFilter: wflowId),
      ),),
      AuthListBackground(child: CreditRequestInfoScreen(soCreditRequest: soCreditRequest,
        step: stepRealized, requiredAsset: requiredAsset, requiredGuarantees: allGuarantees,)
      ),
    ];

    //Iconos para barra de navegación inferior
    final _crqsBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_sharp), label: 'Cotiza'),
      // if(institutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL)
      //   const BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active), label: 'Acréditado'),
      const BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Acréditado'),
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
      const BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Estatus'),
    ];

    updateCrqsInfo(){

    }

    final bottomNavBar = BottomNavigationBar(
      items: _crqsBottmonNavBarItems,
      unselectedItemColor: Colors.grey,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        // setState(() {
        //   _currentTabIndex = index;
        // });
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
          Fluttertoast.showToast(msg: 'Complete hasta el paso 2 para poder continuar con su registro.');
        }
      },);


   return Scaffold(
     appBar: AppBarStyle.authAppBarFlex(title: 'Solicitud de Crédito $codeCrqs'),
     body: AuthFormBackground(
       child: _crqsTabPages[_currentTabIndex]
     ),
     bottomNavigationBar: bottomNavBar,
   );
  }

  //Validaciones para avanzar step
  bool validStep (int step) {
    switch (step){
      case 0:
        if(_formKeyCrqs.currentState!.validate() && creditDestiny > 0 &&
            (engagementAgencyId > 0 || textInstitutionCntrll.text != '')
        && institutionType != '' && periodType != '-') {
          //Se valida el tipo lugar de estudios
          if(institutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL){
            if(_formKeyCrqd.currentState!.validate()){
              setState(() {
                _activeStepIndex += 1;
                stepRealized = 1;
              });
              return true;
            }else{
              Fluttertoast.showToast(msg: 'Favor de llenar todos los campos');
              return false;
            }
          }else{
            setState(() {
              _activeStepIndex += 1;
              stepRealized = 1;
            });
            return true;
          }

        }else{
          Fluttertoast.showToast(msg: 'Favor de llenar todos los campos');
          return false;
        }
        break;
      case 1:
        if(_formKeyCrqs2.currentState!.validate()){
          setState(() { sendingData = true;});
          if(_validPeriods){
            //Se guardan datos de solicitud de crédito
            addCreditRequest().then((value) {
              if(value){
                //buscamos el acreditado titular
                fetchCrqg(soCreditRequest.id);
                addCreditRequestDetail().then((value) {
                  if(value){
                    setState(() {
                      _activeStepIndex += 1;
                      stepRealized = 2;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Datos actualizados correctamente')),
                    );
                    return true;
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$errorMsg')),
                    );
                    return false;
                  }
                });
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$errorMsg')),
                );
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
          break;
        }else{;return false;
        }
      case 2:
        if(_formKeyCude.currentState!.validate()){
          setState(() { sendingData = true;});
          addCreditRequestGuarantee().then((value) {
            //se agrega detalle de la solicitud
            addCreditRequestDetail().then((value) {
              if(value){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Datos actualizados correctamente')),
                );
                setState(() {
                  _activeStepIndex += 1;
                  stepRealized = 3;
                });
                //Se consulta si requiere garantias
                fetchSoCreditRequestAssets(soCreditRequest.id).then((value) {
                  if(_creditRequestAssetListData.isEmpty &&
                      soCreditRequest.amountRequired > soCreditType.amountAsset){
                    setState(() {
                      requiredAsset = true;
                    });
                  }else{
                    setState(() {
                      requiredAsset = false;
                    });
                  }
                  //se consulta solicitud para actualizar datos
                  fetchCreditRequest(soCreditRequestDetail.creditRequestId.toString()).then((value) {
                    print('after fetchcrqs - ${soCreditRequest.guarantees}');
                    //se consultan los acreditados registrados en esa solicitud
                    fetchSoCreditRequestGuarantee(soCreditRequest.id).then((value) {
                      allGuarantees = _creditRequestGuarantee.length;
                      //si requiere acreditados se redirige a la forma
                      if (requiredGuarantees()) {
                        showAlertDialog(
                            context, 'Por los parámetros de tu solicitud se '
                            'requiere agregar acreditados extra, favor de agregarlos en la siguiente pantalla.');
                      }else{
                        showAlertDialog(context, 'Favor de completar sus datos financieros en la siguiente pantalla.');
                      }
                    });
                  });
                });

              }else{
                return false;}
            });
          });
              break;
        }else{
          return false;
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
        if(!sendingData) {
          if (validStep(_activeStepIndex)) {
            /*setState(() {
            sendingData = false;
            _activeStepIndex += 1;
          });*/
          }
        }else{
          Fluttertoast.showToast(msg: 'Solictud en proceso, espere un momento');
        }
        // else{setState((){sendingData = false;});}
        /*setState(() {
          _activeStepIndex += 1;
        });*/
      },
      onStepCancel: () {
        final isLastStep = _activeStepIndex == stepList.length - 1;
        if (_activeStepIndex == 0) {
          return;
        }

       /* if(isLastStep){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  CreditRequestGuarateeForm2(
                      soCreditRequestGuarantee: SoCreditRequestGuarantee.empty(),
                      creditRequestId: soCreditRequest.id),
              )
          ).then((value) => setState((){
            //TODO: Acción al cerrar formulario avales desde formulario solicitud
          }));
        }else{*/
          setState(() {
            _activeStepIndex -= 1;
          });
        // }
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
                  child: (_activeStepIndex == (stepList.length - 1))
                      ? const Text('Guardar')
                      : const Text('Siguiente'),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget stepOne(){
     return Form(
       key: _formKeyCrqs,
       autovalidateMode: AutovalidateMode.onUserInteraction,
       child: Column(children: [
         // const SizedBox(height: 10,),
         Row(
           children: const [
             Text("Contratación con:",
               style: TextStyle(color: Colors.grey,fontSize: 15),
             ),
           ],
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
         if(engagementAgencyId < 1)
         TextFormField(
           autocorrect: false,
           keyboardType: TextInputType.name,
           controller: textInstitutionCntrll,
           decoration: InputDecorations.authInputDecoration(
               hintText: "Otra institución",
               labelText: "*Otra institución",
               prefixIcon: Icons.school
           ),
           validator: ( value ) {
             return ( value != null && value.isNotEmpty )
                 ? null
                 : 'Por favor ingrese una institución válida';
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
         const SizedBox( height: 10 ),
         Row(
           children: const [
             Text("Seleccionar programa de estudios",
               style: TextStyle(color: Colors.grey,fontSize: 15),
             ),
           ],
         ),
         DropdownWidget(
           callback: (String id) {
             setState(() {
               creditDestiny = int.parse(id);
             });
             if(creditDestiny > 0){
               fetchCrty(creditDestiny.toString());
             }
           },
           programCode: 'CRMT',
           label: 'Programa de estudios*',
           dropdownValue: soCreditRequest.creditMotiveId.toString(),
         ),
         const SizedBox(height: 10),
         Row(
           children: [
             const Expanded(
                 child: Text("Tipo periodo de estudios*",
                   style: TextStyle(color: Colors.grey,fontSize: 15),
                 )
             ),
             DropdownButtonHideUnderline(
               child: ButtonTheme(
                 child: DropdownButton(
                   value: periodType,
                   items: SoCreditRequest.getPeriodType.map((e) {
                     return DropdownMenuItem(
                       child: Text(e['label']),
                       value: e['value'],
                     );
                   }).toList(),
                   onChanged: (Object? value) {
                     setState(() {
                       periodType = '$value';
                     });
                   },
                 ),
               ),
             ),
           ],
         ),
           const SizedBox(height: 10),
           TextFormField(
             autocorrect: false,
             controller: textPeriodCntrll,
             keyboardType: TextInputType.number,
             decoration: InputDecorations.authInputDecoration(
                 hintText: "Periodos del Programa de Estudios",
                 labelText: "*Periodos del Programa de Estudios",
                 prefixIcon: Icons.numbers
             ),
             validator: ( value ) {
               final intNumber = int.tryParse(value!);
               return (intNumber != null && intNumber > 0)
                   ? null
                   : 'Favor de ingresar un número válido (solo números)';
             },
           ),
         if(multiDisposicion > 0)
         const SizedBox(height: 10),
         if(multiDisposicion > 0)
         TextFormField(
           autocorrect: false,
           controller: textDisbursementsCntrll,
           keyboardType: TextInputType.number,
           decoration: InputDecorations.authInputDecoration(
               hintText: "Num. Disposiciones",
               labelText: "*Num. Disposiciones",
               prefixIcon: Icons.numbers
           ),
           validator: ( value ) {
             final intNumber = int.tryParse(value!);
             return (intNumber != null && intNumber > 0)
                 ? null
                 : 'Favor de ingresar un número válido (solo números)';
           },
           onChanged: (value) {
             final intNumber = int.tryParse(value!);
             textMontoCntrll.updateValue(intNumber!*textCantPeriodoCntrll.numberValue);
           },
         ),
         if(multiDisposicion > 0)
           const SizedBox(height: 10),
         if(multiDisposicion > 0)
           TextFormField(
             autocorrect: false,
             controller: textCantPeriodoCntrll,
             keyboardType: TextInputType.number,
             decoration: InputDecorations.authInputDecoration(
                 hintText: "Monto por periodo",
                 labelText: "*Monto por periodo",
                 prefixIcon: Icons.monetization_on_outlined
             ),
             validator: ( value ) {
               final intNumber = double.tryParse(value!.replaceAll(',', ''));
               /*return (intNumber != null && intNumber >= _minAmount &&
                 intNumber <= _maxAmount)
                 ? null
                 : 'Lo sentimos, el plan de crédito seleccionado requiere\n'
                 'un monto mínimo de $_minAmount y máximo $_maxAmount';*/
               return (intNumber != null && intNumber > 0)
                   ? null
                   : 'Favor de ingresar un monto mayor a 0';
             },
             onChanged: (value) {
               final intNumber = double.tryParse(value!.replaceAll(',', ''));
               textMontoCntrll.updateValue(intNumber!*int.parse(textDisbursementsCntrll.text));
             },
           ),
         const SizedBox(height: 10,),
         TextFormField(
           keyboardType: TextInputType.number,
           readOnly: (multiDisposicion>0),
           decoration: InputDecorations.authInputDecoration(
               labelText: 'Monto total solicitado*',
               prefixIcon: Icons.monetization_on_outlined),
           controller: textMontoCntrll,
           validator: ( value ) {
             final intNumber = double.tryParse(value!.replaceAll(',', ''));
             return (intNumber != null && intNumber >= soCreditType.minAmount &&
                 intNumber <= soCreditType.maxAmount)
                 ? null
                 : 'Lo sentimos, el plan de crédito seleccionado requiere\n'
                 'un monto mínimo de ${soCreditType.minAmount} y máximo ${soCreditType.maxAmount}';
         /*    return (intNumber != null && intNumber >= soCreditType.minAmou)
                 ? null
                 : 'Favor de ingresar un monto mayor a 0';*/
           },
         ),
         const SizedBox(height: 30,)
       ]),
     );
  }


  Step stepCreditRequest() {
    return Step(
      state: _activeStepIndex <=0 ? StepState.indexed : StepState.complete,
      isActive: _activeStepIndex >= 0,
        title: const Text(""),
        content: CardStepContainer(
          child: Column(
            children: [
              /*if(!isForeign)
                stepOne()
              else
                formCrqd()*/
              stepOne(),
              if(institutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL)
                formCrqd(),

              if(sendingData)
                const LinearProgressIndicator(),
            ],
          )
          ),
        );
  }

  Widget formPeriods(){
    return Form(
      key: _formKeyPeriods,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

        ],
      )
    );
  }

  Widget formCrqd(){
    return Form(
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
         /* const SizedBox(height: 10,),
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
          ),*/
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
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecorations.authInputDecoration(
                labelText: 'Estancia en el Extranjero (meses)',
                prefixIcon: Icons.calendar_month),
            controller: textMonthStayCntrll,
            validator: ( value ) {
              final intNumber = int.tryParse(value!);
              return (intNumber != null && intNumber > 0)
                  ? null
                  : 'Por favor indique los meses que estará en el extranjero. (solo números)';
            },
          ),
         /* const SizedBox(height: 10,),
          if(engagementAgencyId <= 0)
            TextFormField(
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Directo con la escuela',
                  prefixIcon: Icons.school_outlined),
              controller: textEngagementSchollCntrll,
*//*                          validator: ( value ) {
                            return ( value != null && value.isNotEmpty )
                                ? null
                                : 'Por favor ingrese lugar de estudios';
                          },*//*
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
          ),*/
        /*  ElevatedButton(
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
          ),*/
        ],
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
                if(_chipsList[i] >= soCreditType.periodsMin &&
                    _chipsList[i] <= soCreditType.periodsMax){
                  setState(() { _validPeriods = true; });
                }else{
                  setState(() { _validPeriods = false; });
                }
            setState((){
              deadLine = _chipsList[i];
              getAmountPayment(textMontoCntrll.numberValue, deadLine);
            });
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
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Seleccione una Fecha",
                    labelText: "Fecha Inicio Estudios",
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
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    labelText: 'Pago mensual aproximado*',
                    prefixIcon: Icons.payments_outlined),
                controller: textPagoMonthCntrll,
                validator: ( value ) {
                  final intNumber = double.tryParse(value!.replaceAll(',', ''));
                  return (intNumber != null && intNumber > 0)
                      ? null
                      : 'Por favor indique su pago mensual';
                },
              ),
              if(sendingData)
                const LinearProgressIndicator(),
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
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Switch(
                      value: checkWhoStudies,
                      onChanged: (value) {
                        /*  if(!whoStudies){
                        _confirmPassword();
                      }else {*/
                        setState(() {
                          checkWhoStudies = value;
                        });
                        // }
                      },
                    ),
                    const Expanded(
                        child: Text("¿Tu eres quien cursará el programa? ",
                          style: TextStyle(color: Colors.grey),
                        )
                    ),
                  ],
                ),
                const SizedBox( height: 10 ),
                if(!checkWhoStudies)
                  TextFormField(
                    decoration: InputDecorations.authInputDecoration(
                        labelText: '*Nombre del estudiante',
                        hintText: 'Nombre',
                        prefixIcon: Icons.account_circle_outlined),
                    controller: textStudentNameCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un nombre válido';
                    },
                  ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Switch(
                      value: checkWhoProcesses,
                      onChanged: (value) {
                        /*  if(!whoStudies){
                        _confirmPassword();
                      }else {*/
                        if(!value){
                          setState(() {
                            checkIncome = false;
                          });
                        }
                        setState(() {
                          checkWhoProcesses = value;
                        });
                        // }
                      },
                    ),
                    const Expanded(
                        child: Text("¿Tu eres quien formalizará el crédito? ",
                          style: TextStyle(color: Colors.grey),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                //TODO: cambiar boolean del swiched
                if(checkWhoProcesses)
                Row(
                  children: [
                    Switch(
                      value: checkIncome,
                      onChanged: (value) {
                        /*  if(!whoStudies){
                        _confirmPassword();
                      }else {*/
                        setState(() {
                          checkIncome = value;
                        });
                        // }
                      },
                    ),
                    const Expanded(
                        child: Text("¿Tienes ingresos comprobables? ",
                          style: TextStyle(color: Colors.grey),
                        )
                    ),
                  ],
                ),
                 const SizedBox(height: 10,),
                if(checkIncome)
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

 /* Step stepCreditProfile(){
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
                    forceFilter: soCreditRequest.id, requiredAsset: requiredAsset,
                )
            ),
          ],
        ),
        )
      )
    );
  }*/

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

  bool requiredGuarantees(){
    bool request = false;
    if(allGuarantees < soCreditRequest.guarantees){
      request = true;
    }

    return request;
  }

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
      engagementAgencyId = soCreditRequestDetail.engagementAgencyId;
    });
    return true;
  }
  //petición de creditrequestguarantees para definir rol preliminar del crédito
/*  Future<bool> fetchCreditRequestGuarantee(String id) async {
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
  }*/

  // Actualiza la solicitud de credito en el servidor
  Future<bool> addCreditRequest() async {
    soCreditRequest.customerId = idCustomer;
    soCreditRequest.amountRequired = textMontoCntrll.numberValue;
    soCreditRequest.creditMotiveId = creditDestiny;
    soCreditRequest.deadlineRequired = deadLine;
    soCreditRequest.monthlyPayment = textPagoMonthCntrll.numberValue;

    // soCreditRequest.starDate = textDateStartCntrll.text;
    // soCreditRequest.periods = int.parse(textPeriodCntrll.text);
    // soCreditRequest.periodType = periodType;

    soCreditRequest.creditTypeId = creditTypeId;
    // soCreditRequest.fiscalRegime = fiscalRegime;
    if(soCreditRequest.status == ''){
      soCreditRequest.status = SoCreditRequest.STATUS_EDITION;
    }
    if(multiDisposicion > 0){
      soCreditRequest.disbursements = int.parse(textDisbursementsCntrll.text);
      soCreditRequest.disbursementAmount = textCantPeriodoCntrll.numberValue;
    }else{
      soCreditRequest.disbursements = 1;
    }
    //TODO: Analizar eliminar este campo en crqs
    soCreditRequest.creditBureau = 0;

    // if(_activeStepIndex == 1) addCreditRequestDetail();

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
        // fetchCreditRequestDetail(soCreditRequest.id.toString());
    });
      // Muestra mensaje
     /* ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados correctamente')),
      );*/
      return true;
    } else {
      print(response.body.toString());
      errorMsg = response.body.toString();
      // Error al guardar
     /* ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar solicitud')),
      );*/
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

  // Actualiza la solicitud de credito detalle en el servidor
  Future<bool> addCreditRequestDetail() async {
    soCreditRequestDetail.creditRequestId = soCreditRequest.id;
    soCreditRequestDetail.educationalInstitution = textEducationalInstitutionCntrll.text;
    soCreditRequestDetail.educationalInstitutionType = institutionType;
    if(institutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL){
      soCreditRequestDetail.monthStay = int.parse(textMonthStayCntrll.text);
    }else{
      soCreditRequestDetail.monthStay = 0;
    }

    if(engagementAgencyId > 0){
      soCreditRequestDetail.engagementAgencyId = engagementAgencyId;
      soCreditRequestDetail.institution = '';
    }else{
      soCreditRequestDetail.engagementAgencyId = -1;
      soCreditRequestDetail.institution = textInstitutionCntrll.text;
    }

    if(checkWhoStudies){
      soCreditRequestDetail.whoStudies = 1;
      soCreditRequestDetail.studentName = '';
    }else{
      soCreditRequestDetail.whoStudies = 0;
      soCreditRequestDetail.studentName = textStudentNameCntrll.text;
    }

    if(checkWhoProcesses){
      soCreditRequestDetail.whoProcesses = 1;
    }else{
      soCreditRequestDetail.whoProcesses = 0;
    }
    soCreditRequestDetail.dateStartInstitution = textDateStartCntrll.text;
    // soCreditRequestDetail.dateEndInstitution = textDateEndCntrll.text;
    // soCreditRequestDetail.verifiableIncome = verifiableIncome;
    //si es institución internacional
    if(institutionType != SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL){
      soCreditRequestDetail.visaFees = 0;
      soCreditRequestDetail.planeTickets = 0;
      soCreditRequestDetail.programCost = 0;
      soCreditRequestDetail.maintenance = 0;
      soCreditRequestDetail.studiesPlace = '';
      soCreditRequestDetail.dateProbablyTravel = '';
      soCreditRequestDetail.educationalProgram = '';
      soCreditRequestDetail.countryId = 0;
      soCreditRequestDetail.city = '';
      soCreditRequestDetail.engagementSchool = '';
    }else{
      soCreditRequestDetail.studiesPlace = textStudiesPlaceCntrll.text;
      soCreditRequestDetail.programCost = textProgramCostCntrll.numberValue;
      soCreditRequestDetail.maintenance = textMaintenanceCntrll.numberValue;
      soCreditRequestDetail.dateProbablyTravel = textDateProbablyTravelCntrll.text;
      soCreditRequestDetail.educationalProgram = textEducationalProgramCntrll.text;
      soCreditRequestDetail.countryId = countryId;
      soCreditRequestDetail.city = textCityCntrll.text;
    }
    soCreditRequestDetail.location = textLocationCntrll.text;
    soCreditRequestDetail.period = int.parse(textPeriodCntrll.text);
    soCreditRequestDetail.periodType = periodType;
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
        sendingData = false;
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
      errorMsg = response.body.toString();
      return false;
    }
  }

  //Peticon de datos de un cliente especifico
  Future<bool> fetchCrqg(int id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcrqg;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?idSolicitud=' +
            id.toString()
    ));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      Navigator.pushNamed(context, AppRoutes.initialRoute);
    }

    setState((){
      soCreditRequestGuarantee = SoCreditRequestGuarantee.fromJson(jsonDecode(response.body));
    });
    return true;
  }

  // Actualiza la solicitud de credito sponsor preliminar en el servidor
  Future<bool> addCreditRequestGuarantee() async {
    if(checkIncome){
      soCreditRequestGuarantee.verifiableIncome = textVerifiableIncomeCntrll.numberValue;
    }else{
      soCreditRequestGuarantee.verifiableIncome = 0;
    }

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
      print('error crqg ${response.body}');
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.body.toString())),
      );
      return false;
    }
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
      print('Error listado: ' + response.toString());
      Navigator.pushNamed(context, AppRoutes.initialRoute);
      return false;
    }
    //Si no hay errores se guarda el obejto devuelto
    setState((){
      soCustomer = SoCustomer.fromJson(jsonDecode(response.body));
    });

    return true;
  }

  //Petición de datos de un cliente especifico
  Future<bool> fetchCrty(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restcrty;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?id=' +
            id.toString()));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
      // Navigator.pushNamed(context, AppRoutes.initialRoute);
      return false;
    }
    //Si no hay errores se guarda el obejto devuelto
    setState((){
      soCreditType = SoCreditType.fromJson(jsonDecode(response.body));
      creditTypeId = soCreditType.id;
      multiDisposicion = soCreditType.multiDisbursement;
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

  //metodo para lista de avales de la solicitud
  Future<List<SoCreditRequestGuarantee>> fetchSoCreditRequestGuarantee(
      int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcrqg;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        params.forceFilter +
        '=' +
        forceFilter.toString() +
        '&' +
        params.filterValueQuery +
        '=' +
        idCustomer.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      print('Error listado: ' + response.toString());
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    setState(() {
      if(soCreditRequestDetail.whoProcesses == 0 ||
          soCreditRequestDetail.educationalInstitutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL){

      }
      _creditRequestGuarantee.clear();
    _creditRequestGuarantee.addAll(parsed
        .map<SoCreditRequestGuarantee>(
            (json) => SoCreditRequestGuarantee.fromJson(json))
        .toList());
    });
    isAcredited();
    return parsed
        .map<SoCreditRequestGuarantee>(
            (json) => SoCreditRequestGuarantee.fromJson(json))
        .toList();
  }

  void isAcredited (){
    for (SoCreditRequestGuarantee soGuarantee in _creditRequestGuarantee){
      if(soGuarantee.role == SoCreditRequestGuarantee.ROLE_ACREDITED
      && soGuarantee.relation == SoCreditRequestGuarantee.RELATION_SELF &&
          (soCreditRequestDetail.educationalInstitutionType == SoCreditRequestDetail.INSTITUTION_TYPE_INTERNATIONAL
          && soCreditRequestDetail.monthStay > soCreditType.maxMonthStay)){
        setState(() {
          requiredAcredited = true;
        });
      }

      if(!checkWhoProcesses){
        setState(() {
          requiredAcredited = true;
        });
      }

    }
  }

  //Consulta las garantias por solicitud
  Future<List<SoCreditRequestAsset>> fetchSoCreditRequestAssets(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcrqa;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        'crqs' +
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

  //metodo para lista de avales de la solicitud
  Future<bool> getAmountPayment(double amount, int period) async {
    String url = params.getAppUrl(params.instance) +
        'restfinance;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        'period' +
        '=' +
        period.toString() +
        '&' +
        'amount' +
        '=' +
        amount.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
      Navigator.pushNamed(context, '/');
      return false;
    }

    // final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    setState(() {
      textPagoMonthCntrll.updateValue(double.parse(response.body));
    });
    return true;
  }
  showAlertDialog(BuildContext context, String text) {
    // set up the buttons
    /* Widget cancelButton = TextButton(
      child: const Text("Cancelar"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );*/
    Widget continueButton = TextButton(
      child: const Text("Continuar"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Registro Creado con Éxito "),
      content: Text(text),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) {
      if(requiredGuarantees()){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                CreditRequestGuarateeForm2(
                  soCreditRequestGuarantee: SoCreditRequestGuarantee
                      .empty(),
                  creditRequestId: soCreditRequest.id,
                  requiredAsset: requiredAsset,
                  requiredAcredited: requiredAcredited,),
            )
        ).then((value) =>
            setState(() {
              //al volver se verifica que si se cumpla, si no redirecciona a home
              _creditRequestGuarantee.clear();
              fetchSoCreditRequestAssets(soCreditRequest.id)
                  .then((value) {
                if (_creditRequestAssetListData.isEmpty &&
                    soCreditRequest.amountRequired >
                        soCreditType.amountAsset) {
                  setState(() {
                    requiredAsset = true;
                  });
                } else {
                  setState(() {
                    requiredAsset = false;
                  });
                }
              });
              //al cerrar forma se verifica si si se agrego y si no
              //se redirije a la pantalla de inicio
              fetchSoCreditRequestGuarantee(
                  soCreditRequest.id).then((value) {
                allGuarantees =
                    _creditRequestGuarantee.length;
                if (requiredGuarantees()) {
                  Navigator.pushNamed(context, '/crqs_list');
                }
              });
            }));
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
            CreditRequestGuarateeForm2(
            soCreditRequestGuarantee: soCreditRequestGuarantee,
            creditRequestId: soCreditRequest.id, requiredAsset: requiredAsset,
            requiredAcredited: false,),
          )
        );
      }
    });
  }

}



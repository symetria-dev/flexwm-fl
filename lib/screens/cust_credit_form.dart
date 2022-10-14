
import 'dart:convert';

import 'package:flexwm/main.dart';
import 'package:flexwm/models/crqd.dart';
import 'package:flexwm/models/crqg.dart';
import 'package:flexwm/models/crqs.dart';
import 'package:flexwm/models/cude.dart';
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
import 'cust_crqs_form.dart';


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
  //objeto para los datos de detalle del cliente
  SoCustDetail soCustomerDetail = SoCustDetail.empty();
  //objeto para los datos de detalle solicitud de crédito
  SoCreditRequestDetail soCreditRequestDetail = SoCreditRequestDetail.empty();
  //objeto para los datis de perfil de crédito
  SoCreditRequestGuarantee soCreditRequestGuarantee = SoCreditRequestGuarantee.empty();
  //Indice indicador de paso activo
  int _activeStepIndex = 0;

  //controllers campos step2
  final textMontoCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  late String creditDestiny = '';
  int monthSelected = 0;
  final textPagoMonthCntrll = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  int currencyId = 0;
  int creditTypeId = 0;
  int creditProfileId = 0;
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
    institutionType = SoCreditRequest.INSTITUTION_TYPE_NATIONAL;
    //Se inicializa step 2 y 4
    if(widget.creditRequest.id > 0){
      soCreditRequest = widget.creditRequest;
      currencyId = soCreditRequest.currencyId;
      creditDestiny = soCreditRequest.destiny;
      creditTypeId = soCreditRequest.creditTypeId;
      textMontoCntrll.updateValue(soCreditRequest.amountRequired);
      monthSelected = soCreditRequest.deadlineRequired;
      textPagoMonthCntrll.updateValue(soCreditRequest.monthlyPayment);
      creditProfileId = soCreditRequest.creditProfileId;
      fetchCreditRequest(widget.creditRequest.id.toString()).then((value) {
        if(value){
          if(soCreditRequest.educationalInstitution != '' ) textEducationalInstitutionCntrll.text = soCreditRequest.educationalInstitution;
          if(soCreditRequest.educationalInstitutionType != '' ) institutionType = soCreditRequest.educationalInstitutionType;
          if(soCreditRequest.dateStartInstitution != '' ) textDateStartCntrll.text = soCreditRequest.dateStartInstitution;
          if(soCreditRequest.dateEndInstitution != '' ) textDateEndCntrll.text = soCreditRequest.dateEndInstitution;
          if(soCreditRequest.educationalInstitutionType == SoCreditRequest.INSTITUTION_TYPE_INTERNATIONAL){
            setState(() {
              institutionType = soCreditRequest.educationalInstitutionType;
            });
          }
        }
      });

      fetchCustomerDetail(idCustomer.toString()).then((value) {
        if(value){
          textInstitutionCntrll.text = soCustomerDetail.institution;
          textLocationCntrll.text = soCustomerDetail.location;
          textPeriodCntrll.text = soCustomerDetail.period;
          textDegreeCntrll.text = soCustomerDetail.degreeObtained;
          idCustomer = soCustomerDetail.customerId;
        }
      });
      fetchCreditRequestDetail(soCreditRequest.id.toString()).then((value) {
        if(value){
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
      rolePreliminar = SoCreditRequestGuarantee.ROLE_ACREDITED_HOLDER;
      relation = SoCreditRequestGuarantee.RELATION_ACCREDITED;
    }else{
      creditDestiny = 'D';
      rolePreliminar = SoCreditRequestGuarantee.ROLE_ACREDITED_HOLDER;
      relation = SoCreditRequestGuarantee.RELATION_ACCREDITED;
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
      if(institutionType == SoCreditRequest.INSTITUTION_TYPE_INTERNATIONAL)
      AuthListBackground(child: formCrqd()),
      AuthListBackground(child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: CreditRequestGuarantee(forceFilter: soCreditRequest.id),
      )),
      AuthListBackground(child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: ChatPrueba(forceFilter: soCreditRequest.wFlowId),
      ),),
    ];

    //Iconos para barra de navegación inferior
    final _crqsBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_sharp), label: 'Solicitud'),
      if(institutionType == SoCreditRequest.INSTITUTION_TYPE_INTERNATIONAL)
        const BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active), label: 'Detalles'),
      const BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Avales'),
      const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
    ];

    //Bottom navigation bar
    final bottomNavBar = BottomNavigationBar(
      items: _crqsBottmonNavBarItems,
      unselectedItemColor: Colors.grey,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if(soCreditRequest.id > 0){
          setState(() {
            _currentTabIndex = index;
          });
        }else{
          Fluttertoast.showToast(msg: 'Complete el paso 1 para poder registrar avales.');
        }
      },
    );

   return Scaffold(
     appBar: AppBarStyle.authAppBarFlex(title: 'Solicitud de Crédito'),
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
        if(_formKeyCrqs.currentState!.validate()){
          addCreditRequest().then((value) {
            if(value){setState(() {
              _activeStepIndex += 1;
              sendingData = false;
              });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Datos actualizados correctamente')),
            );
            }else{setState(() {
              sendingData = false;
            });return false;}
          });
        }else{
          return false;
        }
        break;
      case 1:
        if(_formKeyCrqs2.currentState!.validate()){
          //Se guardan datos de solicitud de crédito
          addCreditRequest().then((value) {
            if(value){
              setState(() {
                sendingData = false;
                _activeStepIndex += 1;
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
           addCustomerDetail().then((value) {
            if(value){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Datos actualizados correctamente')),
              );
              setState(() {
                sendingData = false;
                _activeStepIndex += 1;
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
/*
                  const SizedBox( height: 10 ),
                  const Text('Solicitud de Credito', style: TextStyle(color: Colors.grey, fontSize: 20)),*/
                  const SizedBox( height: 10 ),
                  DropdownWidget(
                    callback: (String id) {
                      setState(() {
                        currencyId = int.parse(id);
                      });
                    },
                    programCode: 'CURE',
                    label: 'Divisa',
                    dropdownValue: currencyId.toString(),
                  ),
                  const SizedBox( height: 10 ),
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
                    validator: ( value ) {
                      final intNumber = double.tryParse(value!.replaceAll(',', ''));
                      return (intNumber != null && intNumber > 9999.99)
                          ? null
                          : 'Por favor ingrese un monto valido';
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
                  if(sendingData)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 30,)
                ])
            ),
          ),
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
                        items: SoCreditRequest.getInstitutionType.map((e) {
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
                      : 'Por favor ingrese una fecha valida';
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
                      : 'Por favor ingrese una fecha valida';
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
                if(sendingData)
                  const LinearProgressIndicator(),
                const SizedBox(height: 30,)
              ])
          ),
        )
    );
  }

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
                            : 'Por favor ingrese una fecha valida';
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
                    forceFilter: soCreditRequest.id
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

  //Petición de datos de detalles del cliente parametro id del cliente
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
    soCreditRequestDetail = SoCreditRequestDetail.fromJson(jsonDecode(response.body));
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
    //Si no hay errores se guarda el obejto devuelto
    soCreditRequestGuarantee = SoCreditRequestGuarantee.fromJson(jsonDecode(response.body));
    return true;
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
    soCreditRequest= SoCreditRequest.fromJson(jsonDecode(response.body));
    return true;
  }

  // Actualiza la solicitud de credito en el servidor
  Future<bool> addCreditRequest() async {
    soCreditRequest.customerId = idCustomer;
    soCreditRequest.amountRequired = textMontoCntrll.numberValue;
    soCreditRequest.destiny = creditDestiny;
    soCreditRequest.deadlineRequired = monthSelected;
    soCreditRequest.monthlyPayment = textPagoMonthCntrll.numberValue;
    soCreditRequest.currencyId = currencyId;
    soCreditRequest.creditTypeId = creditTypeId;
    soCreditRequest.creditProfileId = creditProfileId;
    soCreditRequest.educationalInstitution = textEducationalInstitutionCntrll.text;
    soCreditRequest.educationalInstitutionType = institutionType;
    soCreditRequest.dateStartInstitution = textDateStartCntrll.text;
    soCreditRequest.dateEndInstitution = textDateEndCntrll.text;

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

      // Si fue exitoso obtiene la respuesta
      soCreditRequest = SoCreditRequest.fromJson(jsonDecode(response.body));

      // Muestra mensaje
     /* ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados correctamente')),
      );*/
      return true;
    } else {
      errorMsg = response.body.toString();
      // Error al guardar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ${response.body}')),
      );
      return false;
    }
  }

  // Actualiza el customer en el servidor
  Future<bool> addCustomerDetail() async {
    soCustomerDetail.institution = textInstitutionCntrll.text;
    soCustomerDetail.location = textLocationCntrll.text;
    soCustomerDetail.period = textPeriodCntrll.text;
    soCustomerDetail.degreeObtained = textDegreeCntrll.text;
    soCustomerDetail.customerId = idCustomer;

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
  }

  // Actualiza la solicitud de credito detalle en el servidor
  Future<bool> addCreditRequestDetail() async {
    soCreditRequestDetail.creditRequestId = soCreditRequest.id;
    // soCreditRequestDetail.verifiableIncome = verifiableIncome;
    //si es institución internacional
    if(institutionType != SoCreditRequest.INSTITUTION_TYPE_INTERNATIONAL){
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

      // Si fue exitoso obtiene la respuesta
      soCreditRequestDetail = SoCreditRequestDetail.fromJson(jsonDecode(response.body));

      // Muestra mensaje
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Datos actualizados correctamente')),
      // );
      return true;
    } else {
      errorMsg = response.body.toString();
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
    soCustomer = SoCustomer.fromJson(jsonDecode(response.body));
    return true;
  }
}



import 'dart:convert';

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

import '../models/crqs.dart';
import '../routes/app_routes.dart';
import '../ui/appbar_flexwm.dart';
import '../ui/input_decorations.dart';
import '../widgets/card_container.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/show_image.dart';
import '../widgets/upload_file_widget.dart';
import '../widgets/upload_id_photo_widget.dart';

class CreditRequestGuarateeForm extends StatefulWidget{
  //Se recibe objeto para el fomulario
  final SoCreditRequestGuarantee soCreditRequestGuarantee;
  final int creditRequestId;
  const CreditRequestGuarateeForm({Key? key,
    required this.soCreditRequestGuarantee,
    required this.creditRequestId}) : super(key: key);

  @override
  State<CreditRequestGuarateeForm> createState() => _CreditRequestGuarateeFormState();
}

class _CreditRequestGuarateeFormState extends State<CreditRequestGuarateeForm>{
  //datos de aval/cliente
  SoCustomer soCustomer = SoCustomer.empty();
  //Se crean controllers para asignar valores en campos generales de aval
  late String role = SoCreditRequestGuarantee.ROLE_COACREDITED;
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
  final _formAssets = GlobalKey<FormState>();

  //key para el formulario
  final _formKey = GlobalKey<FormState>();
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
  //bandera para editar campos de aval
  bool isSameGuarantee = false;

  @override
  void initState(){
    if(widget.soCreditRequestGuarantee.id > 0 ){
      creditRequestGuaranteeId = widget.soCreditRequestGuarantee.id;
      avalCreated = true;
      soCreditRequestGuarantee = widget.soCreditRequestGuarantee;
      if(soCreditRequestGuarantee.relation == SoCreditRequestGuarantee.RELATION_SELF){
        isSameGuarantee = true;
      }
      if(soCreditRequestGuarantee.relation != '') relation = soCreditRequestGuarantee.relation;
      // textEconomicDepCntrll.text = soCreditRequestGuarantee.economicDependents.toString();
      textTypeHousingCntrll.text = soCreditRequestGuarantee.typeHousing;
      textYearsResidenceCntrll.text = soCreditRequestGuarantee.yearsResidence.toString();
      if(soCreditRequestGuarantee.role != '') role = soCreditRequestGuarantee.role;
      soCustomer = soCreditRequestGuarantee.soCustomer;
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
        if(soCreditRequestGuarantee.economicDependents > 0) textEconomicDepCntrll.text = soCreditRequestGuarantee.economicDependents.toString();
        if(soCreditRequestGuarantee.employmentStatus != '') employmentStatus = soCreditRequestGuarantee.employmentStatus;
        if(soCreditRequestGuarantee.company != '') textCompanyCntrll.text = soCreditRequestGuarantee.company;
        if(soCreditRequestGuarantee.economicActivity != '')textEconomicActCntrll.text = soCreditRequestGuarantee.economicActivity;
        if(soCreditRequestGuarantee.yearsEmployment > 0)textYearsEmploymentCntrll.text = soCreditRequestGuarantee.yearsEmployment.toString();
        if(soCreditRequestGuarantee.creditCards > 0.0)textCreditCardsCntrll.updateValue(soCreditRequestGuarantee.creditCards);
        if(soCreditRequestGuarantee.rent > 0.0)textRentCntrll.updateValue(soCreditRequestGuarantee.rent);
        if(soCreditRequestGuarantee.creditAutomotive > 0.0)textCreditAutomotiveCntrll.updateValue(soCreditRequestGuarantee.creditAutomotive);
        if(soCreditRequestGuarantee.creditFurniture > 0.0)textCreditFurniturCntrll.updateValue(soCreditRequestGuarantee.creditFurniture);
        if(soCreditRequestGuarantee.personalLoans > 0.0)textPersonalLoansCntrll.updateValue(soCreditRequestGuarantee.personalLoans);
        if(soCreditRequestGuarantee.ciec != '') textCiecCntrll.text = soCreditRequestGuarantee.ciec;
      }else{
      maritalStatus = SoCreditRequestGuarantee.STATUS_SINGLE;
      regimenMarital = SoCreditRequestGuarantee.REGIMEN_CONJUGAL_SOCIETY;
      relation = SoCreditRequestGuarantee.RELATION_SELF;
      role = SoCreditRequestGuarantee.ROLE_ACREDITED;
      soCreditRequestGuarantee.customerId = params.idLoggedUser;
      soCreditRequestGuarantee.creditRequestId = widget.creditRequestId;
    }
    super.initState();
  }

  //navbar bottom
  int _currentTabIndex = 0;
  //titulos de cada tab
  String title = 'Aval';
  //indicador de envio de datos
  bool sendingData = false;

  @override
  Widget build(BuildContext context) {

    //Lista de widgets para la seleccion del tab
    final _crqgTabPages = <Widget>[
      AuthListBackground(child: formDatosGenerales()),
      AuthListBackground(child: avalCreated ?formDatosFinancieros() :noSponsor()),
      AuthListBackground(child: avalCreated ?formDatosAdicionales() :noSponsor()),
      AuthListBackground(child: avalCreated ?Padding(
        padding: const EdgeInsets.only(top: 50),
        child: CreditRequestAsset(soCreditRequestGuarantee: soCreditRequestGuarantee),
      ) :noSponsor()),
    ];

    //Botones de barra de navegación inferior
    final _crqgBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Generales'),
      const BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'Financieros'),
      const BottomNavigationBarItem(icon: Icon(Icons.document_scanner_outlined), label: 'Documentos'),
      const BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Garantias'),
    ];


    final _tabsAppbar = <Tab>[
      const Tab(icon: Icon(Icons.account_circle_outlined), text: 'Generales'),
      const Tab(icon: Icon(Icons.account_balance), text: 'Financieros'),
      const Tab(icon: Icon(Icons.document_scanner_outlined), text: 'Documentos'),
      const Tab(icon: Icon(Icons.health_and_safety), text: 'Garantias'),
    ];

    //Bottom navigation bar
    final bottomNavBar = BottomNavigationBar(
      items: _crqgBottmonNavBarItems,
      unselectedItemColor: Colors.grey,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if(soCreditRequestGuarantee.id > 0){
          setState(() {
            _currentTabIndex = index;
          });
        }else{
          Fluttertoast.showToast(msg: 'Complete los datos iniciales del aval.');
        }
      },
    );


    return DefaultTabController(
      length: _tabsAppbar.length,
      child: Scaffold(
        appBar: AppBarStyle.authAppBarFlex(title: title,tabs: TabBar(tabs: _tabsAppbar)),
        body: AuthFormBackground(
            child: TabBarView(children: _crqgTabPages)
        ),
        // bottomNavigationBar: bottomNavBar,
      ),
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

  Widget formDatosFinancieros(){
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40,),
          CardContainer(
            child: Form(
              child: Column(
                children: [
                  const Text("Ingresos Promedio Mensuales"),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: 'Ingresos Comprobables?*',
                        prefixIcon: Icons.monetization_on_outlined),
                    controller: textVerifiableIncomeCntrll,
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
                        labelText: 'Estados de Cuenta*',
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
                        labelText: 'Recibos de Nómina*',
                        prefixIcon: Icons.monetization_on_outlined),
                    controller: textPayrollReceiptsCntrll,
                    validator: ( value ) {
                      return ( value != null && value.isNotEmpty )
                          ? null
                          : 'Por favor ingrese un valor';
                    },
                  ),
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
                        labelText: 'Patrimonio*',
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
                        labelText: 'Dependientes Económicos*',
                        prefixIcon: Icons.business_sharp),
                    controller: textEconomicDepCntrll,
                    validator: ( value ) {
                      final intNumber = int.tryParse(value!);
                      return (intNumber != null && value.length > 0)
                          ? null
                          : 'Por favor ingrese un número válido';
                    },
                  ),
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
                        labelText: 'Años en el empleo*',
                        prefixIcon: Icons.timer_outlined),
                    controller: textYearsEmploymentCntrll,
                    validator: ( value ) {
                      final intNumber = int.tryParse(value!);
                      return (intNumber != null && value.length > 0)
                          ? null
                          : 'Por favor ingrese un número válido';
                    },
                  ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
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
            ),
          ),
          const SizedBox(height: 50,),
        ],
      ),
    );
  }

  Widget formDatosAdicionales(){
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40,),
          CardContainer(
            child: Form(
                child:Column(
                  children: [
                    UploadIdPhoto(
                      key: _keyUploadIdentification,
                      initialRuta: soCreditRequestGuarantee.identification,
                        programCode: SoCreditRequestGuarantee.programCode,
                        fielName: 'crqg_identification',
                        label: 'Identificación parte frontal',
                        id: soCreditRequestGuarantee.id.toString(),
                        callBack: updateDataCrqg,),
                    UploadIdPhoto(
                      key: _keyUploadIdentificationBack,
                      initialRuta: soCreditRequestGuarantee.identificationBack,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_identificationback',
                      label: 'Identificación parte trasera',
                      id: soCreditRequestGuarantee.id.toString(),
                      callBack: updateDataCrqg,),
                    UploadFile(
                      key: _keyUploadProofIncome,
                      initialRuta: soCreditRequestGuarantee.proofIncome,
                        programCode: SoCreditRequestGuarantee.programCode,
                        fielName: 'crqg_proofincome',
                        label: 'Comprobante de Ingresos',
                        id: soCreditRequestGuarantee.id.toString(),
                      callBack: updateDataCrqg,),
                    UploadFile(
                      key: _keyUploadFiscalSituation,
                      initialRuta: soCreditRequestGuarantee.fiscalSituation,
                        programCode: SoCreditRequestGuarantee.programCode,
                        fielName: 'crqg_fiscalsituation',
                        label: 'Constancia de Situación Fiscal',
                        id: soCreditRequestGuarantee.id.toString(),
                      callBack: updateDataCrqg,),
                    UploadFile(
                      key: _keyUploadVerifiableIncome,
                      initialRuta: soCreditRequestGuarantee.verifiableIncomeFile,
                        programCode: SoCreditRequestGuarantee.programCode,
                        fielName: 'crqg_verifiableincomefile',
                        label: 'Otros Ingresos Comprobables',
                        id: soCreditRequestGuarantee.id.toString(),
                        callBack: updateDataCrqg,
                      ),
                    UploadFile(
                      key: _keyUploadDeclaratory,
                      initialRuta: soCreditRequestGuarantee.declaratory,
                        programCode: SoCreditRequestGuarantee.programCode,
                        fielName: 'crqg_declaratory',
                        label: 'Declaratorias',
                        id: soCreditRequestGuarantee.id.toString(),
                      callBack: updateDataCrqg,),
                    UploadFile(
                      key: _keyUploadProofAddress,
                      initialRuta: soCreditRequestGuarantee.proofAddress,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_proofaddress',
                      label: 'Comprobante de Domicilio',
                      id: soCreditRequestGuarantee.id.toString(),
                      callBack: updateDataCrqg,),
                    UploadFile(
                      key: _keyUploadIdentityVideo,
                      initialRuta: soCreditRequestGuarantee.identityVideo,
                      programCode: SoCreditRequestGuarantee.programCode,
                      fielName: 'crqg_identityvideo',
                      label: 'Video de Identidad',
                      id: soCreditRequestGuarantee.id.toString(),
                      callBack: updateDataCrqg,),
                    const SizedBox(width: 10,),
                  ],
                )
            ),
          ),
          const SizedBox(height: 50,),
        ],
      ),
    );
  }

  Widget formDatosGenerales(){
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40,),
          CardContainer(
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                                "Rol preliminar del crédito",
                                style: TextStyle(color: Colors.grey, fontSize: 15),
                              )),
                          if(!isSameGuarantee)
                          DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              child: DropdownButton(
                                value: role,
                                items: SoCreditRequestGuarantee.getRoleOptions.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['label']),
                                    value: e['value'],
                                  );
                                }).toList(),
                                onChanged: (Object? value) {
                                  setState(() {
                                    role = '$value';
                                  });
                                },
                              ),
                            ),
                          ),
                          if(isSameGuarantee)
                           Expanded(
                              child: Text(
                                SoCreditRequestGuarantee.getLabelRol(role),
                                style: const TextStyle(color: Colors.grey, fontSize: 15),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                                "Relación con el estudiante",
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
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: isSameGuarantee,
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        controller: textFisrtNameCntrll,
                        decoration: InputDecorations.authInputDecoration(
                            labelText: "Nombre",
                            prefixIcon: Icons.account_circle_outlined),
                        validator: (value) {
                          return (value != null && value.isNotEmpty)
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
                            labelText: "Apellido Paterno",
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
                            labelText: "Apellido Materno",
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
                            labelText: "Fecha de Nacimiento",
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
                            labelText: 'Tel. Celular',
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
                            labelText: 'Correo electrónico',
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
                      const SizedBox(height: 10),
                      TextFormField(
                        readOnly: isSameGuarantee,
                        decoration: InputDecorations.authInputDecoration(
                            labelText: 'RFC*',
                            prefixIcon: Icons.perm_identity_outlined),
                        controller: textRfcCntrll,
                        validator: (value) {
                          return (value != null && value.isNotEmpty)
                              ? null
                              : 'Por favor ingrese un rfc válido';
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: isSameGuarantee,
                        decoration: InputDecorations.authInputDecoration(
                            labelText: 'CURP*',
                            prefixIcon: Icons.perm_identity_outlined),
                        controller: textCurpCntrll,
                        validator: (value) {
                          return (value != null && value.isNotEmpty && value.length > 17)
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
                          if(!isSameGuarantee)
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
                          if(isSameGuarantee)
                          Expanded(
                              child: Text(
                                SoCustomer.getLabelStatus(maritalStatus),
                                style: const TextStyle(color: Colors.grey, fontSize: 15),
                              )),
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
                          if(!isSameGuarantee)
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
                          if(isSameGuarantee)
                          Expanded(
                              child: Text(
                                SoCustomer.getLabelRegimen(regimenMarital),
                                style: const TextStyle(color: Colors.grey, fontSize: 15),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if(maritalStatus == SoCustomer.MARITALSTATUS_MARRIED)
                        TextFormField(
                          readOnly: isSameGuarantee,
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
                      TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        controller: textCiecCntrll,
                        decoration: InputDecorations.authInputDecoration(
                            labelText: "CIEC",
                            prefixIcon: Icons.account_circle_outlined),
                      ),
                      const SizedBox(height: 10,),
                      if(sendingData)
                        const LinearProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              sendingData = true;
                            });
                            addCust(context).then((value) {
                              if (value) {
                                updateCreditRequestGuarantee().then((value) {
                                  setState(() {
                                    sendingData = false;
                                  });
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(msjResponsServer)),
                                    );
                                    updateDataCrqg();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(msjResponsServer)),
                                    );
                                  }
                                });
                              } else {
                                // Error al guardar
                                Fluttertoast.showToast(msg: msjResponsServer);
                              }
                            });
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
            ),
          ),
          const SizedBox(height: 50,)
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
      soCustomer = SoCustomer.fromJson(jsonDecode(response.body));
      // Muestra mensaje

      return true;
    } else {
      setState(() {
        sendingData = false;
      });
      // Muestra mensaje
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
    if(textEconomicDepCntrll.text != '')soCreditRequestGuarantee.economicDependents = int.parse(textEconomicDepCntrll.text);
    soCreditRequestGuarantee.typeHousing = textTypeHousingCntrll.text;

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
        creditRequestGuaranteeId = soCreditRequestGuarantee.id;
      });
      // Muestra mensaje
/*      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado')),
      );*/
      return true;
    } else {
      msjError = response.body.toString();
      // Error al guardar
/*      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al Guardar')),
      );*/
      return false;
    }
  }

  //funcion para actualizar widget hijo mediante el callback (uploadfile)
  updateDataCrqg(){
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

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      Navigator.pushNamed(context, AppRoutes.initialRoute);
    }

    setState((){
      soCreditRequestGuarantee = SoCreditRequestGuarantee.fromJson(jsonDecode(response.body));
    });
    return true;
  }

}

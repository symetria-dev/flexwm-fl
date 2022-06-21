

import 'package:flexwm/models/cust.dart';
import 'package:flutter/material.dart';

class CustFormProvider extends ChangeNotifier{

  final formGrlKey = GlobalKey<FormState>();

  final firstFormKey = GlobalKey<FormState>();
  final secondFormKey = GlobalKey<FormState>();

  String customerType = '';
  String customerTypeName = '';
  String? displayName = '';
  String? legalName = '';
  String firstName = '';
  String fatherLastName = '';
  String email = '';
  int salesManId = 0;
  String salesManName = '';

  String? nss = '';
  String? stablishMentDate = '';
  int referralId = 0;
  String? referralComments = '';
  String phone = '';
  String referralLabel = '';

  String birthdate = "";
  String passw = "";
  String passwconf = "";

  void vaciar(){
    print("Vaciando");
    customerType = '';
    customerTypeName = '';
    displayName = '';
    legalName = '';
    firstName = '';
    fatherLastName = '';
    email = '';
    salesManId = 0;
    nss = '';
    stablishMentDate = '';
    referralId = 0;
    referralComments = '';
    phone = '';
    referralLabel = '';

    birthdate = "";
    passw = "";
    passwconf = "";
  }

  final List<SoCustType> custTypeList = <SoCustType>[
    SoCustType('P', 'Persona','person_outline'),
    SoCustType('C', 'Empresa','business_outlined')
  ];

  final List<SoCustLead> custLeadList = <SoCustLead>[
    SoCustLead(1, 'Revista'),
    SoCustLead(3, 'Web'),
    SoCustLead(11, 'TECH')
  ];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm(){
    print(customerType+' $salesManId '+firstName+' '+fatherLastName+' '+
        email+' $referralId');
    if(customerType != '' && salesManId > 0 && firstName != '' && fatherLastName != '' &&
        email != ''){
      return true;
    }else{
      return false;
    }
  }

  bool isValidFirstForm(){
    return firstFormKey.currentState?.validate() ?? false;
  }

  bool isValidSecondForm(){
    return secondFormKey.currentState?.validate() ?? false;
  }

}
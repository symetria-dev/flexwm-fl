// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

// Modelo de clase Customer
import 'package:flutter/material.dart';

class SoCustomer {
  static const String programCode = 'CUST';

  static const String TYPE_PERSON = 'P';
  static const String TYPE_COMPANY = 'C';

  //Regimen conyugal
  static const REGIMEN_CONJUGAL_SOCIETY = 'C';
  static const REGIMEN_SEPARATION_PROPERTY = 'S';
  static const REGIMEN_MIXED_REGIMEN = 'M';

  int id = -1;
  String code = '';
  String displayName = '';
  String legalName = '';
  String logo = '';
  String phone = '';
  String email = '';
  int referralId = 0;
  String referralComments = '';

  String customerType = '';
  String rfc = '';
  String firstName = '';
  String fatherLastName = '';
  int salesManId = 0;
  String nss = '';
  String stablishMentDate = '';

  String birthdate = "";
  String passw = "";
  String passwconf = "";

  String curp = "";

  int recommendedBy =0;
  String motherlastname = "";
  int maritalStatusId = 0;
  String mobile = "";
  String maritalRegimen = '';
  int creditBureau = 0;

  static List getTypeCustomer = [
    {"value": TYPE_PERSON, "label": "Persona"},
    {"value": TYPE_COMPANY, "label": "Empresa"},
  ];

  SoCustomer.empty();

  SoCustomer(this.id, this.code, this.displayName, this.legalName, this.logo,
      this.phone, this.email, this.referralId, this.referralComments
      ,this.customerType,this.rfc,this.firstName,this.fatherLastName,
      this.salesManId,this.nss,this.stablishMentDate, this.birthdate
      ,this.passw, this.passwconf, this.curp,this.recommendedBy,this.motherlastname,
      this.maritalStatusId,this.mobile, this.maritalRegimen, this.creditBureau);

  factory SoCustomer.fromJson(Map<String, dynamic> json) {
    return SoCustomer(json['id'] as int,
        json['code'] as String,
        json['displayName'] as String,
        json['legalName'] as String,
        json['logo'] as String,
        json['phone'] as String,
        json['email'] as String,
        json['referralId'] as int,
        json['referralComments'] as String,
        json['customerType'] as String,
        json['rfc'] as String,
        json['firstName'] as String,
        json['fatherLastName'] as String,
        json['salesManId'] as int,
        json['nss'] as String,
        json['stablishMentDate'] as String,

        json['birthdate'] as String,
        json['passw'] as String,
        json['passwconf'] as String,

        json['curp'] as String,
        json['recommendedBy'] as int,
        json['motherlastname'] as String,
        json['maritalStatusId'] as int,
        json['mobile'] as String,
      json['maritalRegimen'] as String,
      json['creditBureau'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'displayName': displayName,
      'legalName': legalName,
      'logo': logo,
      'phone': phone,
      'email': email,
      'referralId': referralId,
      'referralComments': referralComments,
      'customerType' : customerType,
      'rfc' : rfc,
      'firstName' : firstName,
      'fatherLastName' : fatherLastName,
      'salesManId' : salesManId,
      'nss' : nss,
      'stablishMentDate' : stablishMentDate,
      'birthdate' : birthdate,
      'passw' : passw,
      'passwconf' : passwconf,
      'curp' : curp,
      'recommendedBy' : recommendedBy,
      'motherlastname' : motherlastname,
      'maritalStatusId' : maritalStatusId,
      'mobile' : mobile,
      'maritalRegimen' : maritalRegimen,
      'creditBureau' : creditBureau,
    };
  }
}

class SoCustType {
  String value = '';
  String label = '';
  String icon = '';

  SoCustType.empty();

  SoCustType(this.value,this.label,this.icon);

}

class SoCustLead {
  int value = 0;
  String label = '';

  SoCustLead.empty();

  SoCustLead(this.value,this.label);

}

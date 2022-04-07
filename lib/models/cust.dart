// FlexWM-FL Derechos Reservados 2022
// Este software es propiedad de Mauricio Lopez Barba y Alonso Ibarra Barba
// No puede ser utilizado, distribuido, copiado sin autorizacion expresa por escrito.

// Modelo de clase Customer
class SoCustomer {
  static const String programCode = 'CUST';

  int id = -1;
  String code = '';
  String displayName = '';
  String legalName = '';
  String logo = '';
  String phone = '';
  String email = '';
  int referralId = 0;
  String referralComments = '';

  SoCustomer.empty();

  SoCustomer(this.id, this.code, this.displayName, this.legalName, this.logo,
      this.phone, this.email, this.referralId, this.referralComments);

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
    };
  }
}
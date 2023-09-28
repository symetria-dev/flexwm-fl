class SoOderCreditItem {
  static const String programCode = 'ORCI';
  int id = -1;
  String name = "";
  String description = "";
  String type = "";
  String calc = "";
  String paymentForm = "";
  String status = "";
  double amount = 0.0;
  int taxApplies = 0;
  double taxAmount = 0.0;
  double total = 0.0;
  double disbursement = 0.0;
  int periods = 0;
  int startPeriod = 0;
  double prepayment = 0.0;
  int sequence = 0;
  String startDate = "";
  String endDate = "";
  double startBalance = 0.0;
  double endBalance = 0.0;
  double principal = 0.0;
  double taxPrincipal = 0.0;
  double rate = 0.0;
  double interest = 0.0;
  double taxInterest = 0.0;
  double expenseNotTaxableAmount = 0.0;
  double expenseTaxableAmount = 0.0;
  double expenseAmount = 0.0;
  double insuranceNotTaxableAmount = 0.0;
  double insuranceTaxableAmount = 0.0;
  double insuranceAmount = 0.0;
  String prepayEffect = "";
  double totalPaid = 0.0;
  double paymentBalance = 0.0;
  double accesoriesPayments = 0.0;
  double principalPayments = 0.0;
  double netDisbursement = 0.0;
  double totalDisbursed = 0.0;
  double pendingDisbursed = 0.0;
  int accountId = 0;
  int raccountId = 0;
  int creditInsuranceId = 0;
  int creditFeeId = 0;
  int orderCreditId = 0;

  SoOderCreditItem.empty();

  SoOderCreditItem(this.id,this.name,this.description,this.type,this.calc,this.paymentForm,this.status,this.amount,
      this.taxApplies,this.taxAmount,this.total,this.disbursement,this.periods,this.startPeriod,this.prepayment,this.sequence,
      this.startDate,this.endDate,this.startBalance,this.endBalance,this.principal,this.taxPrincipal,this.rate,this.interest,
      this.taxInterest,this.expenseNotTaxableAmount,this.expenseTaxableAmount,this.expenseAmount,this.insuranceNotTaxableAmount,
      this.insuranceTaxableAmount,this.insuranceAmount,this.prepayEffect,this.totalPaid,this.paymentBalance,this.accesoriesPayments,
      this.principalPayments,this.netDisbursement,this.totalDisbursed,this.pendingDisbursed,this.accountId,this.raccountId,
      this.creditInsuranceId,this.creditFeeId,this.orderCreditId);

  factory SoOderCreditItem.fromJson(Map<String, dynamic> json){
    return SoOderCreditItem(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      json['type'] as String,
      json['calc'] as String,
      json['paymentForm'] as String,
      json['status'] as String,
      json['amount'] as double,
      json['taxApplies'] as int,
      json['taxAmount'] as double,
      json['total'] as double,
      json['disbursement'] as double,
      json['periods'] as int,
      json['startPeriod'] as int,
      json['prepayment'] as double,
      json['sequence'] as int,
      json['startDate'] as String,
      json['endDate'] as String,
      json['startBalance'] as double,
      json['endBalance'] as double,
      json['principal'] as double,
      json['taxPrincipal'] as double,
      json['rate'] as double,
      json['interest'] as double,
      json['taxInterest'] as double,
      json['expenseNotTaxableAmount'] as double,
      json['expenseTaxableAmount'] as double,
      json['expenseAmount'] as double,
      json['insuranceNotTaxableAmount'] as double,
      json['insuranceTaxableAmount'] as double,
      json['insuranceAmount'] as double,
      json['prepayEffect'] as String,
      json['totalPaid'] as double,
      json['paymentBalance'] as double,
      json['accesoriesPayments'] as double,
      json['principalPayments'] as double,
      json['netDisbursement'] as double,
      json['totalDisbursed'] as double,
      json['pendingDisbursed'] as double,
      json['accountId'] as int,
      json['raccountId'] as int,
      json['creditInsuranceId'] as int,
      json['creditFeeId'] as int,
      json['orderCreditId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'description' : description,
      'type' : type,
      'calc' : calc,
      'paymentForm' : paymentForm,
      'status' : status,
      'amount' : amount,
      'taxApplies' : taxApplies,
      'taxAmount' : taxAmount,
      'total' : total,
      'disbursement' : disbursement,
      'periods' : periods,
      'startPeriod' : startPeriod,
      'prepayment' : prepayment,
      'sequence' : sequence,
      'startDate' : startDate,
      'endDate' : endDate,
      'startBalance' : startBalance,
      'endBalance' : endBalance,
      'principal' : principal,
      'taxPrincipal' : taxPrincipal,
      'rate' : rate,
      'interest' : interest,
      'taxInterest' : taxInterest,
      'expenseNotTaxableAmount' : expenseNotTaxableAmount,
      'expenseTaxableAmount' : expenseTaxableAmount,
      'expenseAmount' : expenseAmount,
      'insuranceNotTaxableAmount' : insuranceNotTaxableAmount,
      'insuranceTaxableAmount' : insuranceTaxableAmount,
      'insuranceAmount' : insuranceAmount,
      'prepayEffect' : prepayEffect,
      'totalPaid' : totalPaid,
      'paymentBalance' : paymentBalance,
      'accesoriesPayments' : accesoriesPayments,
      'principalPayments' : principalPayments,
      'netDisbursement' : netDisbursement,
      'totalDisbursed' : totalDisbursed,
      'pendingDisbursed' : pendingDisbursed,
      'accountId' : accountId,
      'raccountId' : raccountId,
      'creditInsuranceId' : creditInsuranceId,
      'creditFeeId' : creditFeeId,
      'orderCreditId' : orderCreditId,
    };
  }
}
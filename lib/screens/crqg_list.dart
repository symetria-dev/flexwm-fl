
import 'package:flexwm/models/crqs.dart';
import 'package:flexwm/screens/crqg_screen.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flutter/material.dart';

class CreditRequestGuaranteeList extends StatefulWidget{
  final SoCreditRequest soCreditRequest;
  const CreditRequestGuaranteeList({Key? key, required this.soCreditRequest}) : super (key: key);

  @override
  _CreditRequestGuaranteeList createState(){
    return _CreditRequestGuaranteeList();
  }
}

class _CreditRequestGuaranteeList extends State<CreditRequestGuaranteeList>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStyle.authAppBarFlex(title: 'Sponsors Solicitud ${widget.soCreditRequest.id}'),
      body: CreditRequestGuarantee(forceFilter: widget.soCreditRequest.id),
    );
  }

}
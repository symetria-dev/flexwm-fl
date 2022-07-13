import 'package:flutter/material.dart';

class CardStepContainer extends StatelessWidget {

  final Widget child;

  const CardStepContainer({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 5,),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all( 10 ),
        decoration: _createCardShape(),
        child: this.child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 15,
          offset: Offset(0, 5),
        )
      ]
  );
}
import 'dart:math';

import 'package:flutter/material.dart';

class AuthListBackground extends StatelessWidget {
  
  final Widget child;

  const AuthListBackground({
    Key? key, 
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            _PurpleBox(),

            this.child,

          ],
        ),
    );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        // margin: const EdgeInsets.only(top: 400),
        width: double.infinity,
        height: size.height*0.9,
        decoration: _purpleBackground(),
       /* child: Stack(
          children: [
            Positioned(child: _Bubble(), top: 90, left: 30 ),
            Positioned(child: _Bubble(), top: -40, left: -30 ),
            Positioned(child: _Bubble(), top: -50, right: -20 ),
            Positioned(child: _Bubble(), bottom: -50, left: 10 ),
            Positioned(child: _Bubble(), bottom: 120, right: 20 ),
          ],
        ),*/
      ),
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
     // borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      gradient: LinearGradient(
      colors: [
        Color.fromRGBO(0, 130, 146, 1),
        Color.fromRGBO(112, 169, 179, 1.0)
        // Color.fromRGBO(21, 67, 96, 1),
        // Color.fromRGBO(171, 178, 185, 1)
      ]
    )
  );
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 40);
    path.quadraticBezierTo(
        size.width / 4, 5 /*180*/, size.width / 2, 20);
    path.quadraticBezierTo(
        (size.width/2)*1.5, 30, size.width, 0);
    // path.lineTo(size.width*2, 0);
     path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _Bubble extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
  }
}
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class AuthFormBackground extends StatelessWidget {
  
  final Widget child;

  const AuthFormBackground({
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
            _HeaderIcon(),

            this.child,

          ],
        ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only( top: 15),
          child: const Flexible(
            child: Text('Registro de Clientes', style: TextStyle(fontSize: 23,color: Colors.white),),
          ),
        ),
      ),
    );
  }
}


class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 400),
      child: Transform(
        transform: Matrix4.rotationZ(pi),
        alignment: Alignment.center,
        child: ClipPath(
          clipper: MyClipper(),
          child: Container(
            // margin: const EdgeInsets.only(top: 400),
            width: double.infinity,
            height: size.height*0.9,
            decoration: _purpleBackground(),
            child: Stack(
              children: [
                Positioned(child: _Bubble(), top: 90, left: 30 ),
                Positioned(child: _Bubble(), top: -40, left: -30 ),
                Positioned(child: _Bubble(), top: -50, right: -20 ),
                Positioned(child: _Bubble(), bottom: -50, left: 10 ),
                Positioned(child: _Bubble(), bottom: 120, right: 20 ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
     borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
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
    path.lineTo(0, 220);
    path.quadraticBezierTo(
        size.width / 4, 160 /*180*/, size.width / 2, 175);
    path.quadraticBezierTo(
        3 / 4 * size.width, 190, size.width, 130);
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
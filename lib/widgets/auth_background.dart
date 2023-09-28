import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

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
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 40),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Image.asset('images/logo1.png'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 400),
      width: double.infinity,
      height: double.infinity,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(child: _Bubble(), top: 90, left: 30),
          Positioned(child: _Bubble(), top: -40, left: -30),
          Positioned(child: _Bubble(), top: -50, right: -20),
          Positioned(child: _Bubble(), bottom: -50, left: 10),
          Positioned(child: _Bubble(), bottom: 120, right: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Opacity(opacity: 0.5, child: Text('Powered by FlexWM')),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            'images/icon-black.png',
                            height: 30,
                          )))
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              const SizedBox(
                height: 10,
              )
            ],
          )
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
      // color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      gradient: LinearGradient(colors: params.theme));
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}

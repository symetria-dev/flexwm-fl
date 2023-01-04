import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;

class AuthUpBackground extends StatelessWidget {
  
  final Widget child;

  const AuthUpBackground({
    Key? key, 
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              this.child,
              _PurpleBox(),
              _HeaderIcon(),
            ],
          ),
        ),
    );
  }
}

Widget noListWidget(){
  return Padding(
    padding: const EdgeInsets.only(top: 70,bottom: 0.8,left: 5, right: 5),
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                gradient: LinearGradient(
                    begin: AlignmentDirectional.topEnd,
                    end: AlignmentDirectional.bottomEnd,
                    colors: params.theme,
                )
            ),
            child: SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: Image.asset(
                        'images/logoEduPass.png',
                        fit: BoxFit.fitWidth,
                        color: Colors.white,
                      )
                  ),
                  const Positioned(
                      bottom: 6,
                      left: 16,
                      right: 16,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'La mejor garantía para pedir un crédito educativo.',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
          ListTile(
            onTap: () => {},
            leading:
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.monetization_on_outlined, color: Colors.teal,),
            ),
            title: const Text('Solicitar nuevo crédito'),
            subtitle: const Text('Haz clic aquí para solicitar un crédito con la garantía de Edupass'),
            trailing: const Icon(Icons.add_circle_outline, color: Colors.green,),
          ),const SizedBox(height: 10,)
        ],
      ),
    ),
  );
}

class _HeaderIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only( top: 25),
        child: Row(
          children: [
            // const SizedBox(width: 35,),

            Flexible(
              child:Image.asset('images/logoEduPass.png'),
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
      width: double.infinity,
      height: size.height*0.20,
      decoration: _purpleBackground(),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
    // color: Colors.white,
    //  borderRadius: BorderRadius.vertical(bottom: Radius.circular(80)),
      borderRadius: const BorderRadius.only(bottomRight: Radius.elliptical(200, 100),
          bottomLeft: Radius.elliptical(200, 100)),
      gradient: LinearGradient(
      colors: params.theme
    )
  );
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
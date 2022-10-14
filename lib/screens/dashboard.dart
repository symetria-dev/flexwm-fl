

import 'package:flexwm/drawer.dart';
import 'package:flexwm/routes/routes.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flexwm/widgets/auth_upbackground.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState(){
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard>{
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AuthUpBackground(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 180,),
                graficPie(),
                TextButton(
                    onPressed: (){},
                    child: const Text(
                      '%50 de su Crédito',
                      style: TextStyle(fontSize: 20),))
              ],
            ),
          ),
        ),
      ),
      appBar: AppBarStyle.authAppBarFlex(title: ''),
      drawer: getDrawer(context),
    );
  }
}

Widget graficPie(){
  return CircularPercentIndicator(
    radius: 130.0,
    lineWidth: 40.0,
    animation: true,
    percent: 0.5,
    center: const Icon(Icons.account_balance, size: 50,color: Colors.teal,),
    progressColor: Colors.blue,
    circularStrokeCap: CircularStrokeCap.round,
  );
}

// import 'dart:async';

// import 'package:flutter/material.dart';

// class SuccesPage extends StatefulWidget {
//   @override
//   _SuccesPageState createState() => _SuccesPageState();
// }

// class _SuccesPageState extends State<SuccesPage> {
//   // void initState() {
//   //   super.initState();
//   //   startTime();
//   // }

//   // startTime() async {
//   //   var duration = new Duration(seconds: 6);
//   //   return new Timer(duration, route);
//   // }

//   // route() {
//   //   Navigator.pushReplacementNamed(context, '/home');
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Congratulations",
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Order Placed"),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Text("Congratulations, Order Placed"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class SuccesPage extends StatefulWidget {
  @override
  _SuccesPageState createState() => _SuccesPageState();
}

class _SuccesPageState extends State<SuccesPage> {
  ConfettiController controllerTopCenter;
  @override
  void initState() {
    super.initState();
    setState(() {
      initController();
    });
    controllerTopCenter.play();
    startTime();
  }

  void initController() {
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  startTime() async {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Order Placed"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildConfettiWidget(controllerTopCenter, pi / 1),
            buildConfettiWidget(controllerTopCenter, pi / 4),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  // Image.asset(
                  //   "assets/trophy.png",
                  //   width: MediaQuery.of(context).size.width * 0.5,
                  //   height: MediaQuery.of(context).size.height * 0.5,
                  // ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(
                      "Congratulations, Your Order is placed",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.green,
                        backgroundColor: Colors.yellowAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // buildButton(),
            Center(
              child: Text(
                "Your Order Id is 12546983233",
                style: TextStyle(
                  fontSize: 20,
                  // color: Colors.green,
                  backgroundColor: Colors.yellowAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align buildConfettiWidget(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: Size(30, 30),
        shouldLoop: false,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.directional,
        maxBlastForce: 20, // set a lower max blast force
        minBlastForce: 8, // set a lower min blast force
        emissionFrequency: 1,
        numberOfParticles: 8, // a lot of particles at once
        gravity: 1,
      ),
    );
  }
}

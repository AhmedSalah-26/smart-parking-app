import 'dart:async';
import 'package:esp/w_i_f_i.dart';
import 'package:flutter/material.dart';

import 'a_p_p.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => WIFI()), // استبدل بالاسم المناسب لصفحة الواي فاي
      );
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF11998E),
              Color(0xFF38EF7D),
              Color(0xFF11998E),
              Color(0xFF11998E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Stack(

          children: [  Center(
            child: Image.asset("assets/img/1714097164685.png"),
          ),

          Align(alignment: Alignment.bottomCenter,
            child: Image.asset("assets/img/Animation - 1714097849526.gif"),)
          ],

        ),
      ),
    );
  }
}

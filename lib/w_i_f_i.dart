import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:esp/a_p_p.dart';
import 'package:google_fonts/google_fonts.dart'; // Assuming this is your main app widget

class WIFI extends StatefulWidget {
  @override
  _WIFIState createState() => _WIFIState();
}

class _WIFIState extends State<WIFI> {
  late Stream<bool> _wifiStream;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    initializeConnectivity();
  }

  Future<void> initializeConnectivity() async {
    _wifiStream = Connectivity().onConnectivityChanged.map((connectivityResult) {
      return connectivityResult != ConnectivityResult.none;
    });

    // Initial connectivity check
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<bool>(
        stream: _wifiStream,
        initialData: _isConnected, // Use the initial check result
        builder: (context, snapshot) {
          final bool isConnected = snapshot.data ?? true;
          return isConnected
              ?  SafeArea(child: ParkingPage())
              : Scaffold(
            body:SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Image.asset("assets/img/Animation - 1714099283774.gif"),
                      SizedBox(height: 20),
                      Text(
                        'No Internet Connection',
                          style: GoogleFonts.concertOne(
                            fontSize: 30,
                            color: Colors.white
                          )),
                      SizedBox(height: 20),
                      Text(
                        'Please connect to WiFi',
                          style: GoogleFonts.concertOne(
                            fontSize: 30,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

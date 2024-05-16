import 'dart:convert';
import 'package:esp/state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';


class ParkingPage extends StatefulWidget {
  @override
  _ParkingPageState createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  final databaseRef = FirebaseDatabase.instance.reference();
  bool place1 = false;
  bool place2 = false;
  bool place3 = false;
  late bool isBooked; // Maintain booked status in the state
  int timerTime = 1; // Initialize timer time
  int? bookedTime; // To store booked time from Firebase

  late DateTime lastUpdated = DateTime.now(); // Initialize lastUpdated here
  var bookData;

  @override
  void initState() {
    super.initState();
    _setupDataListeners();
    _setupBookedListeners(context); // Pass the context here
    _getBookedTime(); // Retrieve booked time from Firebase
  }

  bool place1bookd = false;
  bool place2bookd = false;
  bool place3bookd = false;
  String place1bookdtime = '';
  String place2bookdtime = '';
  String place3bookdtime = '';

  void _setupBookedListeners(BuildContext context) {
    databaseRef.child('book').onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        Map<String, dynamic> placesMap = json.decode(json.encode(data));
        setState(() {
          place1bookd = placesMap['Place A0']=="true" ? true : false;
          place2bookd = placesMap['Place A1'] =="true" ? true : false;
          place3bookd = placesMap['Place A2'] =="true" ? true : false;
        });
      }
    });
  }

  void _getBookedTime() {
    databaseRef.child('timer_time').onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        Map<String, dynamic> placesMap = json.decode(json.encode(data));
        setState(() {
          place1bookdtime = placesMap['Place A0'] ?? '';
          place2bookdtime = placesMap['Place A1'] ?? '';
          place3bookdtime = placesMap['Place A2'] ?? '';
        });
      }
    });
  }

  void _setupDataListeners() {
    databaseRef.child('places').onValue.listen((event) {
      final data = event.snapshot.value;

      Map<String, dynamic> placesMap = json.decode(json.encode(data));
      setState(() {
        place1 =  placesMap["place1"]=="true" ? true : false;
        place2 = placesMap['place2'] =="true" ? true : false;
        place3 = placesMap['place3'] =="true" ? true : false;
        lastUpdated = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int availableSpaces =
        [place1, place2, place3].where((place) => place).length;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: Image.asset("assets/img/1714097164685.png"),
        backgroundColor: Colors.transparent,
        title: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Automated parking ' , style: GoogleFonts.aladin(
              fontSize: 40,
              color: Colors.white,
            )),
          ],
        ),  ),
      body: Container(
        width: double.infinity,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("Available Spaces: $availableSpaces",
                  style: GoogleFonts.concertOne(
                    fontSize: 30,
                    color: Colors.white,
                  )),
            ),
            Expanded(
              child: AnimationLimiter(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 10.0,
                  padding: EdgeInsets.all(10.0),
                  children: <Widget>[
                    AnimationConfiguration.staggeredGrid(
                      position: 0,
                      duration: const Duration(milliseconds: 200),
                      columnCount: 2,
                      child: SlideAnimation(
                        verticalOffset: 20.0,
                        child: FadeInAnimation(
                          child: ParkingSpace(
                            available: place1,
                            placeName: "Place A0",
                            booked: place1bookd,
                            bookedTime: place1bookdtime,
                          ),
                        ),
                      ),
                    ),
                    AnimationConfiguration.staggeredGrid(
                      position: 1,
                      duration: const Duration(milliseconds: 400),
                      columnCount: 2,
                      child: SlideAnimation(
                        verticalOffset: 20.0,
                        child: FadeInAnimation(
                          child: ParkingSpace(
                            available: place2,
                            placeName: "Place A1",
                            booked: place2bookd,
                            bookedTime: place2bookdtime,
                          ),
                        ),
                      ),
                    ),
                    AnimationConfiguration.staggeredGrid(
                      position: 2,
                      duration: const Duration(milliseconds: 600),
                      columnCount: 2,
                      child: SlideAnimation(
                        verticalOffset: 20.0,
                        child: FadeInAnimation(
                          child: ParkingSpace(
                            available: place3,
                            placeName: "Place A2",
                            booked: place3bookd,
                            bookedTime: place3bookdtime,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Align(alignment: Alignment.bottomCenter,
              child: Image.asset("assets/img/Animation - 1714098316572 (2).gif"),),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Last Updated: ${lastUpdated.toString().substring(0, 16)}",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 18,
                    color: Colors.white,
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

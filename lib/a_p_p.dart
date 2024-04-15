import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(APP());
}

class APP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ParkingPage();

  }
}

class ParkingPage extends StatefulWidget {
  @override
  _ParkingPageState createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  final databaseRef = FirebaseDatabase.instance.reference();
  bool place1 = false;
  bool place2 = false;
  bool place3 = false;

  @override
  void initState() {
    super.initState();
    _setupDataListeners();
  }

  void updatePlaceAvailability(String place, bool availability) {
    databaseRef.child('places/$place').set(availability);
  }

  void _setupDataListeners() {
    databaseRef.child('places').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        Map<String, dynamic> placesMap = json.decode(json.encode(data));
        setState(() {
          place1 = placesMap["place1"];
          place2 = placesMap['place2'];
          place3 = placesMap['place3'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int availableSpaces = [place1, place2, place3].where((place) => place).length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Parking'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Text(
              "Available Spaces: $availableSpaces",
              style: TextStyle(fontSize: 20),
            ),
          ),
          ParkingSpace(available: place1, placeName: "Place1"),
          ParkingSpace(available: place2, placeName: "Place2"),
          ParkingSpace(available: place3, placeName: "Place3"),
          Container(
            child: Text(
              "Last Updated: ${DateTime.now().toString().substring(0, 16)}",
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }
}

class ParkingSpace extends StatelessWidget {
  final bool available;
  final String placeName;

  ParkingSpace({required this.available, required this.placeName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            Icon(
              Icons.directions_car,
              size: 50,
              color: available ? Colors.green : Colors.red,
            ),
            SizedBox(width: 10),
            Text(placeName, style: TextStyle(fontSize: 24)),
            SizedBox(width: 50),
            Text(available ? '   متوفر   ' : 'غير متوفر',
                style: TextStyle(fontSize: 24)),
            SizedBox(width: 50),
          ],
        ),
      ),
    );
  }
}

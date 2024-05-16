import 'package:esp/parkingProvider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'BouncingButton.dart';

class ParkingSpace extends StatefulWidget {
  final bool available;
  late final bool booked;
  final String placeName;
  final String bookedTime; // To store booked time from Firebase

  ParkingSpace({
    required this.available,
    required this.placeName,
    required this.booked,
    required this.bookedTime,
  });

  @override
  _ParkingSpaceState createState() => _ParkingSpaceState();
}

class _ParkingSpaceState extends State<ParkingSpace> {
  final databaseRef = FirebaseDatabase.instance.reference();
  late bool isBooked; // Maintain booked status in the state
  int timerTime = 0;

  @override
  void initState() {
    super.initState();
    isBooked = widget.booked;
    // Initialize isBooked with initial booked status
  }

  int get_timerTime() {

    int num =5;

    if (widget.booked) {
      // If booked, calculate the difference between current time and booked time
      DateTime bookedDateTime = DateTime.parse(widget.bookedTime);
      Duration difference = DateTime.now().difference(bookedDateTime);
      int minutesDifference = difference.inMinutes;
      // If the difference is greater than 10 minutes, set timer to 0
      if (minutesDifference > num) {
        return 0;
      } else {
        // Otherwise, return remaining minutes
        return num - minutesDifference;
      }
    } else {
      // If not booked, return 0
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final classInstance = Provider.of<ParkingProvider>(context, listen: true);
    Color spaceColor = isBooked ? Colors.yellowAccent : Colors.white;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: spaceColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.directions_car,
              size: 50,
              color: getcolor(),
            ),
            Text(
              widget.placeName,
                style: GoogleFonts.concertOne(
                  fontSize: 24,
                  color: Colors.black,
                )),
            SizedBox(height: 5),
            Text(
              widget.booked ? 'Booked' : widget.available ? 'Available' : 'Not Available',
              style: GoogleFonts.concertOne(
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8),
            widget.booked
                ? CountdownTimer(
              // Set timer for 10 minutes if booked, else set to 0
              endTime: DateTime.now().millisecondsSinceEpoch + get_timerTime() * 60 * 1000,
              textStyle: GoogleFonts.concertOne(
                fontSize: 18,
                color: Colors.red,
              ),
              onEnd: () {
                // When countdown ends, reset booking
                setState(() {
                  isBooked = false;
                  // Update isBooked in the state
                  databaseRef.child('book').update({widget.placeName: "false"});
                });
              },
            )
                : widget.available && !isBooked
                ? BouncingButton(
              onTap: () {
                if (classInstance.allowBook == true && !widget.booked) {
                  classInstance.allowBook = false;
                  setState(() {
                    isBooked = true; // Update isBooked in the state
                  });
                  databaseRef.child('book').update({widget.placeName: "true"});
                  // Save the booked time in Firebase
                  databaseRef.child('timer_time').update({widget.placeName: DateTime.now().toString().substring(0, 16)});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'It cannot be booked more than once at the moment.',
                          style: GoogleFonts.concertOne(
                            fontSize: 18,
                            color: Colors.white,
                          )
                      ),
                    ),
                  );
                }
              },
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  Color getcolor() {
    if (widget.booked) {
      return Colors.black; // Change icon color when booked
    } else if (widget.available) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}

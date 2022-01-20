import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'clock_view.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  @override
  Widget build(BuildContext context) {
    var dateTime = DateTime.now();
    var formattedDay = DateFormat('EEE , dd MMM').format(dateTime);
    var timezone = dateTime.timeZoneOffset.toString().split(".").first;
    var offsetsign = "";
    if (!timezone.startsWith("-")) {
      offsetsign = "+";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Text(
              "Clock ",
              style: TextStyle(
                fontSize: 30,
                fontFamily: "mavenpro",
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DigitalClockView(),
                Text(
                  formattedDay,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "mavenpro",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.center,
              child: ClockView(
                size: MediaQuery.of(context).size.height / 3,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "TimeZone ",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "mavenpro",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // ignore: prefer_const_constructors
                    Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "UTC " + offsetsign + timezone,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "mavenpro",
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DigitalClockView extends StatefulWidget {
  const DigitalClockView({
    Key? key,
  }) : super(key: key);

  @override
  State<DigitalClockView> createState() => _DigitalClockViewState();
}

class _DigitalClockViewState extends State<DigitalClockView> {
   var formattedTime = DateFormat('HH:mm').format(DateTime.now());
  @override
  void initState() {
   
    
    Timer.periodic(const Duration(seconds: 1), (t) {
       var previousMin = DateTime.now().add(const Duration(seconds: -1)).minute;
       var currentMin = DateTime.now().minute;
      if(previousMin!=currentMin){
         if (!mounted) {
        t.cancel();
      }
      if (mounted) {
        setState(() {
         formattedTime = DateFormat('HH:mm').format(DateTime.now());
        });
      }
      }
    });
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Text(
      formattedTime,
      style: const TextStyle(
        fontSize: 64,
        fontFamily: "mavenpro",
        color: Colors.white,
      ),
    );
  }
}

import 'dart:math';
import 'package:clockapp/alarm_helper.dart';
import 'package:clockapp/constraint/theme_data.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:clockapp/data/data_model.dart';
import 'package:clockapp/models/alarm_info.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late DateTime _alarmTime;
  late String _alarmTimeString;
  final AlarmHelper _alarmHelper = AlarmHelper();
  late Future<List<AlarmInfo>> _alarms = _alarmHelper.getAlarms();
  late List<AlarmInfo> _currentAlarms;
  late int alarmTileColorIndex;
  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.intializeDatabase().then((value) {
      print("---- Database Intialized ----");
      // loadAlarm();
    });
    super.initState();
  }

  int alarmTileColor() {
    int no = _currentAlarms.length;
    alarmTileColorIndex = (no % 5) + 1;
    return alarmTileColorIndex;
  }

  Future<List<AlarmInfo>> loadAlarm() => _alarms = _alarmHelper.getAlarms();

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();

    return Center(
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(top: 64, left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Alarm",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30,
                fontFamily: 'mavenpro',
                color: Colors.white,
              ),
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder<List<AlarmInfo>>(
                  future: _alarms,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _currentAlarms = snapshot.data!;
                      return ListView(
                        children: snapshot.data!.map<Widget>((element) {
                          return AlarmListTile(element);
                        }).followedBy([
                          AddAlarmContainer(),
                        ]).toList(),
                      );
                    }
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color(0xFF493e5c),
                    ));
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget AlarmListTile(AlarmInfo alarm) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.label_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    alarm.title!,
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'mavenpro'),
                  ),
                ],
              ),
              Switch(
                  value: stringToBool(alarm.isPending),
                  onChanged: (bool value) {
                    alarm.isPending = toggleSwitchString(alarm.isPending);
                    setState(() {
                      _alarmHelper.updateAlarm(alarm.id!, alarm);
                    });
                  }),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    'Mon -Fri',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'mavenpro'),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    DateFormat("hh:mm aa").format(alarm.alarmDateTime),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'mavenpro',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _alarmHelper.delete(alarm.id!);
                      setState(() {
                        loadAlarm();
                      });
                    },
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: RadialGradient(
          center: Alignment.bottomLeft,
          radius: 3,
          focalRadius: 2,
          colors: gradientIndex(alarm.gradientColorIndex!),
        ),
        boxShadow: [
          BoxShadow(
              color: gradientIndex(alarm.gradientColorIndex!)
                  .last
                  .withOpacity(0.3),
              blurRadius: 3,
              spreadRadius: 2,
              offset: Offset(2, 4)),
        ],
      ),
    );
  }

  Widget AddAlarmContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DottedBorder(
        dashPattern: const [4, 6],
        strokeCap: StrokeCap.round,
        color: Colors.white54,
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(24),
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF493e5c),
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextButton(
            onPressed: () {
              //scheduleAlarm();

              _addAlarmBottomSheet();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.add, size: 35, color: Colors.white60),
                Text(
                  'Add',
                  style: TextStyle(
                      fontFamily: 'mavenpro',
                      fontSize: 14,
                      color: Colors.white60),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String toggleSwitchString(String value) {
    if (value == 'true') {
      return 'false';
    } else {
      return 'true';
    }
  }

  bool stringToBool(String string) {
    if (string == 'true') {
      return true;
    } else {
      return false;
    }
  }

  void scheduleAlarm(DateTime scheduleAlarmTime) async {
    // ANDROID NOTIFICATION DETAIL
    var androidPlatformChannelSpecifies = const AndroidNotificationDetails(
      "channelId",
      'channelName',
      icon: 'alarm_clock',
      largeIcon: DrawableResourceAndroidBitmap('alarm_clock'),
    );

    //IOS NOTIFICATION DETAIL
    var iOSPlatformChannelSpecifies = const IOSNotificationDetails(
      sound: "asda",
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    //PLATFORM SPECIFIC
    var platformChannelSpecifies = NotificationDetails(
        android: androidPlatformChannelSpecifies,
        iOS: iOSPlatformChannelSpecifies);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'title',
      'body',
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5))
      tz.TZDateTime.from(scheduleAlarmTime, tz.local),
      platformChannelSpecifies,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _addAlarmBottomSheet() {
    _alarmTimeString = DateFormat('hh:mm aa').format(DateTime.now());
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isDismissible: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        var _selectedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (_selectedTime != null) {
                          final now = DateTime.now();
                          var selectedDateTime = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              _selectedTime.hour,
                              _selectedTime.minute);
                          _alarmTime = selectedDateTime;
                          scheduleAlarm(_alarmTime);
                          setModalState(() {
                            _alarmTimeString =
                                DateFormat("hh:mm aa").format(selectedDateTime);
                          });
                        }
                      },
                      child: Text(
                        _alarmTimeString,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.black54,
                        ),
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(8)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.grey)),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Text('Repeat'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Text('Title'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Text('Kuch to hai'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton.extended(
                          onPressed: () async {
                            DateTime scheduleAlarmDateTime;
                            if (_alarmTime.isAfter(DateTime.now())) {
                              scheduleAlarmDateTime = _alarmTime;
                            } else {
                              scheduleAlarmDateTime =
                                  _alarmTime.add(Duration(days: 1));
                            }
                            var alarmInfo = AlarmInfo(
                                title: 'alarm',
                                alarmDateTime: scheduleAlarmDateTime,
                                isPending: true.toString(),
                                gradientColorIndex: alarmTileColor() + 1);
                            _alarmHelper.insertAlarm(alarmInfo);

                            Navigator.pop(context);
                            setState(() {
                              loadAlarm();
                            });
                          },
                          icon: Icon(Icons.alarm),
                          label: Text('Save')),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

import 'package:clockapp/enums.dart';
import 'package:clockapp/home_page.dart';
import 'package:clockapp/models/menu_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingAndroid =
      const AndroidInitializationSettings('alarm_clock');

  var intializationSettingIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {});
  
  var initizationSettings = InitializationSettings(
      android: initializationSettingAndroid, iOS: intializationSettingIOS);
  
  await flutterLocalNotificationsPlugin.initialize(initizationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload : $payload');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<MenuInfo>(
        create: (context) => MenuInfo(MenuType.clock,
            imgSrc: 'assets/alarm_clock.png', title: 'Clock'),
        child: HomePage(),
      ),
    );
  }
}

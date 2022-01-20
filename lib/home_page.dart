// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:clockapp/data/data_model.dart';
import 'package:clockapp/enums.dart';
import 'package:clockapp/models/menu_info.dart';
import 'package:clockapp/views/alarm_page.dart';
import 'package:clockapp/views/clock_page.dart';
import 'package:clockapp/views/clock_view.dart';
import 'package:clockapp/views/stopwatch_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MenuInfo>(builder: (context, value, child) {
              if (value.menuType == MenuType.timer) return  Container();
              if (value.menuType == MenuType.alarm) return const AlarmPage();
              if (value.menuType == MenuType.stopwatch) return const StopWatchPage();
              else 
                return const  ClockPage();
              
            }),
          ),
          const VerticalDivider(
            width: 1,
            color: Colors.white54,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: menuItems
                .map((currentMenuInfo) => createButton(currentMenuInfo))
                .toList(),
          ),
        ],
      ),
    );
  }

  

  Widget createButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(builder: (context, value, child) {
      return ElevatedButton(
        onPressed: () {
          var menuInfo = Provider.of<MenuInfo>(context, listen: false);
          menuInfo.updateMenu(currentMenuInfo);
        },
        style: currentMenuInfo.menuType == value.menuType
            ? customButtonStyle(const Color(0xff26283B))
            : customButtonStyle(const Color(0xFF2D2F41)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              currentMenuInfo.imgSrc,
              scale: 11.5,
            ),
            Text(
              currentMenuInfo.title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "mavenpro",
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    });
  }

  ButtonStyle customButtonStyle(Color color) {
    return ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        primary: color,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
        textStyle: const TextStyle(
            fontSize: 30, fontFamily: "mavenpro", fontWeight: FontWeight.w500));
  }
}

import 'package:clockapp/constraint/theme_data.dart';
import 'package:clockapp/enums.dart';
import 'package:clockapp/models/alarm_info.dart';
import 'package:clockapp/models/menu_info.dart';
import 'package:flutter/cupertino.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock, title: 'Clock', imgSrc: 'assets/world_icon.png'),
  MenuInfo(MenuType.alarm, title: 'Alarm', imgSrc: 'assets/alarm_clock.png'),
  MenuInfo(MenuType.timer, title: 'Timer', imgSrc: 'assets/timer_icon.png'),
  MenuInfo(MenuType.stopwatch,
      title: 'StopWatch', imgSrc: 'assets/stopwatch_icon.png'),
];

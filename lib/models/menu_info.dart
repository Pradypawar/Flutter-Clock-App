import 'package:clockapp/enums.dart';
import 'package:flutter/foundation.dart';

class MenuInfo extends ChangeNotifier {
  MenuType menuType;
  String title;
  String imgSrc;

  MenuInfo(this.menuType, {required this.title, required this.imgSrc});

  updateMenu(MenuInfo menuInfo) {
    this.menuType = menuInfo.menuType;
    this.title = menuInfo.title;
    this.imgSrc = menuInfo.imgSrc;
    notifyListeners();
  }
}

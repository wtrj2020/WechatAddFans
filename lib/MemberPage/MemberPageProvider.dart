import 'package:addfans/Class/MemberClass.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:flutter/material.dart';


class MemberPageProvider extends ChangeNotifier {
  var currentIndex = 0;
  MenberClass data;
  MemberPageProvider.instance() {
    //
  }
  void changeCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

    Future request() async {
    await requestGet('Member').then((val) {
      data = MenberClass.fromJson(val);
      print(val);
    });
    return '填充完成';
  }
  
}

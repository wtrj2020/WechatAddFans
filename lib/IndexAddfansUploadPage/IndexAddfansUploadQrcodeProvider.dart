import 'dart:io';

import 'package:addfans/Class/QrcodesClass.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class IndexAddfansUploadQrcodeProvider extends ChangeNotifier {
  var currentIndex = 0;

  Color leftColor = Colors.red;
  Color rightColor = Colors.white;
  Color leftTextColor = Colors.white;
  Color rightTextColor = Colors.red;
  int tabBarIValue = 0;
  QrcodesClass data;


  Future upLoadImage(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    FormData formData = FormData.fromMap({"file": await MultipartFile.fromFile(path, filename: name),"type":"qrcodes"});

    await requestPost('Upload', formData: formData).then((val) {
      data = QrcodesClass.fromJson(val);
      print(val);
    });
    return '填充完成';
  }

  void changeTabBarIndex(int tabBarIndex) {
    if (tabBarIndex == 0) {
      leftColor = Colors.red;
      rightColor = Colors.white;
      leftTextColor = Colors.white;
      rightTextColor = Colors.red;
      tabBarIValue = tabBarIndex;
    } else if (tabBarIndex == 1) {
      rightColor = Colors.red;
      leftColor = Colors.white;
      leftTextColor = Colors.red;
      rightTextColor = Colors.white;
      tabBarIValue = tabBarIndex;
    }
    notifyListeners();
  }
}

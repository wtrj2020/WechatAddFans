import 'dart:math';

import 'package:addfans/Class/CheckAddStatusClass.dart' as checkData;
import 'package:addfans/Class/QrcodesClass.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:flutter/material.dart';

class IndexAddfansProvider extends ChangeNotifier {
  var currentIndex = 0;

  Color leftColor = Colors.red;
  Color rightColor = Colors.white;
  Color leftTextColor = Colors.white;
  Color rightTextColor = Colors.red;
  int tabBarIValue = 0;
  QrcodesClass data;
  bool isok = false;
  IndexAddfansProvider.instance() {
    //TODO Add code here
  }

  Future request(int viewType) async {
    var formData = {"view_type": viewType};
    await requestPost('QRCodes', formData: formData).then((val) {
      data = QrcodesClass.fromJson(val);
      print(val);
    });
    return '填充完成';
  }

  Future<QrcodesClass> addFinished(List<Data> dataArray) async {
    List addFinishedIds = new List();
    QrcodesClass data;
    for (var item in dataArray) {
      addFinishedIds.add(item.id);
    }
    var formData = {"addFinishedIds": addFinishedIds};
    print(formData);

    await requestPost('AddFinishedIds', formData: formData).then((val) {
      data = QrcodesClass.fromJson(val);
      print(val);
    });
    //notifyListeners();
    return data;
  }

  Future setAddStatus(int id) async {
    // List addFinishedIds = new List();
    // for (var item in dataArray) {
    //   addFinishedIds.add(item.id);
    // }
    var formData = {"fans_id": id};
    print(formData);

    await requestPost('SetAddStatus', formData: formData).then((val) {
      data = QrcodesClass.fromJson(val);
      print(val);
    });
    notifyListeners();

    return '填充完成';
  }




  Future<QrcodesClass> duihuan(List<Data> dataArray) async {
    List addFinishedIds = new List();
    QrcodesClass data;
    for (var item in dataArray) {
      addFinishedIds.add(item.id);
    }
    var formData = {"addFinishedIds": addFinishedIds};
    print(formData);

    await requestPost('Duihuan', formData: formData).then((val) {
      data = QrcodesClass.fromJson(val);
      print(val);
    });
    //notifyListeners();
    return data;
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

class IndexAddfansUpTopProvider extends ChangeNotifier {
  QrcodesClass data;

  IndexAddfansUpTopProvider.instance() {
    //TODO Add code here
  }

  Future request() async {
    var formData = {};
    await requestPost('MyQrcodeList', formData: formData).then((val) {
      data = QrcodesClass.fromJson(val);
      //  print(val);
    });
    return '填充完成';
  }

  // Future upTop(int id) async {
  //   var formData = {"id": id};
  //   await requestPost('UpTop', formData: formData).then((val) {
  //     data = QrcodesClass.fromJson(val);
  //     //  print(val);
  //   });
  //   return '填充完成';
  // }
}

class CheckAddStatusProvider extends ChangeNotifier {
  checkData.CheckAddStatusClass data;
  int random = 1;
  CheckAddStatusProvider.instance() {
    //TODO Add code here
  }

  Future request() async {
    var formData = {};
    await requestPost('CheckAddStatus', formData: formData).then((val) {
      data = checkData.CheckAddStatusClass.fromJson(val);
      random = Random().nextInt(data.data.length);
      print(val);
    });
    return '填充完成';
  }

  setRandom(int length) {
    // random = Random().nextInt(length);
    notifyListeners();
  }
}

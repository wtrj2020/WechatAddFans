import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'Class/QrcodesClass.dart';
import 'Common/httpHeaders.dart';
import 'Common/server_config.dart';

class Asdsdwdw extends StatefulWidget {
  final List<Data> dataArray;
  const Asdsdwdw({Key key, this.dataArray}) : super(key: key);

  @override
  _AsdsdwdwState createState() => _AsdsdwdwState();
}

bool dataStatus = false;
@override
void dispose() {
  countdownTimer.cancel();
  diycontroller0.dispose();
  diycontroller1.dispose();
  diycontroller2.dispose();
  diycontroller3.dispose();
  diycontroller4.dispose();
  diycontroller5.dispose();
  diycontroller6.dispose();
  diycontroller7.dispose();
  diycontroller8.dispose();
  diycontroller9.dispose();
}

@override

//  if (dataStatus == true) return Center(child: Text("data"));
//   dataStatus = true;
class _AsdsdwdwState extends State<Asdsdwdw> {
  @override
  Widget build(BuildContext context) {
    countdown();
    return Stack(
      children: <Widget>[
        ...widget.dataArray.map((e) {
          indexs = [];
          String index = widget.dataArray.indexOf(e).toString();
          if (index == "0") return Center(child: qrcodeWidget(e, index, rootWidgetKey0, diycontroller0));
          if (index == "1") return Center(child: qrcodeWidget(e, index, rootWidgetKey1, diycontroller1));
          if (index == "2") return Center(child: qrcodeWidget(e, index, rootWidgetKey2, diycontroller2));
          if (index == "3") return Center(child: qrcodeWidget(e, index, rootWidgetKey3, diycontroller3));
          if (index == "4") return Center(child: qrcodeWidget(e, index, rootWidgetKey4, diycontroller4));
          if (index == "5") return Center(child: qrcodeWidget(e, index, rootWidgetKey5, diycontroller5));
          if (index == "6") return Center(child: qrcodeWidget(e, index, rootWidgetKey6, diycontroller6));
          if (index == "7") return Center(child: qrcodeWidget(e, index, rootWidgetKey7, diycontroller7));
          if (index == "8") return Center(child: qrcodeWidget(e, index, rootWidgetKey8, diycontroller8));
          if (index == "9") return Center(child: qrcodeWidget(e, index, rootWidgetKey9, diycontroller9));
        })
      ],
    );
  }

  // Widget list() {
  //   for (var e in widget.dataArray) {
  //     String index = widget.dataArray.indexOf(e).toString();
  //     if (index == "0") return Center(child: qrcodeWidget(e, index, rootWidgetKey0, diycontroller0));
  //     if (index == "1") return Center(child: qrcodeWidget(e, index, rootWidgetKey1, diycontroller1));
  //     if (index == "2") return Center(child: qrcodeWidget(e, index, rootWidgetKey2, diycontroller2));
  //     if (index == "3") return Center(child: qrcodeWidget(e, index, rootWidgetKey3, diycontroller3));
  //     if (index == "4") return Center(child: qrcodeWidget(e, index, rootWidgetKey4, diycontroller4));
  //     if (index == "5") return Center(child: qrcodeWidget(e, index, rootWidgetKey5, diycontroller5));
  //     if (index == "6") return Center(child: qrcodeWidget(e, index, rootWidgetKey6, diycontroller6));
  //     if (index == "7") return Center(child: qrcodeWidget(e, index, rootWidgetKey7, diycontroller7));
  //     if (index == "8") return Center(child: qrcodeWidget(e, index, rootWidgetKey8, diycontroller8));
  //     if (index == "9") return Center(child: qrcodeWidget(e, index, rootWidgetKey9, diycontroller9));
  //   }

  //   return Center(child: Text("data"));
  // }

  void countdown() {
    countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (qrcodeImages.length == widget.dataArray.length) {
        countdownTimer.cancel();
        countdownTimer?.cancel();
        countdownTimer = null;
        Get.back(result: 'ok');
      }
    });
  }

  savefile(pathName, GlobalKey<State<StatefulWidget>> rootWidgetKey) async {
    Directory dir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    Uint8List pngBytes;
    RenderRepaintBoundary boundary = rootWidgetKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    pngBytes = byteData.buffer.asUint8List();
    String sTempDir = dir.path;
    bool isDirExist = await Directory(sTempDir).exists();
    if (!isDirExist) {
      Directory(sTempDir).create();
    }
    Future<File> file = File(sTempDir + "/" + pathName + ".jpg").writeAsBytes(pngBytes);
    file.then((f) {
      qrcodeImages.add(f.path);
      print(f.path);

      qrcodeImages = qrcodeImages.toSet().toList(); //去重（build重回导致）
      //return f.path;
    });
  }

  Future<String> checkQrcodeAndDownImage(String qrcodeImg, String qrcodeUrl, String pathName) async {
    //如果有二维码的weixin地址，不走下面的下载二维码图片
    if (qrcodeUrl.length > 10) {
      widget.dataArray[int.parse(pathName)].qrcodeUrl = qrcodeUrl;
      return "wxqrcode";
    }

    Directory dir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    Response response;
    response = await Dio().download(checkServerUrl(qrcodeImg), "${dir.path}/$pathName");
    //response = await Dio().download("http://pay.software14.top/attachment/images/2020/04/23/1587628664139.jpeg", "${dir.path}/$pathName");
    if (response.statusCode == 200) {
      String imagePath = "${dir.path}/$pathName";
      File myFile = new File(imagePath);
      widget.dataArray[int.parse(pathName)].qrcodeUrl = await FlutterQrReader.imgScan(myFile);
    }
    return "wxqrcode";
  }

  Widget qrcodeWidget(Data e, String pathName, GlobalKey<State<StatefulWidget>> rootWidgetKey, ScrollController diycontroller) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.pink,
        height: 0.04,
        width: 0.03,
        child: FutureBuilder(
            future: checkQrcodeAndDownImage(e.qrcodeImg, e.qrcodeUrl, pathName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text("失败"));
                } else {
                  //Timer(Duration(milliseconds: 300), () => diycontroller.jumpTo(diycontroller.position.maxScrollExtent - 200));
                  Timer(Duration(milliseconds: 500), () {
                    savefile(pathName, rootWidgetKey);
                  });
                  return ListView(
                    controller: diycontroller,
                    scrollDirection: Axis.horizontal, //有些屏幕宽度不够，所以横向无限宽
                    children: <Widget>[
                      //SizedBox(height: 10, width: 10),
                      UnconstrainedBox(
                        child: RepaintBoundary(
                          key: rootWidgetKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.center,
                                  height: 500,
                                  width: 500,
                                  color: Colors.white,
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Text("编号: <" + e.id.toString() + ">  ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black))),
                                      Padding(padding: const EdgeInsets.all(20), child: QrImage(data: e.qrcodeUrl, version: 4, size: 500, gapless: true)),
                                      Positioned(
                                          left: 205,
                                          top: 205,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Container(
                                                  color: Colors.white,
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(6.0),
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(6),
                                                          child: CachedNetworkImage(
                                                              progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                                              imageUrl: checkServerUrl(e.headImg),
                                                              width: 85,
                                                              height: 85,
                                                              fit: BoxFit.cover))))))
                                    ],
                                  )),
                              Container(
                                  color: Colors.white,
                                  width: 500,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                    Center(child: Text("已关闭验证 互粉加我", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))),
                                    SizedBox(height: 10),
                                    Center(child: Text("(如果ta没有关闭好友验证,请到平台[我的添加]投诉编号：" + e.id.toString() + ")", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300))),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Center(child: Text(e.describes + e.describes + e.describes + e.describes, style: TextStyle(color: Colors.pink, fontSize: 20, fontWeight: FontWeight.w300))),
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: 10, width: 10)
                    ],
                  );
                }
              } else {
                return Center(child: Text("加载中"));
              }
            }),
      ),
    );
  }
}

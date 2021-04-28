import 'dart:convert';
import 'dart:io';

import 'package:addfans/Class/QrcodesClass.dart';
import 'package:addfans/Common/server_config.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:addfans/IndexAddfansUploadPage/IndexAddfansUploadQrcodePageView.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tip_dialog/tip_dialog.dart';

class IndexAddfansQunJietuPageView extends StatefulWidget {
  final int qrcode_id;
  final String head_img;
  final String qrcode_img;
  final int to_user_id;

  const IndexAddfansQunJietuPageView({Key key, this.qrcode_id, this.head_img, this.qrcode_img, this.to_user_id}) : super(key: key);

  @override
  _IndexAddfansQunJietuPageViewState createState() => _IndexAddfansQunJietuPageViewState();
}

class _IndexAddfansQunJietuPageViewState extends State<IndexAddfansQunJietuPageView> {
  String ts_img = '';
  String ts_img2 = '';
  String ts_img3 = '';
  String wz = ''; //扫码结果

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            bottomNavigationBar: SafeArea(
              child: FlatButton(
                child: Text('提交'),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () async {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text('提示'),
                          content: Text('请确保截图真实\n系统会自动检测(如果是假图会封号)'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('确定'),
                              onPressed: () async {
                                //_resultArr
                                Get.back();
                                upload();
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text('取消'),
                              onPressed: () async {
                                Get.back();
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
            ),
            appBar: AppBar(
              title: Text("上传群截图"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("群1截图："),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          uploadHeadImg(),
                          SizedBox(width: 100),
                          Text("群例子:"),
                          GestureDetector(
                              onTap: () {
                                Get.dialog(GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Image.asset("assets/images/qun1.jpeg", width: 100, height: 100)));
                              },
                              child: Image.asset("assets/images/qun1.jpeg", width: 100, height: 100))
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("群2截图："),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          uploadHeadImg2(),
                          SizedBox(width: 100),
                          Text("群例子:"),
                          GestureDetector(
                              onTap: () {
                                Get.dialog(GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Image.asset("assets/images/qun1.jpeg", width: 100, height: 100)));
                              },
                              child: Image.asset("assets/images/qun1.jpeg", width: 100, height: 100))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )),
        TipDialogContainer(
            duration: const Duration(seconds: 2),
            outsideTouchable: true,
            onOutsideTouch: (Widget tipDialog) {
              if (tipDialog is TipDialog && tipDialog.type == TipDialogType.LOADING) {
                TipDialogHelper.dismiss();
              }
            }),
      ],
    );
  }

  upload() async {
    if (ts_img != '' && ts_img2 != '') {
      TipDialogHelper.loading("准备中");

      var formData = {
        // "to_user_id": widget.to_user_id,
        // "qrcode_id": widget.qrcode_id,
        // "head_img": widget.head_img,
        // "qrcode_img": widget.qrcode_img,
        "qrcode_img":wz,
        "ts_img": ts_img,
        "ts_img2": ts_img2,
      };
      QrcodesClass data;
      await requestPost('CheckQun', formData: formData).then((val) {
        data = QrcodesClass.fromJson(val);
        // Navigator.pop(context);
      });
      if (data.status == 1) {
        TipDialogHelper.dismiss();
         showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('提示'),
                content: Text(data.msg),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('确认'),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              );
            });
      } else {
        TipDialogHelper.dismiss();

        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('提示'),
                content: Text(data.msg),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('确认'),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              );
            });
        // Get.back();
      }
    } else {
      //Get.back();

      Get.defaultDialog(
          title: "提示",
          content: Text("请上传完整"),
          cancel: FlatButton(
            child: Text("确定"),
            onPressed: () {
              Get.back();

              // Navigator.pop(context);
            },
          ));

      print("object");
    }
  }

  uploadHeadImg() {
    return Card(
      elevation: 6,
      child: Container(
        color: Colors.black26,
        height: ScreenUtil().setHeight(100),
        width: ScreenUtil().setWidth(100),
        child: ts_img == ''
            ? OutlineButton(
                //shape: CircleBorder(),_upLoadImage(image);
                onPressed: getImageHead,
                child: Text("上传"),
              )
            : GestureDetector(
                onTap: () async {
                  await getImageHead();
                },
                child: Image.network(
                  checkServerUrl(ts_img),
                
                )),
      ),
    );
  }

  Future getImageHead() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image.path == null) return;

    final rest = await FlutterQrReader.imgScan(image);
    
    if (rest == null) {
      Get.defaultDialog(
          title: "错误",
          content: Text("请上传正确的群截图"),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
    }
    var now = DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);

    Uri u = Uri.parse(rest);
    String code = u.queryParameters['code'];
    String time = u.queryParameters['time'];

    if (time == null ) {
      Get.defaultDialog(
          title: time.toString(),
          content: Text("您发的推广海报不正确\n(群里不要出现其它二维码\n可能会不识别)"),
          cancel: FlatButton(
            child: Text("确定"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    RegExp mobile = new RegExp(r"\d$");

    if (!mobile.hasMatch(time)) {
      Get.defaultDialog(
          title: "错误",
          content: Text("您发的推广海报不正确\n(群里不要出现其它二维码\n可能会不识别!)"),
          cancel: FlatButton(
            child: Text("确定"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    if ((int.parse(now) - int.parse(time)) > 18001800) {
      Get.defaultDialog(
          title: "错误",
          content: Text("这个推广截图超过30分钟\n请重新获取海报转发到满100人的微信群。"),
          cancel: FlatButton(
            child: Text("确定"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    ts_img = await upLoadImage(image);

    setState(() {});
  }

  uploadHeadImg2() {
    return Card(
      elevation: 6,
      child: Container(
        color: Colors.black26,
        height: ScreenUtil().setHeight(100),
        width: ScreenUtil().setWidth(100),
        child: ts_img2 == ''
            ? OutlineButton(
                //shape: CircleBorder(),_upLoadImage(image);
                onPressed: getImageHead2,
                child: Text("上传"),
              )
            : GestureDetector(
                onTap: () async {
                  await getImageHead2();
                },
                child: Image.network(
                  checkServerUrl(ts_img2),
                  
                )),
      ),
    );
  }

  Future getImageHead2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image.path == null) return;
    final rest = await FlutterQrReader.imgScan(image);
    if (rest == null) {
      Get.defaultDialog(
          title: "错误",
          content: Text("请上传正确的群截图"),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
    }
    var now = DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);

    Uri u = Uri.parse(rest);
    String code = u.queryParameters['code'];
    String time = u.queryParameters['time'];

    if (time == null || code == null) {
      Get.defaultDialog(
          title: "错误",
          content: Text("您发的推广海报不正确\n(群里不要出现其它二维码\n可能会不识别)"),
          cancel: FlatButton(
            child: Text("确定"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    RegExp mobile = new RegExp(r"\d$");

    if (!mobile.hasMatch(time) || !mobile.hasMatch(code)) {
      Get.defaultDialog(
          title: "错误",
          content: Text("您发的推广海报不正确\n(群里不要出现其它二维码\n可能会不识别!)"),
          cancel: FlatButton(
            child: Text("确定"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    if ((int.parse(now) - int.parse(time)) > 18001800) {
      Get.defaultDialog(
          title: "错误",
          content: Text("这个推广截图超过30分钟\n请重新获取海报转发到满100人的微信群。"),
          cancel: FlatButton(
            child: Text("确定"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    ts_img2 = await upLoadImage(image);

    setState(() {});
  }

  uploadHeadImg3() {
    return Card(
      elevation: 6,
      child: Container(
        color: Colors.black26,
        height: ScreenUtil().setHeight(100),
        width: ScreenUtil().setWidth(100),
        child: ts_img3 == ''
            ? OutlineButton(
                //shape: CircleBorder(),_upLoadImage(image);
                onPressed: getImageHead3,
                child: Text("上传"),
              )
            : GestureDetector(
                onTap: () async {
                  await getImageHead3();
                },
                child: Image.network(
                  checkServerUrl(ts_img3),
                  fit: BoxFit.cover,
                )),
      ),
    );
  }

  Future getImageHead3() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image.path == null) return;

    ts_img3 = await upLoadImage(image);

    setState(() {});
  }

  Future upLoadImage(File image) async {
    Uploads data;
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({"file": await MultipartFile.fromFile(path, filename: name),"type":"share"});
    Dio dio = new Dio();
    dio.options.headers['token'] = token;
    var respone = await dio.post<String>(serverUrl + "/Upload", data: formData);
    if (respone.statusCode == 200) {
      data = Uploads.fromJson(jsonDecode(respone.data));
    }
    print(data.filepath);
    return data.filepath;
  }
}

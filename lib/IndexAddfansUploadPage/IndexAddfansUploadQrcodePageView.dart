import 'dart:convert';
import 'dart:io';

import 'package:addfans/Class/QrcodesClass.dart';
import 'package:addfans/Common/server_config.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Uploads {
  String filepath;
  int status;

  Uploads({this.filepath, this.status});

  Uploads.fromJson(Map<String, dynamic> json) {
    filepath = json['filepath'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filepath'] = this.filepath;
    data['status'] = this.status;
    return data;
  }
}

class IndexAddfansUploadQrcodePageView extends StatefulWidget {
  const IndexAddfansUploadQrcodePageView({Key key}) : super(key: key);

  @override
  _IndexAddfansUploadQrcodePageViewState createState() => _IndexAddfansUploadQrcodePageViewState();
}

class _IndexAddfansUploadQrcodePageViewState extends State<IndexAddfansUploadQrcodePageView> {
  var focusNode = new FocusNode();

  Result _resultArr = new Result();
  var areaId;
  String shangjiId;
  String shangjiName;
  var addrssview;

  bool _checkValue = false;
  bool _checkValue2 = false;
  bool _checkValue3 = false;

  String _wechatId = '';
  String __describes = '';
  String _myPhone = '';
  String _imageHeadUrl = '';
  String _imageQrcodeUrl = '';
  String _imageWXQrcodeUrl = '';

  bool touxiang = true;
  bool erwei = true;

  // showDialog() {
  //   Get.defaultDialog(
  //       title: "重要",
  //       content: Text("请务必和微信头像保持一致，否则没有加粉效果"),
  //       confirm: FlatButton(
  //         child: Text("明白了，让我上传吧！"),
  //         onPressed: () {
  //           getImageHead();
  //           Get.back();
  //         },
  //       ),
  //       cancel: FlatButton(
  //         child: Text("取消"),
  //         onPressed: () => Get.back(),
  //       ));
  // }

  Future getImageHead() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 700, maxHeight: 700);
    if (image.path == null) return;
    final rest = await FlutterQrReader.imgScan(image);
    print(rest);
    if (rest != null) {
      Get.defaultDialog(
          title: "错误",
          content: Text("请上传正确的头像"),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
      _imageHeadUrl = '';
      setState(() {});
      return;
    }
    _imageHeadUrl = await upLoadImage(image);

    setState(() {});
  }

  Future getImageQrcode() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 700, maxHeight: 700);
    if (image.path == null) return;
    final rest = await FlutterQrReader.imgScan(image);
    if (rest == null) {
      Get.defaultDialog(
          title: "错误",
          content: Text("请上传正确的微信二维码"),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
      setState(() {
        _imageQrcodeUrl = '';
      });
      return;
    }

    if (rest.contains('://u.wechat.com/') || rest.contains('://weixin.qq.com/r/')) {
      bool status = await checkIsQrcode(rest);
      if (status == false) {
        _imageQrcodeUrl = "";
        setState(() {});
        return;
      }
      _imageQrcodeUrl = await upLoadImage(image);
      _imageWXQrcodeUrl = rest;

      setState(() {});
      return;
    }

    Get.defaultDialog(
        title: "错误",
        content: Text("请上传正确的微信二维码"),
        cancel: FlatButton(
          child: Text("知道了"),
          onPressed: () => Get.back(),
        ));
  }

  Future upLoadImage(File image) async {
    Uploads data;
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({"file": await MultipartFile.fromFile(path, filename: name), "type": "qrcodes"});
    Dio dio = new Dio();
    dio.options.headers['token'] = token;
    var respone = await dio.post<String>(serverUrl + "/Upload", data: formData);
    if (respone.statusCode == 200) {
      data = Uploads.fromJson(jsonDecode(respone.data));
    }

    print(data.filepath);
    return data.filepath;
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width - 100);
    return Scaffold(
        resizeToAvoidBottomPadding: false, //避免键盘填充widget
        appBar: AppBar(
          elevation: 0,
          title: Text("上传名片"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(focusNode);
              focusNode.unfocus();
            },
            behavior: HitTestBehavior.translucent,
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[Text('微信头像'), SizedBox(height: 10), uploadHeadImg()],
                    ),
                    Column(
                      children: <Widget>[Text('微信二维码'), SizedBox(height: 10), uploadQrcodeImg()],
                    )
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('微信号'),
                    SizedBox(
                      width: ScreenUtil().setWidth(314),
                      height: ScreenUtil().setHeight(60),
                      child: TextField(
                        cursorWidth: 2,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        maxLength: 20,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(border: InputBorder.none, counterText: '注意!不是手机号码,用于防止别人假加你', contentPadding: EdgeInsets.only(top: 12)),
                        onChanged: _textFieldChangedwechatId,
                        autofocus: false,
                        autocorrect: false,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                Divider(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('简短介绍'),
                    SizedBox(
                      width: ScreenUtil().setWidth(314),
                      height: ScreenUtil().setHeight(60),
                      child: TextField(
                        cursorWidth: 2,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        maxLength: 8,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(border: InputBorder.none, counterText: '长话短说，八字以内。', contentPadding: EdgeInsets.only(top: 12)),
                        onChanged: _textFieldChangedDescribes,
                        autofocus: false,
                        autocorrect: false,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                Divider(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('手机号码'),
                    SizedBox(
                      width: ScreenUtil().setWidth(314),
                      height: ScreenUtil().setHeight(60),
                      child: TextField(
                        cursorWidth: 2,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        maxLength: 11,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(border: InputBorder.none, counterText: '', contentPadding: EdgeInsets.only(top: 12)),
                        onChanged: _textFieldChangedPhone,
                        autofocus: false,
                        autocorrect: false,
                        textDirection: TextDirection.ltr,
                      ),
                    )
                  ],
                ),
                Divider(height: 1),
                SizedBox(
                  height: ScreenUtil().setHeight(60),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _clickEventFunc();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('选择地址'),
                        Text(
                          addrssview ?? '请选择>',
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black45),
                        )
                        //Text(_resultArr.provinceName+_resultArr.cityName+_resultArr.areaName),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "↙️微信>我>设置>隐私↘️",
                      style: TextStyle(color: Colors.pink),
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('微信设置1'),
                    Row(
                      children: <Widget>[
                        Text(
                          "已关闭[加我时需要验证]",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Checkbox(
                          value: _checkValue,
                          activeColor: Colors.blue,
                          onChanged: (bool val) async {
                            // val 是布尔值
                            this.setState(() {
                              this._checkValue = !this._checkValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('设置2'),
                    Row(
                      children: <Widget>[
                        Text(
                          "微信号" + "" + _wechatId + "能搜到我",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Checkbox(
                          value: _checkValue2,
                          activeColor: Colors.blue,
                          onChanged: (bool val) async {
                            // val 是布尔值

                            this.setState(() {
                              this._checkValue2 = !this._checkValue2;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('设置3'),
                    Row(
                      children: <Widget>[
                        Text(
                          "手机号" + "" + _myPhone + "能搜到我",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Checkbox(
                          value: _checkValue3,
                          activeColor: Colors.blue,
                          onChanged: (bool val) async {
                            // val 是布尔值
                            this.setState(() {
                              this._checkValue3 = !this._checkValue3;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Text(''),
                //     Row(
                //       children: <Widget>[
                //         Text(
                //           "我已经把【添加我的方式】全开",
                //           style: TextStyle(color: Colors.black45),
                //         ),
                //         Checkbox(
                //           value: _checkValue,
                //           activeColor: Colors.blue,
                //           onChanged: (bool val) {
                //             // val 是布尔值
                //             this.setState(() {
                //               this._checkValue = !this._checkValue;
                //             });
                //           },
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
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
                      title: Text('提交'),
                      content: Text('你确定已经"关闭了好友验证"功能吗？\n否则别人无法加你哦\n打开微信>我>设置>隐私'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('取消'),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('我已关闭'),
                          onPressed: () async {
                            Get.back();
                            await tijiao();
                            // Navigator.of(context).pop('ok');
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ));
  }

  Future<bool> checkIsQrcode(rest) async {
    QrcodesClass data;
    var formData = {'qrcode_url': rest};
    await requestPost('CheckIsQrcodeExist', formData: formData).then((val) {
      data = QrcodesClass.fromJson(val);
    });

    if (data.status == -1) {
      Get.defaultDialog(
          title: "错误",
          content: Text(data.msg),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
      return false;
    }
    return true;
  }

  tijiao() async {
    if (_imageHeadUrl.length < 2) {
      Get.defaultDialog(
          title: "错误",
          content: Text("请上传微信头像\n（一定要和微信一样）"),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
      return;
    }
    if (_imageQrcodeUrl.length < 2) {
      Get.defaultDialog(
          title: "错误",
          content: Text("二维码上传了码？"),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    if (_wechatId.length < 4) {
      Get.defaultDialog(
          title: "错误",
          content: Text("微信号不正确"),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
      return;
    }
    if (__describes.length < 2) {
      Get.defaultDialog(
          title: "错误",
          content: Text("微信昵称不完整\n（一定要和微信一模一样）"),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
      return;
    }
    if (!isPhone(_myPhone)) {
      Get.defaultDialog(
          title: "错误",
          content: Text("手机号码不正确:("),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    print(_resultArr);
    if (addrssview == null) {
      Get.defaultDialog(
          title: "错误",
          content: Text("请选择地址"),
          cancel: FlatButton(
            child: Text("知道了"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    if (_checkValue != true) {
      Get.defaultDialog(
          title: "错误",
          content: Text("请确保您已经【关闭微信好友验证】\n如果已经关闭请在下面打钩"),
          cancel: FlatButton(
            child: Text("好烦"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    if (_checkValue2 != true && _checkValue3 != true) {
      print(_checkValue3);
      Get.defaultDialog(
          title: "错误",
          content: Text("[微信号]和[手机号]至少选一个能找到你的"),
          cancel: FlatButton(
            child: Text("好烦"),
            onPressed: () => Get.back(),
          ));
      return;
    }

    //_resultArr
    var formData = {
      "describes": __describes,
      "head_img": _imageHeadUrl,
      "qrcode_img": _imageQrcodeUrl,
      "qrcode_url": _imageWXQrcodeUrl,
      "job": "呵呵",
      "user_phone": _myPhone,
      "wechat_id": _wechatId,
      "province_name": _resultArr.provinceName,
      "province_id": _resultArr.provinceId,
      "city_name": _resultArr.cityName,
      "city_id": _resultArr.cityId,
      "area_name": _resultArr.areaName,
      "area_id": _resultArr.areaId
    };
    QrcodesClass data;
    await requestPost('UploadQRCodes', formData: formData).then((val) {
      __describes = '';
      _myPhone = '';
      data = QrcodesClass.fromJson(val);
      // Navigator.pop(context);
    });
    if (data.status == 1) {
      Navigator.pop(context);

      Get.defaultDialog(
          title: "上传成功",
          content: Text(data.msg),
          cancel: FlatButton(
            child: Text("确定"),
            onPressed: () {
              Get.back();
            },
          ));
    } else {
      // Navigator.pop(context);

      Get.defaultDialog(
          title: "上传失败",
          content: Text(data.msg),
          cancel: FlatButton(
            child: Text("确定"),
            onPressed: () {
              Get.back();

              // Navigator.pop(context);
            },
          ));
      // Navigator.pop(context);
    }
  }

  uploadHeadImg() {
    return Card(
      elevation: 6,
      child: Container(
        color: Colors.black26,
        height: ScreenUtil().setWidth(100),
        width: ScreenUtil().setWidth(100),
        child: _imageHeadUrl == ''
            ? OutlineButton(
                //shape: CircleBorder(),_upLoadImage(image);
                onPressed: getImageHead,
                child: Text("微信头像"),
              )
            : GestureDetector(
                onTap: () async {
                  await getImageHead();
                },
                child: Image.network(
                  checkServerUrl(_imageHeadUrl),
                  fit: BoxFit.cover,
                )),
      ),
    );
  }

  uploadQrcodeImg() {
    return Card(
      elevation: 6,
      child: Container(
        color: Colors.black26,
        height: ScreenUtil().setWidth(100),
        width: ScreenUtil().setWidth(100),
        child: _imageQrcodeUrl == ''
            ? OutlineButton(
                //shape: CircleBorder(),
                onPressed: getImageQrcode,
                child: Text("关掉验证\n防止封号"),
              )
            : GestureDetector(
                onTap: getImageQrcode,
                child: Image.network(
                  checkServerUrl(_imageQrcodeUrl),
                  fit: BoxFit.cover,
                )),
      ),
    );
  }

  void _textFieldChangedDescribes(String str) {
    __describes = str;
    print(str);
  }

  void _textFieldChangedwechatId(String str) {
    str = str.replaceAll(' ', '');
    str = str.replaceAll('.', '');
    _wechatId = str;
    setState(() {});
  }

  void _textFieldChangedPhone(String str) {
    _myPhone = str;
    setState(() {});
    print(str);
  }

  static bool isPhone(String input) {
    RegExp mobile = new RegExp(r"1[0-9]\d{9}$");
    return mobile.hasMatch(input);
  }

  void _clickEventFunc() async {
    Result tempResult = await CityPickers.showCityPicker(
        //showType: ShowType.pc,
        context: context,
        //locationCode:"222200",
        theme: new ThemeData(
            primaryColor: Color(0xFFC91B3A),
            backgroundColor: Color(0xFFEFEFEF),
            accentColor: Color(0xFF888888),
            textTheme: TextTheme(
                //设置Material的默认字体样式
                //  body1: TextStyle(color: Color(0xFF888888), fontSize: 16.0),
                )));

    if (tempResult != null) {
      setState(() {
        _resultArr = tempResult;
        addrssview = "${_resultArr?.provinceName}-${_resultArr?.cityName ?? ''}";
        print(_resultArr);
      });
    }
  }
}

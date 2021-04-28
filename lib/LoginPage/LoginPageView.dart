import 'dart:async';

import 'package:addfans/Class/LoginClass.dart';
import 'package:addfans/Common/httpHeaders.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:addfans/IndexPage/IndexPageView.dart';
import 'package:addfans/LoginPage/RefPageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageView extends StatefulWidget {
  @override
  _LoginPageViewState createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _phone;
  String _password;
  String viewtoken = '';

  @override
  Widget build(BuildContext context) {
    var focusNode = new FocusNode();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
            Get.offAll(RegPageView(),transition: Transition.fade);
            },
            child: Text('账号注册', style: TextStyle(fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w300)),
          )
        ],
        // backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(focusNode);
          focusNode.unfocus();
        },
        child: Form(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: (Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('登录', style: TextStyle(fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    Text('新用户请用验证码登录', style: TextStyle(fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.w300)),
                    SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        Text('+86', style: TextStyle(fontSize: ScreenUtil().setSp(26))),
                        Text(' | ', style: TextStyle(fontSize: ScreenUtil().setSp(20), color: Colors.black12)),
                        SizedBox(
                          width: ScreenUtil().setWidth(280),
                          child: TextFormField(
                            cursorColor: Colors.blue[200],
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                            decoration: InputDecoration(
                              hintText: '请输入手机号',
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.all(0.0),
                            ),
                            maxLines: 1,
                            maxLength: 11,
                            validator: (val) {
                              return val.length < 11 ? "请填写正确手机号" : null;
                            },
                            onChanged: (val) {
                              setState(() {
                                _phone = val;
                                print(_phone);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Divider(height: 1),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: ScreenUtil().setWidth(340),
                          child: TextFormField(
                            obscureText: true,
                            cursorColor: Colors.blue[200],
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.w300),
                            decoration: InputDecoration(
                              hintText: '输入密码',
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.all(0.0),
                            ),
                            maxLines: 1,
                            maxLength: 24,
                            validator: (val) {
                              return val.length < 3 ? "输入正确的密码" : null;
                            },
                            // onChanged: ,
                            onChanged: (val) {
                              setState(() {
                                _password = val;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Divider(height: 1),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('忘记密码', style: TextStyle(fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w200)),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                          width: ScreenUtil().setWidth(350),
                          child: FlatButton(
                            child: Text('登录', style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(20))),
                            shape: StadiumBorder(side: BorderSide.none),
                            onPressed: () {
                              //Provide.value<CurrentIndex>(context).changeIndex(0);
                              loginClick();
                            },
                            color: Colors.pink,
                          )),
                    )
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future _readShared() async {
  //   LogMessages logMessages;
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   //var aaa = await preferences.get('token');
  //   String viewtoken = await preferences.get('token');

  //   print(viewtoken);
  //   print(viewtoken);
  //   if (viewtoken != null) {
  //     var formData = {
  //       'tokenId': viewtoken,
  //       'app': 'app'
  //     };

  //     Response response;
  //     Dio dio = new Dio();
  //     response = await dio.post(serverPath['LogMessages'], data: formData);
  //     logMessages = LogMessages.fromJson(json.decode(response.data));

  //     if (logMessages.status != -999) {
  //       token = viewtoken;
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           new MaterialPageRoute(
  //               fullscreenDialog: true,
  //               builder: (BuildContext context) {
  //                 return MyApp();
  //               }),
  //           (route) => route == null);
  //     }
  //     print('读取到acount为:$viewtoken');
  //   }
  // }

  // Future<void> _incrementCounter() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final int counter = (prefs.getInt('counter') ?? 0) + 1;

  //   setState(() {
  //     _counter = prefs.setInt("counter", counter).then((bool success) {
  //       return counter;
  //     });
  //   });
  // }

  @override
  void initState() {
    // _readShared();
    super.initState();
  }

  void loginClick() async {
    if (!isPhone(_phone)) {
      showMsg("手机号码不正确:(");
      return;
    }

    if (_password.length < 6) {
      showMsg("密码不完整:(");
      return;
    }

    loginIng();
  }

  loginIng() async {
    LoginClass data;
    var formData = {
      "user_phone": _phone,
      "user_pass": _password,
    };
    await requestPost('Login', formData: formData).then((val) {
      data = LoginClass.fromJson(val);
      print(val);
    });

    if (data.status != 1) {
      showMsg(data.msg);
      return;
    }
    qrcodeImages = List<String>();
    final SharedPreferences prefs = await _prefs;
    prefs.setString("token", data.data);
    token = prefs.getString("token");
    print(token);
    Get.off(IndexPageView());
  }

  static bool isPhone(String input) {
    RegExp mobile = new RegExp(r"1[0-9]\d{9}$");
    return mobile.hasMatch(input);
  }

  showMsg(String msg) {
    Get.defaultDialog(
        title: "提示",
        content: Text(msg),
        cancel: FlatButton(
          child: Text("知道了"),
          onPressed: () => Get.back(),
        ));
  }
  // showMsg(String msg) {
  //   Toast.show(
  //     msg,
  //     context,
  //     backgroundColor: Colors.pink,
  //     duration: 2,
  //     backgroundRadius: 3,
  //     gravity: 1,
  //   );
  // }

  // Future save(_loginKey, _token) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString('token', _token);
  //   token = _token;
  // }
}

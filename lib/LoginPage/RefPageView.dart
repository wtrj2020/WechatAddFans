import 'dart:async';

import 'package:addfans/Class/LoginClass.dart';
import 'package:addfans/Common/httpHeaders.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:addfans/IndexPage/IndexPageView.dart';
import 'package:addfans/LoginPage/LoginPageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegPageView extends StatefulWidget {
  @override
  _RegPageViewState createState() => _RegPageViewState();
}

class _RegPageViewState extends State<RegPageView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _phone = '';
  String _password = '';
  String _password2 = '';
  String _asharecode = '';
  String viewtoken = '';
  bool _ashareinput = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   // print('data content ${data.text}'); //  data content 复制的内容
  //   chek();
  //   super.initState();
  // }

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
              Get.offAll(LoginPageView(), transition: Transition.fade);
            },
            child: Text('账号登录', style: TextStyle(fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w300)),
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
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: (Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('注册', style: TextStyle(fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w500)),
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
                              hintText: '输入手机号',
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.all(0.0),
                            ),
                            maxLines: 1,
                            maxLength: 11,
                            // validator: (val) {
                            //   return val.length < 11 ? "请填写正确手机号" : null;
                            // },
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
                            // validator: (val) {
                            //   return val.length < 3 ? "密码不符合规范" : null;
                            // },
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
                              hintText: '确认密码',
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.all(0.0),
                            ),
                            maxLines: 1,
                            maxLength: 24,
                            onChanged: (val) {
                              setState(() {
                                _password2 = val;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Divider(height: 1),
                    SizedBox(height: 20),
                    Offstage(
                      offstage: _ashareinput,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: ScreenUtil().setWidth(340),
                            child: TextFormField(
                              obscureText: false,
                              cursorColor: Colors.blue[200],
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                hintText: '邀请码',
                                border: InputBorder.none,
                                counterText: '',
                                contentPadding: EdgeInsets.all(0.0),
                              ),
                              maxLines: 1,
                              maxLength: 8,
                              // validator: (val) {
                              //   return val.length < 3 ? "密码不符合规范" : null;
                              // },
                              // onChanged: ,
                              onChanged: (val) {
                                setState(() {
                                  _asharecode = val;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(height: 1),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('', style: TextStyle(fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w200)),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                          width: ScreenUtil().setWidth(350),
                          child: FlatButton(
                            child: Text('注册', style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(20))),
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

  @override
  void initState() {
    chekClipboard();
    super.initState();
  }

  Future chekClipboard() async {
    ClipboardData clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboard.text.length == 7 || clipboard.text.length == 8) {
      RegExp mobile = new RegExp(r"\d$");
      bool isNum = mobile.hasMatch(clipboard.text);
      if (!isNum) {
        print("不是数字");
        return;
      }
      LoginClass data;
      var formData = {
        "a_share_code": int.parse(clipboard.text),
      };
      await requestPost('RegUser', formData: formData).then((val) {
        data = LoginClass.fromJson(val);
        print(val);
      });
      if (data.status != -99) {
        print("邀请码正确，写入变量");
        _asharecode = clipboard.text;
        setState(() {
          _ashareinput = true;
        });
      }
    }
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

    if (_password != _password2) {
      showMsg("密码不一致:(");
      return;
    }
    RegExp mobile = new RegExp(r"\d$");
    bool isNum = mobile.hasMatch(_asharecode);
    if (!isNum) {
      showMsg("邀请码只能是数字");
      return;
    }
    if (_asharecode.toString().length < 6) {
      showMsg("邀请码不正确");
      return;
    }

    loginIng();
  }

  loginIng() async {
    LoginClass data;
    var formData = {
      "user_phone": _phone,
      "user_pass": _password,
      "a_share_code": int.parse(_asharecode),
    };
    await requestPost('RegUser', formData: formData).then((val) {
      data = LoginClass.fromJson(val);
      print(val);
    });

    if (data.status == -99) {
      showMsg(data.msg);
      return;
    }
    if (data.status != 1) {
      showMsg(data.msg);
      return;
    }

    Get.offAll(LoginPageView());
    showMsg("注册成功:）");
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
}

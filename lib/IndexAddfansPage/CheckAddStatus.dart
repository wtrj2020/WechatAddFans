import 'package:addfans/Class/QrcodesClass.dart';
import 'package:addfans/Common/server_config.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'IndexAddfansProvider.dart';

class CheckAddStatus extends StatefulWidget {
  final int id;
  final List<Data> dataArray;
  const CheckAddStatus({Key key, this.id, this.dataArray}) : super(key: key);

  @override
  _CheckAddStatusState createState() => _CheckAddStatusState();
}

String _wechatIdTwo = '';
String _wechatId;
String _headImg = "";

class _CheckAddStatusState extends State<CheckAddStatus> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckAddStatusProvider>(
        create: (context) => CheckAddStatusProvider.instance(),
        child: Consumer<CheckAddStatusProvider>(
          builder: (context, viewModel, child) {
            return FutureBuilder(
                future: viewModel.request(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) Center(child: Text("加载中"));
                  if (snapshot.hasError) return Scaffold(body: Center(child: Text("你现在的种子太少了\n建议你上面满20个头像再来找我", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.pink))));
                  if (snapshot.hasData) {
                    _wechatId = viewModel.data.data[viewModel.random].wechatId;
                    _headImg = checkServerUrl(viewModel.data.data[viewModel.random].headImg);
                    String wechatIdSub = viewModel.data.data[viewModel.random].wechatId.substring(0, viewModel.data.data[viewModel.random].wechatId.length - 2);
                    var focusNode = new FocusNode();
                    if (viewModel.data.data.length < 2) {
                      //2代表能取到的问题数量
                      return Scaffold(body: Center(child: Text("你现在的种子太少了\n建议你上面满20个头像再来找我", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.pink))));
                    }
                    return Scaffold(
                      // resizeToAvoidBottomPadding: false, //避免键盘填充widget
                      // appBar: AppBar(
                      //   //title: Text("反作弊系统"),
                      //   elevation: 0,
                      // ),
                      body: ListView(
                        children: <Widget>[
                          GestureDetector(
                            onLongPress: () {
                              // print("object");
                              copy(wechatIdSub);
                            },
                            onTap: () {
                              FocusScope.of(context).requestFocus(focusNode);
                              focusNode.unfocus();
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Text(_wechatId),
                                      Text("下面这个人是你刚刚加的好友"),
                                      //  Text("下面是你刚刚最近加她的，TA的微信开头是"+wechatIdSub),
                                      Image.network(
                                        serverUrl + _headImg,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 10),

                                      Text("打开微信>在通讯录里>搜索 " + wechatIdSub + " 获取后2位"),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(width: 2),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                //width: 245,
                                                child: Text(
                                                  wechatIdSub,
                                                  textAlign: TextAlign.right,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(decoration: TextDecoration.none, fontSize: 30, fontWeight: FontWeight.w600, color: Colors.pink),
                                                ),
                                              ),
                                              Container(
                                                width: ScreenUtil().setHeight(60),
                                                height: ScreenUtil().setHeight(60),
                                                child: TextField(
                                                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.pink), //输入文本的样式
                                                  // cursorWidth: 2,
                                                  keyboardType: TextInputType.text,
                                                  maxLines: 1,
                                                  maxLength: 2,
                                                  maxLengthEnforced: true,
                                                  decoration: InputDecoration(hintText: '____', border: InputBorder.none, counterText: '', contentPadding: EdgeInsets.only(left: 0, right: 0, top: 12)),
                                                  onChanged: _textFieldChangedwechatId,
                                                  autofocus: false,
                                                  autocorrect: false,
                                                  textDirection: TextDirection.ltr,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 2),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(width: 2),
                                          Row(
                                            children: <Widget>[
                                              OutlineButton(
                                                child: Text("换一个"),
                                                onPressed: () {
                                                  viewModel.setRandom(viewModel.data.data.length);
                                                },
                                              ),
                                              SizedBox(width: 10),
                                              OutlineButton(
                                                child: Text("复制"),
                                                onPressed: () {
                                                  copy(wechatIdSub);
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 2),
                                        ],
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width - 60,
                                        child: Text(
                                          "(为了保证平台的加粉真实性，请在微信通讯录中找到微信号开头为''" + wechatIdSub + "''的后两位写到上面。)",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.pink),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text("加载中"));
                  }
                });
          },
        ));
  }

  copy(String wechatIdSub) {
    Clipboard.setData(ClipboardData(text: wechatIdSub));
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('复制成功'),
            content: Text("打开微信>通讯录>最上面>搜索\n粘贴获取后2位"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('好的'),
                onPressed: () {
                  Get.back();
                },
              ),
              CupertinoDialogAction(
                child: Text('我不会啊'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        });
  }

  void _textFieldChangedwechatId(String str) async {
    str = str.replaceAll(' ', '');
    str = str.replaceAll(' ', '');
    _wechatIdTwo = str;
    if (_wechatIdTwo.length != 2) {
      return;
    }

    QrcodesClass data;

    List addFinishedIds = new List();
    for (var item in widget.dataArray) {
      addFinishedIds.add(item.id);
    }
    var formData = {
      "wechat_id": _wechatId.substring(
            0,
            _wechatId.length - 2,
          ) +
          _wechatIdTwo,
      "addFinishedIds": addFinishedIds
    };
    await requestPost('CheckAddStatus', formData: formData).then((val) {
      data = QrcodesClass.fromJson(val);
    });
    if (data.status == 2) {
      Get.back();
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("成功"),
              content: Text(data.msg),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("确定"),
                  onPressed: () {
                    Get.back(result: "ok");

                    //Get.back(result: "ok");
                  },
                ),
              ],
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('提示'),
              content: Text(data.msg),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("确定"),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            );
          });
    }
  }
  // void _textFieldChangedwechatId(String str) async {
  //   _wechatIdTwo = str;
  //   print(str);
  //   if (_wechatIdTwo.length != 2) {
  //     return;
  //   }
  //   if (_wechatId.substring(_wechatId.length - 2, _wechatId.length) == _wechatIdTwo) {
  //     QrcodesClass data;
  //     var formData = {"id": widget.id, "wechat_id": _wechatId.substring(0, _wechatId.length - 2) + _wechatIdTwo};
  //     await requestPost('UpTop', formData: formData).then((val) {
  //       data = QrcodesClass.fromJson(val);
  //       //  print(val);
  //     });
  //     if (data.status == 1) {
  //       Get.back(result: 'sucess');
  //       showCupertinoDialog(
  //           context: context,
  //           builder: (context) {
  //             return CupertinoAlertDialog(
  //               title: Text('提示'),
  //               content: Text(data.msg),
  //               actions: <Widget>[
  //                 // CupertinoDialogAction(child: Text('取消'),onPressed: (){},),
  //                 CupertinoDialogAction(
  //                   child: Text('确认'),
  //                   onPressed: () {
  //                     Get.back();
  //                   },
  //                 ),
  //               ],
  //             );
  //           });
  //     }

  //     // showCupertinoDialog(
  //     //     context: context,
  //     //     builder: (context) {
  //     //       return CupertinoAlertDialog(
  //     //         title: Text('恭喜填写正确'),
  //     //         //content: Text("填写正确"),
  //     //         actions: <Widget>[
  //     //           CupertinoDialogAction(
  //     //             child: Text('确定'),
  //     //             onPressed: () {
  //     //               Get.back();
  //     //             },
  //     //           ),
  //     //         ],
  //     //       );
  //     //     });
  //   } else {
  //     //  TipDialogHelper.success("已为您匹配下一批好友");

  //     showCupertinoDialog(
  //         context: context,
  //         builder: (context) {
  //           return CupertinoAlertDialog(
  //             title: Text('不正确的微信号'),
  //             //content: Text("填写正确"),
  //             actions: <Widget>[
  //               CupertinoDialogAction(
  //                 child: Text('确定'),
  //                 onPressed: () {
  //                   Get.back();
  //                 },
  //               ),
  //             ],
  //           );
  //         });
  //   }
  // }
}

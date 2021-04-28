import 'dart:convert';

import 'package:addfans/Class/QrcodesClass.dart';
import 'package:addfans/Common/server_config.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:addfans/IndexAddfansToushu/IndexAddfansQunJietuPageView.dart';
import 'package:addfans/IndexAddfansUploadPage/IndexAddfansUploadQrcodePageView.dart';
import 'package:addfans/MemberPage/MemberMyQrcodePageVIew.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'CheckAddStatus.dart';
import 'IndexAddfansProvider.dart';

class UpTopDialogPageView extends StatefulWidget {
  UpTopDialogPageView({Key key}) : super(key: key);

  @override
  _UpTopDialogPageViewState createState() => _UpTopDialogPageViewState();
}

class _UpTopDialogPageViewState extends State<UpTopDialogPageView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IndexAddfansUpTopProvider>(
        create: (context) => IndexAddfansUpTopProvider.instance(),
        child: Consumer<IndexAddfansUpTopProvider>(
          builder: (context, viewModel, child) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text("我的名片"),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xff64C28E),
                //shape: StadiumBorder(side: BorderSide(width: 2, style: BorderStyle.solid, color: Colors.pink)),
                //elevation: 0,
                onPressed: () async {
                  if (viewModel.data.data.length == 0) {
                    Get.to(IndexAddfansUploadQrcodePageView(), opaque: false);
                  }else{
                    diaLog("如果想换名片请删除上面的");
                  }
                },
                child: Text("发布"),
              ),
              body: FutureBuilder(
                  future: viewModel.request(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) Center(child: Text("加载中"));
                    if (snapshot.hasError) return Center(child: Text("网络错误"));
                    if (snapshot.hasData) {
                      if (viewModel.data.data.length == 0) return Center(child: Text("你还没上传名片"));
                      return ListView(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                ...viewModel.data.data.map(
                                  (e) => Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                imageUrl: checkServerUrl(e.headImg),
                                                width: ScreenUtil().setWidth(60),
                                                height: ScreenUtil().setWidth(60),
                                                fit: BoxFit.cover,
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(e.wechatName, style: TextStyle(fontWeight: FontWeight.w500)),
                                                  Row(children: <Widget>[Text("微信号："), Text(e.wechatId)]),
                                                  Row(children: <Widget>[Text("手机号："), Text(e.userPhone)]),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                child: Text("按住删除", style: TextStyle(color: Colors.black26, fontWeight: FontWeight.w300)),
                                                onLongPress: () async {
                                                  QrcodesClass data;
                                                  var formData = {"id": e.id};
                                                  await requestPost('DelQrcode', formData: formData).then((val) {
                                                    data = QrcodesClass.fromJson(val);
                                                    //  print(val);
                                                  });
                                                  if (data.status == -1) {
                                                    //Get.back(result: 'sucess');
                                                    diaLog(data.msg);
                                                  }
                                                  if (data.status == 1) {
                                                    //Get.back(result: 'sucess');
                                                    diaLog(data.msg);
                                                    setState(() {});
                                                  }
                                                },
                                              ),
                                              OutlineButton(
                                                child: Text('刷新置顶'),
                                                onPressed: () async {
                                                  QrcodesClass data;
                                                  var formData = {"id": e.id, "qrcode_url": e.qrcodeUrl};
                                                  await requestPost('UpTop', formData: formData).then((val) {
                                                    data = QrcodesClass.fromJson(val);
                                                    //  print(val);
                                                  });

                                                  if (data.status == -2) {
                                                    showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CupertinoAlertDialog(
                                                            title: Text('每天只有1次任务机会'),
                                                            content: Text(data.msg),
                                                            actions: <Widget>[
                                                              // CupertinoDialogAction(child: Text('取消'),onPressed: (){},),
                                                              CupertinoDialogAction(
                                                                child: Text(
                                                                  '1.打开海报',
                                                                  style: TextStyle(color: Colors.pink),
                                                                ),
                                                                onPressed: () {
                                                                  Get.back();
                                                                  Get.to(MemberMyQrcodePageVIew(), opaque: false);
                                                                },
                                                              ),
                                                              CupertinoDialogAction(
                                                                child: Text(
                                                                  '2.上传截图(30分钟内截图有效)',
                                                                  style: TextStyle(color: Colors.pink),
                                                                ),
                                                                onPressed: () {
                                                                  Get.back();

                                                                  Get.to(IndexAddfansQunJietuPageView(), opaque: false);
                                                                },
                                                              ),
                                                              CupertinoDialogAction(
                                                                child: Text('关闭'),
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }

                                                  if (data.status == -3) {
                                                    showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CupertinoAlertDialog(
                                                            title: Text('收到投诉'),
                                                            content: Text(data.msg),
                                                            actions: <Widget>[
                                                              // CupertinoDialogAction(child: Text('取消'),onPressed: (){},),
                                                              CupertinoDialogAction(
                                                                child: Text('确定'),
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                              ),
                                                              CupertinoDialogAction(
                                                                child: Text(
                                                                  '查看截图',
                                                                  style: TextStyle(color: Colors.pink),
                                                                ),
                                                                onPressed: () async {
                                                                  var formData = {"qrcode_id": e.id};
                                                                  Map toushulist;
                                                                  await requestPost('Toushulist', formData: formData).then((val) {
                                                                    toushulist = val;
                                                                    //  print(val);
                                                                  });
                                                                  // Get.back(result: 'sucess');
                                                                  toushujietu(toushulist);

                                                                  // diaLog(data.msg);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                  if (data.status == -1) {
                                                    showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CupertinoAlertDialog(
                                                            title: Text('提示'),
                                                            content: Text(data.msg),
                                                            actions: <Widget>[
                                                              CupertinoDialogAction(
                                                                child: Text('等等吧'),
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                              ),
                                                              CupertinoDialogAction(
                                                                child: Text(
                                                                  '使用小红花置顶',
                                                                  style: TextStyle(color: Colors.pink),
                                                                ),
                                                                onPressed: () async {
                                                                  var formData = {"id": e.id, "isred": 1};
                                                                  await requestPost('UpTop', formData: formData).then((val) {
                                                                    data = QrcodesClass.fromJson(val);
                                                                    //  print(val);
                                                                  });
                                                                  Get.back(result: 'sucess');
                                                                  diaLog(data.msg);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                  if (data.status == 1) {
                                                    Get.back(result: 'sucess');
                                                    diaLog(data.msg);
                                                  }
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Divider(),
                                      Text("请确保你已经关闭了好友验证，否则会被平台禁用3天。", style: TextStyle(color: Colors.pink)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else
                      return Container();
                  }),
            );
          },
        ));
  }

  toushujietu(Map data) {
    print(data);

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return GestureDetector(
              onTap: () {
                Get.back();
              },
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Image.network(
                    data['data']['ts_img'],
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height - 10,
                  ),
                  Image.network(
                    data['data']['ts_img3'],
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height - 10,
                  ),
                ],
              ));
        });
  }

  diaLog(String msg) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('提示'),
            content: Text(msg),
            actions: <Widget>[
              // CupertinoDialogAction(child: Text('取消'),onPressed: (){},),
              CupertinoDialogAction(
                child: Text('确认'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        });
  }
}

import 'dart:io';

import 'package:addfans/Class/QrcodesClass.dart';
import 'package:addfans/Common/server_config.dart';
import 'package:addfans/IndexAddfansPage/CheckAddStatus.dart';
import 'package:addfans/IndexAddfansToushu/IndexAddfansToushuPageView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:tip_dialog/tip_dialog.dart';

import 'IndexAddfansProvider.dart';

class IndexAddfansFinishedPageView extends StatefulWidget {
  final int viewType;
  const IndexAddfansFinishedPageView({Key key, this.viewType}) : super(key: key);

  @override
  _IndexAddfansFinishedPageViewState createState() => _IndexAddfansFinishedPageViewState();
}

class _IndexAddfansFinishedPageViewState extends State<IndexAddfansFinishedPageView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ScreenUtil().setHeight(45)),
        child: AppBar(
          elevation: 0.2,
          backgroundColor: const Color(0xFFECECEC),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Color(0xFFECECEC),
            labelColor: Colors.black87,
            indicatorWeight: 1,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(18)),
            unselectedLabelColor: Colors.black54,
            controller: this._tabController,
            tabs: <Widget>[
              Tab(text: "等待兑换"),
              Tab(text: "已经兑换"),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: this._tabController,
        children: <Widget>[
          item(1),
          item(2),
        ],
      ),
    );
  }

  Widget item(int status) {
    return ChangeNotifierProvider<IndexAddfansProvider>(
        create: (context) => IndexAddfansProvider.instance(),
        child: Consumer<IndexAddfansProvider>(
          builder: (context, viewModel, child) {
            return FutureBuilder(
                future: viewModel.request(status),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView(
                      children: <Widget>[
                        SizedBox(height: 6),
                        Center(
                          child: Wrap(
                            children: <Widget>[
                              ...viewModel.data.data.map((e) => AnimationLimiter(
                                    child: AnimationConfiguration.staggeredList(
                                      position: viewModel.data.data.indexOf(e),
                                      duration: const Duration(milliseconds: 375),
                                      // FadeInAnimation
                                      // SlideAnimation verticalOffset: 50.0,
                                      // ScaleAnimation
                                      // FlipAnimation
                                      child: FadeInAnimation(
                                        //verticalOffset: 50.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            _simpleDialog(context, viewModel, e.id, checkServerUrl(e.headImg), checkServerUrl(e.qrcodeImg), checkServerUrl(e.qrcodeUrl), e.userId);
                                          },
                                          child: Card(
                                            child: Stack(
                                              //crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                CachedNetworkImage(
                                                  progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                  imageUrl: checkServerUrl(e.headImg),
                                                  width: ScreenUtil().setWidth(66),
                                                  height: ScreenUtil().setWidth(66),
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  // padding: const EdgeInsets.all(4.0),
                                                  child: Container(
                                                      height: ScreenUtil().setHeight(20),
                                                      color: Colors.black87,
                                                      child: Center(child: Text("ID:" + e.id.toString(), style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(13))))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Offstage(
                          offstage: status == 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: OutlineButton(
                              child: Text('批量换成小红花'), //
                              onPressed: () async {
                                var res = await Get.bottomSheet(CheckAddStatus(dataArray: viewModel.data.data.toList()));
                                if (res == "ok") {
                                  viewModel.changeTabBarIndex(widget.viewType);

                                  Get.back();
                                }
                                // QrcodesClass res = await viewModel.duihuan(viewModel.data.data.toList());
                                // if (res.status == 1) {
                                //   showCupertinoDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return CupertinoAlertDialog(
                                //           title: Text('提示'),
                                //           content: Text(res.msg),
                                //           actions: <Widget>[
                                //             CupertinoDialogAction(
                                //               child: Text('确认'),
                                //               onPressed: () {
                                //                 Get.back();
                                //               },
                                //             ),
                                //           ],
                                //         );
                                //       });
                                //   viewModel.changeTabBarIndex(widget.viewType);
                                // }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Scaffold();
                  }
                });
          },
        ));
  }

  _simpleDialog(context, IndexAddfansProvider viewModel, int id, String headImg, String qrcodeImg, String qrcodeUrl, int userId) async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('名片编号:' + id.toString()),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('1、设置成未添加'),
                onPressed: () {
                  viewModel.setAddStatus(id);
                  Navigator.pop(context, 'a');
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('2、投诉她[没有关掉好验证]'),
                onPressed: () {
                  print('Option B');
                  Navigator.pop(context, 'b');
                },
              ),
              // Divider(),
              // SimpleDialogOption(
              //   child: Text('3、提醒她微信异常'),
              //   onPressed: () {
              //     viewModel.setAddStatus(id);
              //     Navigator.pop(context, 'c');
              //   },
              // ),
             // Divider(),
            ],
          );
        });

    if (result == 'b') {
      String res = await Get.to(
          IndexAddfansToushuPageView(
            qrcode_id: id,
            head_img: headImg,
            qrcode_img: qrcodeImg,
            qrcode_url: qrcodeUrl,
            to_user_id: userId,
          ),
          opaque: false);
      print(res);
      if (res.length > 0) {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('提示'),
                content: Text(res),
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
      }
    }
    print(result);
  }

  faq(List<Data> dataArray, IndexAddfansProvider viewModel, context) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Center(
                        child: new Text("上面好友都添加完成了吗？", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red, fontSize: 20)),
                      ),
                      SizedBox(height: 10),
                      Text("请认真选择，系统会随机抽查您的加粉情况。", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black45)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          OutlineButton(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            disabledBorderColor: Colors.black,
                            highlightedBorderColor: Colors.red,
                            child: Text('我加完了'),
                            onPressed: () async {
                              //addFinished(dataArray);
                              await viewModel.addFinished(dataArray);
                              viewModel.changeTabBarIndex(widget.viewType);
                              Get.back();
                            },
                          ),
                          OutlineButton(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            disabledBorderColor: Colors.black,
                            highlightedBorderColor: Colors.red,
                            child: Text('啥也没干'),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          OutlineButton(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            disabledBorderColor: Colors.black,
                            highlightedBorderColor: Colors.red,
                            child: Text('再试一次'),
                            onPressed: () {
                              shareQrcodes(dataArray);
                              Get.back();
                            },
                          ),
                        ],
                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     OutlineButton(
                      //       child: Text('没有'),
                      //       onPressed: () {Get.back();},
                      //     ),
                      //     OutlineButton(
                      //       child: Text('已经加完'),
                      //       onPressed: () {Get.back();},
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                )),
          );
        });
  }

  Widget stepView() {
    return Container(
      height: 300,
      width: 300,
      child: Stepper(
        //type: StepperType.horizontal,
        currentStep: 2, // <-- 激活的下标
        steps: <Step>[
          new Step(
            title: new Text('第一步'),
            content: new Text('第一步内容'),
            state: StepState.complete,
            isActive: true,
            subtitle: new Text('第一步小标题'),
          ),
          new Step(
            title: new Text('第二步'),
            content: new Text('第二步内容'),
          ),
          new Step(
            title: new Text('第三步'),
            content: new Text('第三步内容'),
          ),
        ],
      ),
    );
  }
}

addFinished(List<Data> dataArray) {}
shareQrcodes(List<Data> dataArray) async {
  // key.currentState.showSnackBar(SnackBar(content: Text('标题复制成功，正在准备图片')));
  Directory dir = await getApplicationDocumentsDirectory();
  Response response;
  var imagesTemp = List<String>();

  for (var i = 0; i < dataArray.length; i++) {
    String name = DateTime.now().millisecondsSinceEpoch.toString() + ".png";
    response = await Dio().download(serverUrl + dataArray[i].qrcodeImg, "${dir.path}/$name");
    if (response.statusCode == 200) {
      String imagePath = "${dir.path}/$name";
      imagesTemp.add(imagePath);
    }
  }
  await ShareExtend.shareMultiple(imagesTemp, "image");
}

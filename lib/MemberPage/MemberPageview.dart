import 'package:addfans/Common/server_config.dart';
import 'package:addfans/MemberPage/MemberPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'MemberMyQrcodePageVIew.dart';

class MemberPageView extends StatelessWidget {
  const MemberPageView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemberPageProvider>(
        create: (context) => MemberPageProvider.instance(),
        child: Consumer<MemberPageProvider>(
          builder: (context, viewModel, child) {
            return FutureBuilder(
                future: viewModel.request(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Scaffold(
                      backgroundColor: Color(0xff4f5f6),
                      body: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                              height: ScreenUtil().setHeight(155),
                              color: Color(0xff64C28E),
                              child: SafeArea(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(28.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            viewModel.data.data.userInfo.userPhone,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20),
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                          // SizedBox(height: 5),
                                          Text("ID:" + viewModel.data.data.userInfo.shareCode.toString(),
                                              style: TextStyle(
                                                fontSize: ScreenUtil().setSp(15),
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipOval(
                                        child: Image.network(
                                          //data.data.userPhoto.toString(),
                                          checkServerUrl(viewModel.data.data.userInfo.headImg),
                                          width: ScreenUtil().setWidth(75),
                                          height: ScreenUtil().setHeight(75),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverFillRemaining(
                            child: Stack(
                              children: <Widget>[
                                Container(height: ScreenUtil().setHeight(50), color: Color(0xff64C28E)),
                                Column(
                                  children: <Widget>[
                                    Card(
                                      elevation: 2.0, //设置阴影
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))), //设置圆角
                                      margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: new BoxDecoration(
                                              //color: Color(0xFFf1f1f1),
                                              borderRadius: new BorderRadius.circular((10.0)),
                                            ),
                                            height: ScreenUtil().setHeight(72),
                                            width: MediaQuery.of(context).size.width - 8,
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(viewModel.data.data.userInfo.userMoney.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20))),
                                                      SizedBox(height: 5),
                                                      Text("我的钱包", style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xffB8B8B8)))
                                                    ],
                                                  ),
                                                  Container(
                                                      height: ScreenUtil().setHeight(40),
                                                      child: VerticalDivider(
                                                        color: Colors.grey,
                                                        // width: ScreenUtil().setWidth(100),
                                                      )),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("" + viewModel.data.data.userInfo.userScore.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20))),
                                                      SizedBox(height: 5),
                                                      Text("小红花", style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xffB8B8B8)))
                                                    ],
                                                  ),
                                                  Container(
                                                      height: ScreenUtil().setHeight(40),
                                                      child: VerticalDivider(
                                                        color: Colors.grey,
                                                        // width: ScreenUtil().setWidth(100),
                                                      )),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(viewModel.data.data.userInfo.lockScore.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20))),
                                                      SizedBox(height: 5),
                                                      Text("红花种子", style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xffB8B8B8)))
                                                    ],
                                                  ),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Card(
                                        elevation: 1.0, //设置阴影
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))), //设置圆角
                                        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onTap: () {
                                                  Get.to(MemberMyQrcodePageVIew(), opaque: false);
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                                  Row(children: <Widget>[
                                                    Image.asset("assets/images/邀请码.png", width: ScreenUtil().setWidth(25), height: ScreenUtil().setHeight(25), color: Colors.orange),
                                                    SizedBox(width: ScreenUtil().setWidth(10)),
                                                    Text("我的邀请码", style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w400))
                                                  ]),
                                                  Row(children: <Widget>[
                                                    Text(viewModel.data.data.userInfo.shareCode.toString(),
                                                        style: TextStyle(color: Colors.black38, fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w300)),
                                                    Icon(Icons.keyboard_arrow_right, size: ScreenUtil().setSp(30), color: Colors.black26)
                                                  ]),
                                                ]),
                                              ),
                                              Divider(height: ScreenUtil().setHeight(25)),
                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                                Row(children: <Widget>[
                                                  Image.asset("assets/images/说明书.png", width: ScreenUtil().setWidth(25), height: ScreenUtil().setHeight(25), color: Colors.orange),
                                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                                  Text("帮助中心", style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w400))
                                                ]),
                                                Row(children: <Widget>[
                                                  // Text(viewModel.data.data.userInfo.shareCode.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
                                                  Icon(Icons.keyboard_arrow_right, size: ScreenUtil().setSp(30), color: Colors.black26)
                                                ]),
                                              ]),
                                              Divider(height: ScreenUtil().setHeight(25)),
                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                                Row(children: <Widget>[
                                                  Image.asset("assets/images/合作.png", width: ScreenUtil().setWidth(25), height: ScreenUtil().setHeight(25), color: Colors.orange),
                                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                                  Text("商务合作", style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w400))
                                                ]),
                                                Row(children: <Widget>[
                                                  // Text(viewModel.data.data.userInfo.shareCode.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
                                                  Icon(Icons.keyboard_arrow_right, size: ScreenUtil().setSp(30), color: Colors.black26)
                                                ]),
                                              ])
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Scaffold();
                  }
                });
          },
        ));
  }
}

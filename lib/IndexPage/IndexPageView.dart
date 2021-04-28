import 'package:addfans/IndexAddfansTypePage/IndexAddfansTypePageView.dart';
import 'package:addfans/MemberPage/MemberPageview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

import 'IndexPageProvider.dart';

class IndexPageView extends StatelessWidget {
  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('批量加粉')),
    BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('名片互推')),
    BottomNavigationBarItem(icon: Icon(Icons.card_travel), title: Text('抖音')),
    BottomNavigationBarItem(icon: Icon(Icons.my_location), title: Text('我的')),
  ];

  final List<Widget> tabList = [
    Stack(
      children: <Widget>[
        IndexAddfansTypePageView(),
        TipDialogContainer(
            duration: const Duration(seconds: 3),
            outsideTouchable: true,
            onOutsideTouch: (Widget tipDialog) {
              if (tipDialog is TipDialog && tipDialog.type == TipDialogType.LOADING) {
                TipDialogHelper.dismiss();
              }
            })
      ],
    ),
    Center(child: Text("名片互推概念\n\n顾名思义\n就是两个人在达成协议的情况下\n将彼此的名片推荐给对方的微信好友\n（名片、海报、文字信息均可)\n\n由平台认证对方好友数量 辅助群发\n无需密码，安全可靠，用完即止。"),),
    MemberPageView(),
    MemberPageView()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896);
    return ChangeNotifierProvider<IndexPageProvider>(
      create: (context) => IndexPageProvider.instance(),
      child: Consumer<IndexPageProvider>(
        builder: (context, viewModel, child) {
          return Scaffold(
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
         
            body: tabList[viewModel.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              // unselectedItemColor: Colors.blue,
              // selectedItemColor: Colors.blue,
              type: BottomNavigationBarType.fixed,
              currentIndex: viewModel.currentIndex,
              items: items,
              onTap: (int index) {
                viewModel.changeCurrentIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}

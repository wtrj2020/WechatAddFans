import 'package:addfans/IndexAddfansPage/IndexAddfansFinishedPageView.dart';
import 'package:addfans/IndexAddfansPage/IndexAddfansWaitPageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

class IndexAddfansTypePageView extends StatefulWidget {
  final String orderStatus;
  final int id;
  IndexAddfansTypePageView({Key key, this.orderStatus, this.id}) : super(key: key);

  _IndexAddfansTypePageViewState createState() => _IndexAddfansTypePageViewState();
}

class _IndexAddfansTypePageViewState extends State<IndexAddfansTypePageView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    //_tabController.animateTo(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[20],
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Color(0xFFECECEC),
            centerTitle: true,
            elevation: 0,
            title: Text("非常人脉",style: TextStyle(fontSize: ScreenUtil().setSp(18))),
            bottom: TabBar(
              isScrollable: false,
              indicatorColor: Color(0xff64C28E),
              //labelColor: Colors.black87,indicatorWeight
              //Color(0xff64C28E),
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(18)),
              unselectedLabelColor: Colors.black54,
              controller: this._tabController,
              tabs: <Widget>[
                Tab(text: "最佳配对"),
                Tab(text: "我添加的"),
                Tab(text: "被谁添加"),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(ScreenUtil().setHeight(70))),
      body: TabBarView(
        controller: this._tabController,
        children: <Widget>[
          IndexAddfansWaitPageView(viewType: 0),
          IndexAddfansFinishedPageView(viewType: 1),
          IndexAddfansFinishedPageView(viewType: 1),
        ],
      ),
    );
  }
}

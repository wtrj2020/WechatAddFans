import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'Common/localizations.dart';
import 'IndexPage/IndexPageView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '非常人脉',
      navigatorKey: Get.key,
      theme: ThemeData(primarySwatch: Colors.red, primaryColor: Color(0xff64C28E)), //设置App主题
      home: IndexPageView(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate,
      ],
      //supportedLocales: Platform.isIOS ? ios : an,
      locale: Locale('zh'),
    );
  }
}

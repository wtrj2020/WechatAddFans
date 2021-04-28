import 'dart:async';
import 'dart:convert';

import 'package:addfans/LoginPage/LoginPageView.dart';
import 'package:addfans/LoginPage/RefPageView.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'httpHeaders.dart';
import 'server_config.dart';

String token;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future requestPost(url, {formData}) async {
  final SharedPreferences prefs = await _prefs;
  token = prefs.getString("token");
  try {
    print('\n------post----------------------------------');
    print(jsonEncode(formData));
    print('post:请求url:${serverPath[url]}\n');
    print('-------end------------------------------------------\n\n');

    Response response;
    Dio dio = new Dio();
    dio.options.headers = httpHeaders;
    // dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['token'] = token;
    if (formData == null) {
      response = await dio.post(serverPath[url]);
    } else {
      response = await dio.post(serverPath[url], data: formData);
    }

    if (response.statusCode == 200) {
      print(response.data['status']);
      if (response.data['status'] == -100) {
        prefs.remove("token");
        Get.offAll(RegPageView());
      }
      return response.data;
    } else {
      //throw Exception('后端接口出现异常。');
    }
  } catch (e) {
    return print('发生错误:=====$e');
  }
}

Future requestGet(url, {formData}) async {
  final SharedPreferences prefs = await _prefs;
  token = prefs.getString("token");

  try {
    print('\n------get----------------------------------');
    print(jsonEncode(formData));
    print('get:请求url:${serverPath[url]}\n');
    print('-------end------------------------------------------\n\n');

    Response response;
    Dio dio = new Dio();
    dio.options.headers = httpHeaders;
    dio.options.headers['token'] = token;
    response = await dio.get(serverPath[url]);
    if (response.statusCode == 200) {
      if (response.data['status'] == -100) {
        prefs.remove("token");
       // Get.offAll(LoginPageView());
        Get.offAll(LoginPageView());
      }
      return response.data;
    } else {
      throw Exception('后端接口出现异常。');
    }
  } catch (e) {
    return print('发生错误:=====$e');
  }
}

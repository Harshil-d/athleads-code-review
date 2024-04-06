import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:athleads/src/configs/debug.dart';
// 
import 'package:athleads/src/configs/Utils.dart';
import 'package:athleads/src/model/APIModel.dart';
import 'package:athleads/src/model/UserData.dart';
import 'package:athleads/src/apis/firebase_auth.dart' as repository;
import 'package:http/http.dart' as http;

dynamic checkAPIResponse(Response response, GlobalKey<ScaffoldState> scaffoldKey) {
  log('checkAPIResponse => ${response.body}');
  switch (response.statusCode) {
    case 200: //Success
      return true;
    case 201: //Success
      return true;
    case 400:
      String msg = json.decode(response.body)['message'];
      Utils.showSnackBar(msg.isNotEmpty ? msg : "Something went wrong", scaffoldKey.currentState!);

      return false;
    case 401: //UnAuthorized User
      Utils.showSnackBar("Your session has been expired", scaffoldKey.currentState!);
      if (!Utils.isSessionExpiredManage) {
        Utils.isSessionExpiredManage = true;
        Future.delayed(const Duration(seconds: 2)).then((value) {
          if (ModalRoute.of(scaffoldKey.currentContext!)!.settings.name != '/LoginScreen') {
            repository.logoutUser();
            Navigator.pushNamed(scaffoldKey.currentContext!, '/LoginScreen', arguments: json.encode({'hasBack': false, 'fromGuest': false}));
          }
        });
      }

      break;
    case 500: //Internal server error
      String msg = json.decode(response.body)['message'];
      Utils.showSnackBar(msg.isNotEmpty ? msg : "Something went wrong", scaffoldKey.currentState!);
      return false;

    case 99: //server maintenance
    //break;
    case 298: //HARD update
      updateAPKDialog(2, scaffoldKey.currentContext!);
      break;

    case 503: //server maintenance
      Navigator.pushReplacementNamed(scaffoldKey.currentContext!, '/ServerError');
      break;

    default:
      break;
  }
}

Future<APIModel> apiHelper({required GlobalKey<ScaffoldState> scaffoldKey, required String method, required String url, dynamic body, dynamic header}) async {
  APIModel apiModel = APIModel();
  final client = http.Client();
  final Response response;

  Debug.setLog('call_api $url');
  Debug.setLog('call_api $body');
  Debug.setLog('check_header $header');
  if (header != null) {
    if (header.containsKey('authorization')) {
      UserData userData = await repository.getCurrentUser();
      if (userData.credential != null) {
        int lastTokenTime = await Utils.getPrefInteger('lastTokenTime');

        DateTime lastTime = DateTime.fromMillisecondsSinceEpoch(lastTokenTime);
        DateTime nextTime = DateTime(lastTime.year, lastTime.month, lastTime.day, lastTime.hour, lastTime.minute, lastTime.second, lastTime.millisecond + userData.credential!.expiresIn); //refresh token if expired

        Debug.setLog('checkToken_timing $lastTime  $nextTime ${userData.credential!.expiresIn}');

        //get new token
        if (nextTime.isBefore(DateTime.now())) {
          final String url = '${GlobalConfiguration().getString('api_base_url')}/auth/refreshToken';

          final response = await client.post(Uri.parse(url), body: json.encode({"refreshToken": userData.credential!.refreshToken}), headers: {HttpHeaders.contentTypeHeader: 'application/json'});

          var result = checkAPIResponse(response, scaffoldKey);

          Debug.setLog('api_response $url ${response.body}');
          if (result != null) {
            if (result) {
              Credential data = Credential.fromJSON(json.decode(response.body)['data']['credential']);
              userData.credential = data;
              repository.setCurrentUser(userData);
              Utils.setPrefInteger('lastTokenTime', DateTime.now().millisecondsSinceEpoch);
              header['authorization'] = 'Bearer ${userData.credential!.accessToken}';
            }
          }
        }
      }
    }
  }

  try {
    var packageInfo = await PackageInfo.fromPlatform();

    //set for app versioning for upadates
    header['os'] = Platform.isAndroid ? 'Android' : 'iOS';
    header['client-app-version'] = packageInfo.version;

    Debug.setLog('check_headers $header');

    if (method == 'get') {
      response = await client.get(Uri.parse(url), headers: header);
    } else if (method == 'put') {
      response = await client.put(Uri.parse(url), headers: header, body: body);
    } else if (method == 'delete') {
      response = await client.delete(Uri.parse(url), headers: header, body: body);
    } else {
      //post
      response = await client.post(Uri.parse(url), headers: header, body: body);
    }

    var result = checkAPIResponse(response, scaffoldKey);
    apiModel.statuscode = response.statusCode;

    Debug.setLog('api response- $result');

    if (result != null) {
      if (result) {
        apiModel.response = true;
        apiModel.data = json.decode(response.body)['data'];
      } else {
        apiModel.response = false;
        apiModel.msg = json.decode(response.body)['message'];
      }
    }
  } on SocketException {
    showInternetDialog(scaffoldKey);
  }

  return apiModel;
}

Future<APIModel> paymentApiHelper({required GlobalKey<ScaffoldState> scaffoldKey, required String method, required String url, dynamic body, dynamic header}) async {
  APIModel apiModel = APIModel();
  final client = http.Client();
  final Response response;

  Debug.setLog('check_header $header');
  if (header != null) {
    if (header.containsKey('authorization')) {
      UserData userData = await repository.getCurrentUser();
      if (userData.credential != null) {
        int lastTokenTime = await Utils.getPrefInteger('lastTokenTime');

        DateTime lastTime = DateTime.fromMillisecondsSinceEpoch(lastTokenTime);
        DateTime nextTime = DateTime(lastTime.year, lastTime.month, lastTime.day, lastTime.hour, lastTime.minute, lastTime.second, lastTime.millisecond + userData.credential!.expiresIn); //refresh token if expired

        Debug.setLog('checkToken_timing $lastTime  $nextTime ${userData.credential!.expiresIn}');

        //get new token
        if (nextTime.isBefore(DateTime.now())) {
          final String url = '${GlobalConfiguration().getString('api_base_url')}/auth/refreshToken';

          final response = await client.post(Uri.parse(url), body: json.encode({"refreshToken": userData.credential!.refreshToken}), headers: {HttpHeaders.contentTypeHeader: 'application/json'});

          var result = checkAPIResponse(response, scaffoldKey);

          if (result != null) {
            if (result) {
              Credential data = Credential.fromJSON(json.decode(response.body)['data']['credential']);
              userData.credential = data;
              repository.setCurrentUser(userData);
              Utils.setPrefInteger('lastTokenTime', DateTime.now().millisecondsSinceEpoch);
              header['authorization'] = 'Bearer ${userData.credential!.accessToken}';
            }
          }
        }
      }
    }
  }

  try {
    var packageInfo = await PackageInfo.fromPlatform();

    //set for app versioning for upadates
    header['os'] = Platform.isAndroid ? 'Android' : 'iOS';
    header['client-app-version'] = packageInfo.version;

    Debug.setLog('check_headers $header');

    if (method == 'get') {
      response = await client.get(Uri.parse(url), headers: header);
    } else if (method == 'put') {
      response = await client.put(Uri.parse(url), headers: header, body: body);
    } else if (method == 'delete') {
      response = await client.delete(Uri.parse(url), headers: header, body: body);
    } else {
      //post
      response = await client.post(Uri.parse(url), headers: header, body: body);
    }

    //log('API_res $url ${response.statusCode} ${response.body}');
    //var result = checkAPIResponse(response, scaffoldKey);
    apiModel.statuscode = response.statusCode;

    if (response.statusCode == 200) {
      apiModel.response = true;
    } else {
      apiModel.response = false;
    }
    apiModel.data = json.decode(response.body);
  } on SocketException {
    showInternetDialog(scaffoldKey);
  }

  return apiModel;
}

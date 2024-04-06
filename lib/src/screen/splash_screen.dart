import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:athleads/src/configs/Utils.dart';
import 'package:athleads/src/configs/debug.dart';
import 'package:athleads/src/controllers/SplashController.dart';
import 'package:athleads/src/apis/firebase_auth.dart' as repository;
import 'package:package_info_plus/package_info_plus.dart';
import '../configs/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  bool isgoAhead = false;
  bool hasLink = false;
  bool dataSet = true;
  int hasUpdate = 0;

  SplashController? controller_;

  SplashScreenState() : super(SplashController()) {
    controller_ = controller as SplashController;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    loadData();
  }

  void fetchData() async {
    goAhead();
  }

  Future<Timer> loadData() async {
    // await initDynamicLinks();
    Debug.setLog('splash - start timer');
    return Timer(const Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    if (dataSet) {
      Debug.setLog('CheckForUpdate__ $dataSet $hasUpdate');
      if (!hasLink && hasUpdate != HARD_UPDATE) goAhead();
    } else {
      dataSet = true;
    }
  }

  void openStore() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      Utils.openMarketLink(app_url_android + packageInfo.packageName);
    } else {
      Utils.openMarketLink(app_url_ios + packageInfo.packageName);
    }
  }

  void goAhead() async {
    if (!isgoAhead) {
      isgoAhead = true;
      Navigator.pushReplacementNamed(context, '/DashBoard');
    }
  }

  void manageLink(Uri deepLink) async {
    if (deepLink.toString().contains('mode=verifyEmail')) {
      Debug.setLog('dynamic_link verifyEmail');

      List<String> strings = deepLink.toString().split('oobCode=');
      if (strings.length > 1) {
        String oobCode = strings[1].substring(0, strings[1].indexOf('&'));

        try {
          await FirebaseAuth.instance.checkActionCode(oobCode);
          await repository.verifyEmailLink(oobCode, FirebaseAuth.instance,
              (int status, dynamic data) async {
            if (status == 1) {
              Utils.emailNotifier.value = true;
              Utils.emailNotifier.notifyListeners();
              goAhead();
            } else {
              goAhead();
            }
          });
        } catch (e) {
          Debug.setLog('firebase exception $e');
          Debug.setLog('invalid oobCode');
          goAhead();
        }
      }
    } else if (deepLink.toString().contains('mode=resetPassword')) {
      Debug.setLog('dynamic_link resetPassword');

      List<String> strings = deepLink.toString().split('oobCode=');
      if (strings.length > 1) {
        String oobCode = strings[1].substring(0, strings[1].indexOf('&'));

        try {
          await FirebaseAuth.instance.checkActionCode(oobCode);

          if (isgoAhead) {
            Navigator.pushNamed(
                Utils.navigatorKey.currentContext!, '/ResetPassword',
                arguments: json.encode({"hasBack": true, "oobCode": oobCode}));
          } else {
            isgoAhead = true;
            Navigator.pushReplacementNamed(
                Utils.navigatorKey.currentContext!, '/ResetPassword',
                arguments: json.encode({"hasBack": false, "oobCode": oobCode}));
          }
        } catch (e) {
          //DYNAMIC_LINK = false;
          goAhead();
          Debug.setLog('firebase exception $e');
          Debug.setLog('invalid oobCode');
        }
      }
    } else {
      //DYNAMIC_LINK = false;
      goAhead();
      Debug.setLog('dynamic_link else');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          exit(0);
        }
        return Future<bool>.value(false);
      },
      child: Scaffold(
          key: controller_!.scaffoldKey,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_splash.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Image(
                image: const AssetImage("assets/icons/ic_logo.png"),
                width: getDeviceWidth(context) * 0.6,
              ),
            ),
          )),
    );
  }
}

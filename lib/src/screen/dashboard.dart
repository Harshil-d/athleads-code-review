import 'dart:io';

import 'package:athleads/src/configs/Utils.dart';
import 'package:athleads/src/configs/app_constants.dart';
import 'package:athleads/src/configs/colors.dart';
import 'package:athleads/src/controllers/DashBoardController.dart';
import 'package:athleads/src/elements/BigB.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, this.hasBack = false});

  final bool hasBack;

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends StateMVC<Dashboard> {
  DashBoardController? controller_;

  DashboardState() : super(DashBoardController()) {
    controller_ = controller as DashBoardController;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!(controller_!.mProgressBar.isShowing)) {
          if (widget.hasBack) {
            Navigator.pop(context);
          } else {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else {
              exit(0);
            }
          }
        }
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColors.colorThemeLDarkBlue,
        body: Column(children: [
          SizedBox(height: MediaQuery.of(context).viewPadding.top + (getDeviceWidth(context) * 0.08)),
          Center(
              child: Image.asset(
            "assets/icons/ic_logo.png",
            width: getDeviceWidth(context) * 0.6,
          )),
          Expanded(
              child: Center(
                  child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You're not following\nanyone yet.",
                style: TextStyle(color: AppColors.colorWhite, fontWeight: FontWeight.w900, fontSize: getDeviceWidth(context) * RegistrationQuestionTextSize),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: getDeviceHeight(context) * 0.05,
              ),
              BigB(
                width: 0.5,
                onTap: () {},
                text: "GET STARTED",
                backColor: AppColors.colorThemeGreen,
              ),
            ],
          )))
        ]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.colorThemeLDarkBlue,
          currentIndex: 0,
          iconSize: 20,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          useLegacyColorScheme: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Image.asset("assets/icons/ic_home._green.png", width: 25, height: 60, color: AppColors.colorWhite),
              activeIcon: Image.asset("assets/icons/ic_home._green.png", width: 25, height: 60, color: AppColors.colorThemeGreen),
              label: "",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Image.asset("assets/icons/ic_search.png", width: 25, height: 60, color: AppColors.colorWhite),
              activeIcon: Image.asset("assets/icons/ic_search.png", width: 25, height: 60, color: AppColors.colorThemeGreen),
              label: "",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Image.asset("assets/icons/ic_location_white.png", width: 25, height: 60, color: AppColors.colorWhite),
              activeIcon: Image.asset("assets/icons/ic_location_white.png", width: 25, height: 60, color: AppColors.colorThemeGreen),
              label: "",
            ),
            BottomNavigationBarItem(backgroundColor: Colors.transparent, icon: Image.asset("assets/images/profile_placeholder.png", width: 35, height: 60), label: ""),
          ],
        ),
      ),
    );
  }
}

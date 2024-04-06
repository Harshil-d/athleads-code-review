import 'package:athleads/src/configs/Utils.dart';
import 'package:athleads/src/configs/colors.dart';
import 'package:athleads/src/controllers/SetupProfileController.dart';
import 'package:athleads/src/screen/SetupProfile/education_page.dart';
import 'package:athleads/src/screen/SetupProfile/experience_page.dart';
import 'package:athleads/src/screen/SetupProfile/follow_other_page.dart';
import 'package:athleads/src/screen/SetupProfile/goals_page.dart';
import 'package:athleads/src/screen/SetupProfile/overview_page.dart';
import 'package:athleads/src/screen/SetupProfile/performance_page.dart';
import 'package:athleads/src/screen/SetupProfile/upload_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({Key? key}) : super(key: key);

  @override
  SetupProfileScreenState createState() => SetupProfileScreenState();
}

class SetupProfileScreenState extends StateMVC<SetupProfileScreen> {
  SetupProfileController? controller_;
  final _pageController = PageController();
  final pageCount = 7;

  SetupProfileScreenState() : super(SetupProfileController()) {
    controller_ = controller as SetupProfileController;
  }

  Widget addPadding(Widget child) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: getDeviceWidth(context) * 0.05), child: child);
  }

  popScreen(context) {
    if (_pageController.page == 0) {
      return Navigator.of(context).pop();
    } else {
      return _pageController.previousPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (!(controller_!.mProgressBar.isShowing)) {
            Navigator.pop(context);
          }
          return Future<bool>.value(false);
        },
        child: Scaffold(
            key: controller_!.scaffoldKey,
            body: Container(
                width: double.infinity,
                color: AppColors.colorThemeLDarkBlue,
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(
                      flex: 3,
                      child: Center(
                          child: Stack(children: [
                        Positioned(
                            top: 0,
                            bottom: 0,
                            left: getDeviceWidth(context) * 0.08,
                            child: Center(
                                child: InkWell(
                                    onTap: () => popScreen(context),
                                    child: SizedBox(
                                      width: getDeviceHeight(context) * 0.06,
                                      height: getDeviceHeight(context) * 0.06,
                                      child: Center(child: Image.asset("assets/icons/ic_arrow_left.png", width: getDeviceHeight(context) * 0.014)),
                                    ))))
                      ]))),
                  Expanded(
                    flex: 10,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        addPadding(UploadPhotoPage(
                          onNext: (title) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(OverviewPage(
                          onNext: (title) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(ExperiencePage(
                          onNext: (title) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(EducationPage(
                          onNext: (String institution, String dos, String gpa, String egy) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(PerformancePage(
                          onNext: (String verticalJump, String dash, String longJump, String beepTest) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(GoalPage(
                          onNext: (title) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(FollowOtherPage(
                          onNext: (title) {
                            Navigator.pushReplacementNamed(context, '/DashBoard');
                          },
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: getDeviceHeight(context) * 0.034),
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: pageCount,
                      effect: ExpandingDotsEffect(
                        activeDotColor: AppColors.colorThemeGreen,
                        dotColor: AppColors.colorWhite,
                        dotHeight: getDeviceWidth(context) * 0.025,
                        dotWidth: getDeviceWidth(context) * 0.025,
                      ),
                    ),
                  )
                ]))));
  }
}

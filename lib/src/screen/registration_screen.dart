import 'package:athleads/src/configs/Utils.dart';
import 'package:athleads/src/configs/colors.dart';
import 'package:athleads/src/controllers/RegistrationController.dart';
import 'package:athleads/src/screen/Registration/birthday_page.dart';
import 'package:athleads/src/screen/Registration/email_page.dart';
import 'package:athleads/src/screen/Registration/gender_page.dart';
import 'package:athleads/src/screen/Registration/name_page.dart';
import 'package:athleads/src/screen/Registration/set_password_page.dart';
import 'package:athleads/src/screen/Registration/title_page.dart';
import 'package:athleads/src/screen/Registration/user_name_page.dart';
import 'package:athleads/src/screen/Registration/verify_email_page.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends StateMVC<RegistrationScreen> {
  RegistrationController? controller_;
  final _pageController = PageController();
  final pageCount = 8;

  RegistrationScreenState() : super(RegistrationController()) {
    controller_ = controller as RegistrationController;
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
            popScreen(context);
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
                        Positioned.fill(
                            child: Center(
                                child: Image.asset(
                          "assets/icons/logo_a_green.png",
                          width: getDeviceHeight(context) * 0.04,
                        ))),
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
                        addPadding(TitlePage(
                          onNext: (title) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(NamePage(
                          onNext: (firstName, lastName) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(BirthDayPage(
                          onNext: (birthday) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(GenderPage(
                          onNext: (gender) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(EmailPage(
                          onNext: (email) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(VerifyEmailPage(
                          email: "john.appleseed@icloud.com",
                          onNext: (email) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(UserNamePage(
                          onNext: (userName) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.fastLinearToSlowEaseIn);
                          },
                        )),
                        addPadding(SetPasswordPage(
                          onNext: (userName) {
                            Navigator.pushReplacementNamed(context, '/EnableLocationScreen');
                          },
                        ))
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

import 'dart:convert';
import 'package:athleads/src/screen/create_account_splash.dart';
import 'package:athleads/src/screen/dashboard.dart';
import 'package:athleads/src/screen/enable_location_screen.dart';
import 'package:athleads/src/screen/lets_setup_profile_screen.dart';
import 'package:athleads/src/screen/registration_screen.dart';
import 'package:athleads/src/screen/setup_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athleads/src/screen/login_screen.dart';
import 'package:athleads/src/screen/launcher_screen.dart';
import 'package:athleads/src/screen/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Launcher':
        return MaterialPageRoute(builder: (_) => const LauncherScreen());

      case '/Splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/CreateAccountSplash':
        return MaterialPageRoute(builder: (_) => const CreateAccountSplash(isWelcomeFlow: true));

      case '/LoginScreen':
        return CupertinoPageRoute(settings: settings, builder: (_) => LoginScreen(hasBack: json.decode(args.toString())['hasBack']));

      case '/DashBoard':
        return CupertinoPageRoute(settings: settings, builder: (_) => const Dashboard());

      case '/RegistrationScreen':
        return CupertinoPageRoute(settings: settings, builder: (_) => const RegistrationScreen());

      case '/EnableLocationScreen':
        return CupertinoPageRoute(settings: settings, builder: (_) => const EnableLocationScreen());

      case '/LetsSetupProfile':
        return CupertinoPageRoute(settings: settings, builder: (_) => const LetsSetupProfileScreen());

      case '/SetupProfileScreen':
        return CupertinoPageRoute(settings: settings, builder: (_) => const SetupProfileScreen());

      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}

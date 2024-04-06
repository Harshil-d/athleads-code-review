import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';
import 'package:athleads/route_generator.dart';
import 'package:athleads/src/configs/Utils.dart';
import 'package:athleads/src/configs/app_constants.dart';
import 'package:athleads/src/configs/colors.dart' as app_color;
import 'package:athleads/src/configs/debug.dart';
import 'package:athleads/src/screen/launcher_screen.dart';
import 'package:athleads/src/screen/splash_screen.dart';

NotificationAppLaunchDetails? notificationAppLaunchDetails;

Future<Uint8List> _getByteArrayFromUrl(String url) async {
  final Response response = await get(Uri.parse(url));
  return response.bodyBytes;
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool IsLauncherDisplayed = false;

// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp();

  IsLauncherDisplayed = await Utils.getPrefBool(IsHelp);

  if (InDevelopment) {
    await GlobalConfiguration().loadFromAsset("configurations_dev");
  } else {
    await GlobalConfiguration().loadFromAsset("configurations");
  }

  runZonedGuarded(() {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyApp());
  }, (error, stackTrace) {
    Debug.setLog('caughtError $stackTrace');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyAppState extends State<MyApp> {
  late Future<void> _initializeFlutterFireFuture;

  @override
  void initState() {
    // TODO: implement initApp
    super.initState();

    setDefaultLanguage();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));

    return MaterialApp(
      title: 'Athleads',
      initialRoute: IsLauncherDisplayed ? '/Splash' : '/Launcher',
      onGenerateRoute: RouteGenerator.generateRoute,
      onGenerateInitialRoutes: (String initialRouteName) {
        if (!IsLauncherDisplayed) {
          return [
            MaterialPageRoute(builder: (context) => const LauncherScreen())
          ];
        } else {
          return [
            MaterialPageRoute(builder: (context) => const SplashScreen())
          ];
        }
      },
      debugShowCheckedModeBanner: false,
      navigatorKey: Utils.navigatorKey,
      builder: (context, child) {
        //to remove shadow(glow) while scrolling
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Inter',
        primaryColor: Colors.white,
        brightness: Brightness.light,
        focusColor: app_color.AppColors().colorDarkText,
        hintColor: app_color.AppColors().colorLightText,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.light,
        primaryColor: app_color.AppColors.colorWhite,
      ),
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }

  void setDefaultLanguage() async {
    String language = await Utils.getPrefString('Language');
    Debug.setLog('1 language is - $language');

    if (language.isEmpty) {
      language = 'en';
      Utils.setPrefString('Language', 'en');
    }
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails axisDirection) {
    return child;
  }
}

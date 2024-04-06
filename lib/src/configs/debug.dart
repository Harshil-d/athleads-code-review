import 'app_constants.dart';

class Debug {
  static void setLog(String msg) {
    if (DEBUG) print(msg);
  }
}

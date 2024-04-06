
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:athleads/src/elements/progress_bar.dart';

class DashBoardController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late ProgressBar mProgressBar;

  DashBoardController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    mProgressBar = ProgressBar();
  }
}

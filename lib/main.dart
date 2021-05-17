import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/splash_screen.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightYellow, // navigation bar color
    statusBarColor: Color(0xffffb969), // status bar color
  ));

  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

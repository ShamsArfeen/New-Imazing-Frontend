import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_task_planner_app/screens/home_screen.dart';

import '../theme/colors/light_colors.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new AfterSplash(),
      image: new Image.asset('assets/images/circle.png'), // #1b0753
      backgroundColor: LightColors.kDarkYellow,
      title: Text(
        'Imazing',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 32.0,
          color: LightColors.kDarkBlue,
          fontWeight: FontWeight.w900,
        ),
      ),
      photoSize: 50.0,
      loaderColor: Colors.blue.shade300
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: LightColors.kDarkBlue,
              displayColor: LightColors.kDarkBlue,
              fontFamily: 'Poppins'
            ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
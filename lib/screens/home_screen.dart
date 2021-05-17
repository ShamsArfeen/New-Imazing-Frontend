import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/edit_screen.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_task_planner_app/widgets/active_project_card.dart';
import 'package:flutter_task_planner_app/widgets/top_container.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';

final picker = ImagePicker();

Future<Null> imageSelector( BuildContext context, ImageSource src) async {
  final pickedFile = await picker.getImage(source: src);
  if (pickedFile != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new MyHomePage( pickedFile.path )),
    );
  } 
}


class HomePage extends StatelessWidget {

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              height: 200,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.home,
                            color: LightColors.kDarkBlue, size: 35.0),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircularPercentIndicator(
                            radius: 90.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: 0.75,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: LightColors.kRed,
                            backgroundColor: LightColors.kDarkYellow,
                            center: CircleAvatar(
                              backgroundColor: LightColors.kBlue,
                              radius: 35.0,
                              backgroundImage: AssetImage(
                                'assets/images/circle.png',
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Imazing',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: LightColors.kDarkBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Where images come to life',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subheading('Get Started by Adding a Picture'),
                          SizedBox(height: 5.0),
                          Row(
                            children: <Widget>[
                              ActiveProjectsCard(
                                cardColor: LightColors.kGreen,
                                loadingPercent: 0.25,
                                icon: Icons.camera,
                                title: 'Use Camera',
                                subtitle: 'Take a new picture',
                                callback: () => {
                                  imageSelector( context, ImageSource.camera),
                                }
                              ),
                              SizedBox(width: 20.0),
                              ActiveProjectsCard(
                                cardColor: LightColors.kRed,
                                icon: Icons.photo_album,
                                loadingPercent: 0.6,
                                title: 'Open Gallery',
                                subtitle: 'Pick a saved picture',
                                callback: () => {
                                  imageSelector( context, ImageSource.gallery),
                                }
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

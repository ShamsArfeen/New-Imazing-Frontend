import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';


class HeaderMenu extends StatelessWidget {

  void Function() save;
  void Function() info;

  HeaderMenu(this.save, this.info);
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox( width: 10),
            MyBackButton(),
          ],
        ),
        Row(
          children: <Widget>[
            MySaveButton( save),
            Container( width: 30 ),
            MyInfoButton( info),
            SizedBox( width: 10),
          ],
        ),
      ],
    );
  }
}


class MyBackButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'backButton',
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
          child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: LightColors.kDarkBlue,
          ),
        ),
      ),
    );
  }
}

class MySaveButton extends StatelessWidget {

  void Function() callback;

  MySaveButton(this.callback);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'saveButton',
      child: GestureDetector(
        onTap: callback,
          child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.save_outlined,
            size: 30,
            color: LightColors.kDarkBlue,
          ),
        ),
      ),
    );
  }
}

class MyInfoButton extends StatelessWidget {

  void Function() callback;

  MyInfoButton(this.callback);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'infoButton',
      child: GestureDetector(
        onTap: callback,
          child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.info_outlined,
            size: 30,
            color: LightColors.kDarkBlue,
          ),
        ),
      ),
    );
  }
}

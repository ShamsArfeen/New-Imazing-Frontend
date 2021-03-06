import 'package:flutter/material.dart';

class ActiveProjectsCard extends StatelessWidget {
  final Color cardColor;
  final double loadingPercent;
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function() callback;


  ActiveProjectsCard({
    this.cardColor,
    this.loadingPercent,
    this.title,
    this.subtitle,
    this.icon,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: callback,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(15.0),
          height: 200,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon,
                  color: Colors.white, size: 50.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), 
    );
  }
}

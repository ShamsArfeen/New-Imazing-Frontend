import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/header_strip.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:path/path.dart' as pathlib;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/colors/light_colors.dart';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

List<String> api = [
  'rightrotate',
  'leftrotate',
  'fliphorizontal',
  'flipvertical',
  'halfcompress',
];

final apif = [
  'sharpen',
  'blur',
  'brighten',
  'contrast',
];

final List<Image> imgList = [
  new Image.asset('assets/images/1.png', width: 1000.0),
  new Image.asset('assets/images/2.png', width: 1000.0),
  new Image.asset('assets/images/3.png', width: 1000.0),
  new Image.asset('assets/images/4.png', width: 1000.0),
];

class MyHomePage extends StatefulWidget {
  MyHomePage(this.filepath, {Key key})
      : super(key: key);

  final filepath;

  @override
  CalendarPage createState() => CalendarPage(filepath);
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(2.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    item,
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class CalendarPage extends State<MyHomePage> {

  File _image;
  String filepath;
  bool intensity = false;
  int currentFilter = 0;

  @override
  void initState() {
    super.initState();
    Timer.run(() => _alertDialog());
  }

  _alertDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Tour"),
              content: Container(
                  width: 300.0,
                  height: 500.0,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1.0,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      enableInfiniteScroll: false,
                      initialPage: 0,
                      autoPlay: true,
                    ),
                    items: imageSliders,
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text("Got it"),
                  onPressed: () {
                    Navigator.pop(context, 10);
                  },
                )
              ],
            ));
  }

  void infoBttn() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Help"),
            content: new Text(
                "Imazing is an image editing application. Upload an image from the gallery or camera and proceed to the edit screen"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void saveBttn() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    print(statuses[Permission.storage]);
    final result = await ImageGallerySaver.saveFile(_image.path);
    print(result);
    if (result['isSuccess'] == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            // title: new Text("Alert Dialog title"),
            content: new Text("Image saved successfully"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (result['isSuccess'] == false) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            // title: new Text("Alert Dialog title"),
            content: new Text("Image failed to save"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void filterSelect(int iFilter, {bool high = false}) {
    setState(() {
      currentFilter = iFilter;
      intensity = high;
    });
  }

  CalendarPage(this.filepath) {
    if (_image == null) {
      _image = File(filepath);
    }
  }

  static CircleAvatar circleIcon(IconData icon) {
    return CircleAvatar(
      radius: 22.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        icon,
        size: 22.0,
        color: Colors.white,
      ),
    );
  }

  Future<Null> transformMatrix(int operation) async {
    final directory = await getApplicationDocumentsDirectory();
    String appdir = directory.path;
    var postUri =
        Uri.parse("https://imazing-backend.herokuapp.com/" + api[operation]);
    var request = new http.MultipartRequest("POST", postUri);
    print(_image.path);
    request.fields['factor'] = api[operation];
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      _image.path,
    ));
    request.send().then((response) async {
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Uploaded!");
        print(response.headers);
        String basename = pathlib.basename(_image.path);
        _image.deleteSync();
        _image = File(appdir + '/A' + basename);
        IOSink sink = _image.openWrite();
        await sink.addStream(
            response.stream); // this requires await as addStream is async
        await sink.close(); // so does this
        setState(() {});
      }
    });
  }

  Future<Null> magicFilter() async {
    final directory = await getApplicationDocumentsDirectory();
    String appdir = directory.path;
    var postUri =
        Uri.parse("http://imazing-backend.herokuapp.com/" + apif[currentFilter]);
    var request = new http.MultipartRequest("POST", postUri);

    if (intensity)
      request.fields['factor'] = '100';
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      _image.path,
    ));
    request.send().then((response) async {
      int t = response.statusCode;
      if (response.statusCode == 200) {
        print("Uploaded!");
        print(response.headers);
        String basename = pathlib.basename(_image.path);
        _image.deleteSync();
        _image = File(appdir + '/A' + basename);
        IOSink sink = _image.openWrite();
        await sink.addStream(
            response.stream); // this requires await as addStream is async
        await sink.close(); // so does this
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            10,
            10,
            10,
            10,
          ),
          child: Column(
            children: <Widget>[
              HeaderMenu(saveBttn, infoBttn),
              Container(height: 7),
              Align(
                alignment: Alignment.topCenter,
                child: Divider(
                    color: Colors.black,
                    endIndent: MediaQuery.of(context).size.width * 0.1,
                    indent: MediaQuery.of(context).size.width * 0.1),
              ),
              Container(height: 7),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    10,
                                    10,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: PinchZoom(
                                      image: Image.file(_image),
                                      zoomedBackgroundColor: Colors.black87,
                                      resetDuration:
                                          const Duration(milliseconds: 100),
                                      maxScale: 3,
                                      onZoomStart: () {
                                        print('Start zooming');
                                      },
                                      onZoomEnd: () {
                                        print('Stop zooming');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    child: circleIcon(Icons.rotate_left),
                                    onTap: () async {
                                      await transformMatrix(0);
                                    },
                                  ),
                                  GestureDetector(
                                    child: circleIcon(Icons.rotate_right),
                                    onTap: () async {
                                      await transformMatrix(1);
                                    },
                                  ),
                                  GestureDetector(
                                    child: circleIcon(
                                        Icons.swap_horizontal_circle_outlined),
                                    onTap: () async {
                                      await transformMatrix(2);
                                    },
                                  ),
                                  GestureDetector(
                                    child: circleIcon(
                                        Icons.swap_vertical_circle_outlined),
                                    onTap: () async {
                                      await transformMatrix(3);
                                    },
                                  ),
                                  GestureDetector(
                                    child: circleIcon(Icons.compress),
                                    onTap: () async {
                                      await transformMatrix(4);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                filterSelect(0);
                              },
                              child: Chip(
                                label: Text("Sharp"),
                                backgroundColor: (currentFilter != 0 || intensity != false)
                                    ? Colors.indigo.shade200
                                    : LightColors.kRed,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox( 
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () {
                                filterSelect(1);
                              },
                              child: Chip(
                                label: Text("Blur"),
                                backgroundColor: (currentFilter != 1  || intensity != false)
                                    ? Colors.indigo.shade200
                                    : LightColors.kRed,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox( 
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () {
                                filterSelect(2);
                              },
                              child: Chip(
                                label: Text("Bright"),
                                backgroundColor: (currentFilter != 2  || intensity != false)
                                    ? Colors.indigo.shade200
                                    : LightColors.kRed,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox( 
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () {
                                filterSelect(3);
                              },
                              child: Chip(
                                label: Text("Contrast"),
                                backgroundColor: (currentFilter != 3  || intensity != false)
                                    ? Colors.indigo.shade200
                                    : LightColors.kRed,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox( 
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () {
                                filterSelect(0, high: true);
                              },
                              child: Chip(
                                label: Text("High Sharp"),
                                backgroundColor: (currentFilter != 0   || intensity != true)
                                    ? Colors.indigo.shade200
                                    : LightColors.kRed,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox( 
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () {
                                filterSelect(1, high: true);
                              },
                              child: Chip(
                                label: Text("High Blur"),
                                backgroundColor: (currentFilter != 1  || intensity != true)
                                    ? Colors.indigo.shade200
                                    : LightColors.kRed,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox( 
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () {
                                filterSelect(2, high: true);
                              },
                              child: Chip(
                                label: Text("High Bright"),
                                backgroundColor: (currentFilter != 2  || intensity != true)
                                    ? Colors.indigo.shade200
                                    : LightColors.kRed,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox( 
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () {
                                filterSelect(3, high: true);
                              },
                              child: Chip(
                                label: Text("High Contrast"),
                                backgroundColor: (currentFilter != 3  || intensity != true)
                                    ? Colors.indigo.shade200
                                    : LightColors.kRed,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                magicFilter();
                              },
                              child: Container(
                                child: Text(
                                  'Apply Filter',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: LightColors.kBlue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
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
      ),
    );
  }
}

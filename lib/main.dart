import 'package:flutter/material.dart';
import 'package:mob_monitoring/packages/extrainfo.dart';
import 'package:mob_monitoring/pages/capture_image.dart';
import 'package:mob_monitoring/pages/login.dart';
import 'package:mob_monitoring/pageviews/homeview.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        backgroundColor: Colors.white,
        image: Image.asset('asset/images/2.png'),
        loaderColor: Colors.blue,
        seconds: 5,
        navigateAfterSeconds:HomeView(),
        photoSize: 200,
      ),
      routes: {
        'home':(context)=>HomeView(),
        'capture':(context)=>CaptureImage(selectmob: ExtraInfo.selectedmob,),
      },
    );
  }
}


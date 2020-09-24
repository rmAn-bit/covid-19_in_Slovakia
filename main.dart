import 'package:flutter/material.dart';
import './home.dart';

void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
      routes: {
        '/loading': (context) => Loading(),
        '/home': (context) => HomePage(),
        '/regions': (context) => Regions(),
      }
    ));
}
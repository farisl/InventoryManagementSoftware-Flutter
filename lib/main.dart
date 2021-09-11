import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inventory_management_software/pages/Exports.dart';
import 'package:inventory_management_software/pages/Notifications.dart';
import 'package:inventory_management_software/pages/UserProfile.dart';
import 'package:inventory_management_software/services/APIService.dart';
import 'dart:convert';
import 'pages/Loading.dart';
import 'pages/Login.dart';
import 'pages/Home.dart';
import 'pages/Products.dart';
import 'pages/Imports.dart';
import 'pages/Exports.dart';
import 'pages/UserProfile.dart';

void main() {
  runApp(MyApp());
  HttpOverrides.global = new MyHttpOverrides();


}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: {
        '/loading':(context)=>Loading(),
        '/home':(context)=>Home(),
        '/products':(context)=>Products(),
        '/imports':(context)=>Imports(),
        '/exports':(context)=>Exports(),
        '/userProfile':(context)=>UserProfile(),
        '/notifications':(context)=>Notifications(),
        '/login':(context)=>Login(),
      },
    );
  }
}

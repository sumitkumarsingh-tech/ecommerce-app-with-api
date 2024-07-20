import 'package:ecommerce_app/screens/home.dart';
import 'package:flutter/material.dart';

import 'login_register/login.dart';

void main(){
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home:MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Login();
  }
}

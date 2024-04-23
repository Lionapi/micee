// ignore_for_file: file_names

import 'dart:async';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:micee/main.dart';
import 'package:micee/views/Login.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({super.key});

  @override
  State<SplashscreenPage> createState() => SplashscreenPageState();
}

class SplashscreenPageState extends State<SplashscreenPage> {
  //THIS IS SPLASH SCREEN
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ));
    });
  }

  // added test yourself
  // and made the text to align at center
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Center(child: Text('MiCee')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [MainApp.bg, MainApp.bg1, MainApp.bg2, MainApp.bg3],
              stops: [0.2, 0.5, 0.8, 0.7],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
      ),*/
      //resizeToAvoidBottomInset: false,
      //backgroundColor: const Color.fromARGB(255, 33, 116, 185),
      body: WindowBorder(
        color: Colors.white, width: 1.5,
        child: Column(
          children: [const CenterSide(), 
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight, end: Alignment.bottomLeft,
                    colors: [MainApp.navcolor2, MainApp.navcolor3],
                    stops: [0, 2], tileMode: TileMode.clamp,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView( 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/micee-high-resolution-logo-white-transparent.png", height: 250, width: 300, fit: BoxFit.contain),
                        //Image(image: AssetImage("assets/micee-high-resolution-logo-white-transparent.png"), height: 250, width: 300, fit: BoxFit.contain),
                        //SizedBox(height: 20,),
                        //Text("MiCee", style: MainApp.styleall.copyWith(fontSize: 18.0, color: MainApp.gray), textAlign: TextAlign.center,),
                        //Text("© NDAJ",style: MainApp.styleall.copyWith(fontSize: 14.0, color: MainApp.gray), textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
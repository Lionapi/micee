// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:micee/main.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  String profile = "man_1";

  @override
  void initState() {
    // implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Center(child: Text('Awesome AppBar')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [MyApp.bg, MyApp.bg1, MyApp.bg2, MyApp.bg3],
              stops: [0.2, 0.5, 0.8, 0.7],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
      ),*/
      //resizeToAvoidBottomInset: false,
      //backgroundColor: const Color.fromARGB(255, 33, 116, 185),
      body: WindowBorder(
        color: Colors.white,
        width: 1.5,
        child: Column(
          children: [
            const CenterSide(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [MainApp.navcolor2, MainApp.navcolor3],
                    stops: [0, 2],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: CircleAvatar(
                      backgroundColor: MainApp.textwr, radius: 50,
                      child: SizedBox(width: 100, height: 100,
                        child: CircleAvatar(
                          backgroundColor: MainApp.textwr, radius: 50,
                          child: CircleAvatar(backgroundColor: MainApp.gray, backgroundImage: AssetImage('assets/$profile.png',), radius: 48,
                            child: Align(alignment: Alignment.bottomRight,
                              child: CircleAvatar(backgroundColor: Colors.white, radius: 16,
                                child: FloatingActionButton(tooltip: 'Changer', foregroundColor: MainApp.dark, backgroundColor: MainApp.gray, hoverColor: Colors.black12, mini: true,
                                  shape: RoundedRectangleBorder(side: const BorderSide(width: 1.25, color: Colors.black12), borderRadius: BorderRadius.circular(100)),
                                  onPressed: () { setState(() { profile = "wman_1"; });},
                                  child: const Icon(Icons.edit,),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

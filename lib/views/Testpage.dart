// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:micee/main.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  //final AudioPlayer player = AudioPlayer(); 
  int selectedpage = 0;

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight, end: Alignment.bottomLeft,
            colors: [MainApp.bg, MainApp.bg2],
            stops: [0, 2],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: <Widget>[
              NavigationRail(
                selectedIndex: selectedpage, groupAlignment: 0, 
                backgroundColor: MainApp.navcolor3,
                onDestinationSelected: (int index) { setState(() { selectedpage = index ; }); },
                labelType: NavigationRailLabelType.all,
                /*
                leading: FloatingActionButton(
                  elevation: 0, child: const Icon(Icons.add),
                  onPressed: () { }, 
                ),
                */
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Dashboard'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.supervisor_account_outlined), selectedIcon: Icon(Icons.supervisor_account), label: Text('Users'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.file_copy_outlined), selectedIcon: Icon(Icons.file_copy_rounded), label: Text('Files'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.download_outlined), selectedIcon: Icon(Icons.download_rounded), label: Text('Download'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.exit_to_app_outlined), selectedIcon: Icon(Icons.exit_to_app_rounded), label: Text('Déconnexion'),
                  ),
                  NavigationRailDestination(
                    icon: Badge(child: Icon(Icons.bookmark_border)),
                    selectedIcon: Badge(child: Icon(Icons.book)),
                    label: Text('Second'),
                  ),
                  NavigationRailDestination(
                    icon: Badge(label: Text('4'), child: Icon(Icons.star_border),),
                    selectedIcon: Badge(label: Text('4'), child: Icon(Icons.star),),
                    label: Text('Third'),
                  ),
                ],
                /*
                trailing: IconButton( icon: const Icon(Icons.more_horiz_rounded),
                  onPressed: () { },
                ),
                */
              ),
              const VerticalDivider(thickness: 1.5, width: 1.5),
              const Expanded(
                child: Column(),
              ),
            ]
          ),
        ),
      ),
    );
  }
}

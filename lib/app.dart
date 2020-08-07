import 'package:flutter/material.dart';
import 'package:wasteagram/constants/constants.dart';
import 'package:wasteagram/views/waste_post_list.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //showSemanticsDebugger: true,
      title: Constants.appName,
      theme: ThemeData(
        brightness: Brightness.dark,
        
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WastePostList(),
    );
  }
}
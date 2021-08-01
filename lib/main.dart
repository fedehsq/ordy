import 'package:flutter/material.dart';
import 'package:ordy/TableMapScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.hasData) {
              return TableMapScreen(prefs: snapshot.data);
            } else {
              return CircularProgressIndicator();
            }
          }
      )
    );
  }
}
import 'package:flutter/material.dart';

import 'Welcomescreen.dart';

void main() => runApp(const EarthEye());

class EarthEye extends StatelessWidget {
  const EarthEye({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EarthEye',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PlayfairDisplay',
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: Welcomescreen(),
    );
  }
}

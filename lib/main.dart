import 'package:flutter/material.dart';
import 'package:ligretto_calculator/screens/player_screen/player_screen.dart';
import 'package:ligretto_calculator/res/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ligretto Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: darkBlue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(orange),
          ),
        ),
      ),
      home: PlayerScreen(),
    );
  }
}

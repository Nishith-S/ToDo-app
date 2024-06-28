import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/theme/theme_of%20this%20app.dart';
import 'package:todo/utils/splashscreen_page.dart';

void main() async{
  //First initialize Hive using initFlutter() for flutter
  await Hive.initFlutter();
  //Second need to open the box
  await Hive.openBox("todoStorage");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of the application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}

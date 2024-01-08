import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/screen/weather_app.dart';

 main() async {
  runApp(const MyApp());

   await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const WeatherApp(),
    );
  }
}
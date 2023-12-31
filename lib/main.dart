import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/logic/weather_changenotifier.dart';
import 'package:weather_app/screens/home_layoute.dart'; // import your WeatherProvider



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()), // Provide WeatherProvider
        // Add other providers if any
      ],
      child: MyApp(), // Your main widget
    ),
  );
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Your MaterialApp configuration
      home: HomeScreen(), // DetailPage should be able to access WeatherProvider
    );
  }
}

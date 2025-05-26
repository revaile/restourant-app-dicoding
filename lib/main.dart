import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restourantapp/api/api_service.dart';
import 'package:restourantapp/page/restaurant_list_page.dart';
import 'package:restourantapp/provider/restaurant_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(ApiService(http.Client())),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
        ),
        fontFamily: 'RobotoMono',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme:const ColorScheme.dark(
          primary: Colors.deepOrange,
          secondary: Colors.orangeAccent,
        ),
        fontFamily: 'RobotoMono',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const RestaurantListPage(),
    );
  }
}
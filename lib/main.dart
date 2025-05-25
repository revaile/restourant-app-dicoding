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
        primarySwatch: Colors.teal,
        fontFamily: 'RobotoMono',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        fontFamily: 'RobotoMono',
      ),
      themeMode: ThemeMode.system,
      home: const RestaurantListPage(),
    );
  }
}
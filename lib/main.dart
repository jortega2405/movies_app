import 'package:flutter/material.dart';
import 'package:movies_app/providers/providers.dart';
import 'package:movies_app/screens/screens.dart';
import 'package:provider/provider.dart';


void main() => runApp(const AppState());

class AppState  extends StatelessWidget {
  const AppState ({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MoviesProvider(),
          lazy: false,
        )
      ],
      child:const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      initialRoute: 'home',
      routes: {
        'home':(context) => HomeScreen(),
        'details':(context) => DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.pink[100]
        )
      ),
    );
  }
}
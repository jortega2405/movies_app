import 'package:flutter/material.dart';
import 'package:movies_app/providers/providers.dart';
import 'package:movies_app/screens/screens.dart';
import 'package:provider/provider.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inizalitation(null);
  runApp(const AppState());
}

Future inizalitation(BuildContext? context) async {
  await Future.delayed(const Duration(milliseconds: 1000));
}

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
        'home':(context) => const HomeScreen(),
        'details':(context) => DetailsScreen(),
      },
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.black.withOpacity(0.3)
        )
      ),
    );
  }
}
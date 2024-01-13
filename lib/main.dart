import 'package:event_flutter_application/pages/login_page.dart';
import 'package:event_flutter_application/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'data_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyAppData(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber.shade900, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/main': (context) => const MainPage()
        },
      ),
    );
  }
}

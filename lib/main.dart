import 'package:event_flutter_application/login_page.dart';
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
        title: 'Event Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(),
        home: const LoginPage(),
      ),
    );
  }
}

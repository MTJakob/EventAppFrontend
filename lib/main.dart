import 'package:event_flutter_application/pages/login_page.dart';
import 'package:event_flutter_application/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'components/http_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? userID;

  void setID(int? id) {
    setState(() {
      userID = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppHttpInterface(
        setID: setID,
        userID: userID,
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
          home: userID == null ? const LoginPage() : const MainPage(),
        ));
  }
}

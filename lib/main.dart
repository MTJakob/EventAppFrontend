import 'package:flutter/material.dart';
import 'main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyAppData(child: MainPage(),),
    );
  }
}


class MyAppData extends InheritedWidget {
  const MyAppData({super.key, required super.child});

  /* 
  this is the main container for future variables like session keys, cache managers...
  define a variable like:
  final double sampledata = 15;
  reference it in a child widget:
  MyAppData.of(context).sampledata
  */

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static MyAppData? maybeOf(BuildContext context) => 
    context.dependOnInheritedWidgetOfExactType<MyAppData>();

  static MyAppData of(BuildContext context) {
    final MyAppData? result = maybeOf(context);
    assert(result != null, 'No MyAppData found');
    return result!;
  }
}
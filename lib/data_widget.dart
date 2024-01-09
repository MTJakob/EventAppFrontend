import 'package:flutter/material.dart';

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

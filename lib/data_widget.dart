import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/file.dart';

class MyAppData extends InheritedWidget {
  MyAppData({super.key, required super.child});
  final cache = CacheManager(Config("cache",stalePeriod: const Duration(hours: 1)));

  final String host = "http://192.168.88.137:5000";

  Future<File> getFile() async {
    return await cache.getSingleFile(host);
  }

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

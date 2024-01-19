import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AppHttpInterface extends InheritedWidget {
  const AppHttpInterface({super.key, required super.child});

  static String host = "http://192.168.135.137:5000";

  Future<List<Map<String, dynamic>>> getEventList() async {
    final response = await get(Uri.parse(host));
    if (response.statusCode == 200) {
      return json.decode(response.body).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get Events');
    }
  }

  Future<Response> postEvent( Map<String, dynamic> event) async {
    return post(Uri.parse(host), body: event.toString());
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppHttpInterface? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppHttpInterface>();

  static AppHttpInterface of(BuildContext context) {
    final AppHttpInterface? result = maybeOf(context);
    assert(result != null, 'No MyAppData found');
    return result!;
  }
}

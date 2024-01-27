import 'package:event_flutter_application/components/events_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AppHttpInterface extends InheritedWidget {
  const AppHttpInterface(
      {super.key, required super.child, this.userID, required Function setID})
      : _setID = setID;

  final int? userID;

  final Function _setID;

  static String scheme = 'http';
  static String host = "192.168.221.137";
  static int port = 5000;

  Future<String?> login(String email, String password) async {
    Response response = await post(
        Uri(scheme: scheme, host: host, port: port, path: "login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"Email": email, "Password": password}));
    dynamic body = json.decode(response.body);
    switch (response.statusCode) {
      case 200:
        _setID(body["user_id"]);
        return null;
      case 404:
        return "Invalid email";
      default:
        return body["message"];
    }
  }

  void logOut() {
    _setID(null);
  }

  Future<String> register(
      {required String email,
      required String name,
      required String surname,
      required String dateOfBirth,
      required String password}) async {
    Response response = await post(
        Uri(scheme: scheme, host: host, port: port, path: "register"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "Email": email,
          "Name": name,
          "Surname": surname,
          "DateOfBirth": dateOfBirth,
          "Password": password
        }));
    return json.decode(response.body)["message"];
  }

  Future<Response> postEvent(Event event) async {
    Response response = await post(
        Uri(
            scheme: scheme,
            host: host,
            port: port,
            pathSegments: ["event", userID.toString()]),
        headers: {"Content-Type": "application/json"},
        body: event.toJson());
    return response;
  }

  Future<List<Event>> getEventList() async {
    final response = await get(Uri(
        scheme: scheme,
        host: host,
        port: port,
        pathSegments: ["event", userID.toString()]));
    if (response.statusCode == 200) {
      List list = json.decode(response.body);
      List<Event> events =
          list.map((element) => Event.fromJson(element)).toList();
      return events;
    } else {
      throw Exception('Failed to get Events');
    }
  }

  //wip
  Future<List<String>> searchEvents(String input) async {
    Uri url = Uri(
        scheme: scheme, host: host, port: port, path: "search", query: input);
    final response = await get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body).cast<String>();
    } else {
      throw Exception('Failed to get Events');
    }
  }
  //

  @override
  bool updateShouldNotify(AppHttpInterface oldWidget) =>
      userID != oldWidget.userID;

  static AppHttpInterface? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppHttpInterface>();

  static AppHttpInterface of(BuildContext context) {
    final AppHttpInterface? result = maybeOf(context);
    assert(result != null, 'No AppHttpInterface found');
    return result!;
  }
}

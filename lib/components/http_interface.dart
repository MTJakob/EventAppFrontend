import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:event_flutter_application/components/data_structures.dart';

class AppHttpInterface extends InheritedWidget {
  const AppHttpInterface(
      {super.key, required super.child, this.userID, required Function setID})
      : _setID = setID;

  final int? userID;

  final Function _setID;

  static String scheme = 'http';
  static String host = "192.168.110.137";
  static int port = 5000;
  static Uri uri = Uri(scheme: scheme, host: host, port: port);

  static Map<String, String> headers = {"Content-Type": "application/json"};

  Future<String?> login(String email, String password) async {
    Response response = await post(uri.replace(path: "login"),
        headers: headers,
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

  Future<Response> changePassword(String newPwd, String oldPwd) async {
    Response response = await put(uri.replace(path: "login"),
        headers: headers,
        body: json.encode(
            {"OldPassword": oldPwd, "NewPassword": newPwd, "IDUser": userID}));
    return response;
  }

  void logOut() {
    _setID(null);
  }

  Future<Response> register(User user) async {
    Response response = await post(uri.replace(path: "register"),
        headers: headers, body: user.toJson());
    return response;
  }

  Future<Response> updateUser(User user) async {
    Response response = await put(
        uri.replace(pathSegments: ["user", userID.toString()]),
        headers: headers,
        body: user.toJson());
    return response;
  }

  Future<User> getUser() async {
    Response response =
        await get(uri.replace(pathSegments: ["user", userID.toString()]));
    if (response.statusCode == 200) {
      User user = User.fromJson(json.decode(response.body));
      return user;
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  Future<Response> toggleAttending(Event event, bool isAttending) async {
    Response response = await (isAttending ? delete : post)(
        uri.replace(pathSegments: ["event participant", userID.toString()]),
        headers: headers,
        body: json.encode({"IDEvent": event.id}));
    return response;
  }

  Future<Response> placeEvent(Event event) async {
    Response response = await (event.id == null ? post : put)(
        uri.replace(pathSegments: ["event", userID.toString()]),
        headers: headers,
        body: event.toJson());
    return response;
  }

  Future<Response> deleteEvent(Event event) async {
    Response response = await delete(
        uri.replace(pathSegments: ["event", userID.toString()]),
        headers: headers,
        body: json.encode({"IDEvent": event.id}));
    return response;
  }

  Future<List<Event>> getEventList({bool isParticipant = true}) async {
    Response response = await get(uri.replace(pathSegments: [
      isParticipant ? "event participant" : "event",
      userID.toString()
    ]));
    if (response.statusCode == 200) {
      List list = json.decode(response.body);
      List<Event> events =
          list.map((element) => Event.fromJson(element)).toList();
      return events;
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  //wip
  Future<List<String>> searchEvents(String input) async {
    Response response = await get(uri.replace(path: "search", query: input));
    if (response.statusCode == 200) {
      return json.decode(response.body).cast<String>();
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
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

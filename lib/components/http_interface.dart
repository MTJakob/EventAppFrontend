import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:event_flutter_application/components/data_structures.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppHttpInterface extends InheritedWidget {
  const AppHttpInterface(
      {super.key,
      this.userID,
      required this.refreshUser,
      required this.storage,
      required super.child});
  final int? userID;

  final Function refreshUser;

  final FlutterSecureStorage storage;

  static const String _scheme = 'http';
  static const String _host = "192.168.115.137";
  static const int _port = 5000;
  static Uri uri = Uri(scheme: _scheme, host: _host, port: _port);

  static const String jwtKey = 'jwt';

  static Map<String, String> headers = {"Content-Type": "application/json"};

  Future<String?> getJWT() async {
    return storage.read(key: jwtKey);
  }

  Future<String?> logIn(String email, String password) async {
    Response response = await post(uri.replace(path: "login"),
        headers: headers,
        body: json.encode({"Email": email, "Password": password}));
    dynamic body = json.decode(response.body);
    switch (response.statusCode) {
      case 200:
        if (JwtDecoder.tryDecode(body['access_token']) != null) {
          storage
              .write(key: jwtKey, value: body['access_token'])
              .then((value) => refreshUser());
          return null;
        } else {
          throw FormatException('Invalid jwt: ${body["access_token"]}');
        }
      case 404:
        return "Invalid email";
      default:
        return body["message"];
    }
  }

  Future<String?> logOut() async {
    String? jwt = await getJWT();
    Response response = await post(uri.replace(path: 'logout'),
        headers: {"Authorization": "Bearer $jwt"});
    if (response.statusCode == 200) {
      storage.delete(key: jwtKey).then((value) => refreshUser());
      return null;
    } else {
      return json.decode(response.body)['message'];
    }
  }

  Future<Response> changePassword(String newPwd, String oldPwd) async {
    Response response = await put(uri.replace(path: "login"),
        headers: headers,
        body: json.encode(
            {"OldPassword": oldPwd, "NewPassword": newPwd, "IDUser": userID}));
    return response;
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
  Future<List<Event>> searchEvents(String input) async {
    Response response = await post(uri.replace(path: "search"),
        headers: headers, body: json.encode({"SearchWord": input}));
    if (response.statusCode == 200) {
      List list = json.decode(response.body);
      List<Event> events = list.map((e) => Event.fromJson(e)).toList();
      return events;
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

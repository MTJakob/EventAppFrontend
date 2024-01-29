import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class Event {
  const Event(
      {required this.name,
      required this.price,
      required this.capacity,
      required this.category,
      required this.timeRange,
      required this.location,
      this.organiser,
      this.id});
  final int? id;
  final String name;
  final double price;
  final int capacity;
  final String category;
  final DateTimeRange timeRange;
  final LatLng location;
  final User? organiser;

  factory Event.fromJson(Map<String, dynamic> data) {
    User? organiser;
    if (data
        case {
          'Name': String name,
          'Capacity': int capacity,
          'Price': double price,
          //'eventCategory': Map<String, dynamic> eventCategory,
          'eventAddress': Map<String, dynamic> eventAddress,
        }) {
      final DateTimeRange range = DateTimeRange(
          start: DateTime.parse(data["StartDateTime"]),
          end: DateTime.parse(data["EndDateTime"]));
      final int? id = data["IDEvent"];
      if (data["eventUser"] != null) {
        organiser = User.fromJson(data["eventUser"]);
      }
      return Event(
          id: id,
          name: name,
          price: price,
          capacity: capacity,
          timeRange: range,
          category: "Outdoor", //eventCategory["Name"],
          location: LatLng(eventAddress["Latitude"], eventAddress["Longitude"]),
          organiser: organiser);
    } else {
      throw FormatException('Invalid Event JSON: $data');
    }
  }

  String toJson() {
    Map<String, dynamic> data = {
      'Name': name,
      'Capacity': capacity,
      'Price': price,
      'StartDateTime': timeRange.start.toIso8601String().split('.')[0],
      'EndDateTime': timeRange.end.toIso8601String().split('.')[0],
      'eventCategory': {"Name": category},
      'eventAddress': {
        "Longitude": location.longitude,
        "Latitude": location.latitude
      },
      if (id != null) "IDEvent": id,
      if (organiser != null) "eventUser": organiser!.toJson()
    };
    return json.encode(data);
  }
}

class User {
  const User(
      {this.id,
      required this.name,
      required this.surname,
      this.email,
      this.birthday,
      this.password});
  final int? id;
  final String name;
  final String surname;
  final String? email;
  final DateTime? birthday;
  final String? password;

  factory User.fromJson(Map<String, dynamic> data) {
    if (data
        case {
          'Name': String name,
          'Surname': String surname,
        }) {
      final String? password = data["Password"];
      final int? id = data["IDUser"];
      final String? email = data["Email"];
      final DateTime? birthday = DateTime.tryParse(data["DateOfBirth"] ?? "");
      return User(
          id: id,
          name: name,
          surname: surname,
          email: email,
          birthday: birthday,
          password: password);
    } else {
      throw FormatException('Invalid User JSON: $data');
    }
  }

  String toJson() {
    Map<String, dynamic> data = {
      'Name': name,
      'Surname': surname,
      if (id != null) 'IDUser': id,
      if (email != null) 'Email': email,
      if (birthday != null)
        'DateOfBirth': birthday!.toIso8601String().split('T')[0],
      if (password != null) 'Password': password
    };
    return json.encode(data);
  }
}

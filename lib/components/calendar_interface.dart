import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:event_flutter_application/components/data_structures.dart'
    as data_structures;
import 'package:timezone/data/latest.dart';
import 'package:http/http.dart';
import 'dart:convert';

class CalendarInterface extends InheritedWidget {
  const CalendarInterface(
      {super.key, required this.plugin, this.calendar, required super.child});

  final DeviceCalendarPlugin plugin;
  final Calendar? calendar;

  Future<String?> addEvent(data_structures.Event event) async {
    initializeTimeZones();
    Response response =
        await get(Uri(scheme: 'https', host: "www.timeapi.io", pathSegments: [
      "api",
      "TimeZone",
      "coordinate"
    ], queryParameters: {
      "latitude": event.location.latitude.toString(),
      "longitude": event.location.longitude.toString()
    }));
    Location location = getLocation(json.decode(response.body)["timeZone"]);
    Result<String>? result = await plugin.createOrUpdateEvent(Event(
        calendar!.id,
        title: event.name,
        start: TZDateTime.from(event.timeRange.start, location),
        end: TZDateTime.from(event.timeRange.end, location),
        location:
            "${event.location.latitude.toStringAsPrecision(7)}, ${event.location.longitude.toStringAsPrecision(7)}"));
    if (result!.isSuccess) {
      return "Event saved successfuly";
    } else {
      return result.errors.first.errorMessage;
    }
  }

  @override
  bool updateShouldNotify(CalendarInterface oldWidget) =>
      calendar != oldWidget.calendar;

  static CalendarInterface? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CalendarInterface>();

  static CalendarInterface of(BuildContext context) {
    final CalendarInterface? result = maybeOf(context);
    assert(result != null, 'No Data found');
    return result!;
  }
}

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:event_flutter_application/components/data_structures.dart';

class EventsData extends InheritedWidget {
  const EventsData(
      {required super.child,
      required this.eventData,
      super.key,
      this.selected,
      this.selector});

  final List<Event> eventData;

  final int? selected;
  final Function? selector;

  static Map<String, IconData> eventIcons = {
    //general sports
    "Sport": Icons.sports,
    "Match": Icons.stadium,
    "Motorsports": Icons.sports_motorsports,
    //team sports
    "Soccer": Icons.sports_soccer,
    "Tennis": Icons.sports_tennis,
    "Baseball": Icons.sports_baseball,
    "Volleyball": Icons.sports_volleyball,
    "Football": Icons.sports_football,
    "Handball": Icons.sports_handball,
    //casual sports
    "Cycling": Icons.pedal_bike,
    "Running": Icons.directions_run,
    "Golf": Icons.golf_course,
    "Fishing": Icons.phishing,
    "IceSkating": Icons.ice_skating,
    //water sports
    "Diving": Icons.scuba_diving,
    "Sailing": Icons.sailing,
    "Kayaking": Icons.kayaking,
    "Swimming": Icons.pool,
    "Surfing": Icons.surfing,
    //outdoor
    "Outdoor": Icons.forest,
    "Campfire": Icons.local_fire_department,
    "Camping": Icons.details,
    "Hiking": Icons.terrain,
    //art
    "Art": Icons.palette,
    "Photography": Icons.camera,
    "Movie": Icons.local_movies,
    "Theatre": Icons.theater_comedy,
    //music
    "Music": Icons.music_note,
    "Party": Icons.nightlife,
    //food
    "Food": Icons.fastfood,
    "Baking": Icons.cookie,
    //self improvement
    "Networking": Icons.groups,
    "Workshop": Icons.construction,
    "Psychology": Icons.psychology,
    "Seminary": Icons.psychology_alt,
    "Lecture": Icons.school,
    //gathering
    "Birthday": Icons.cake,
    "Grill": Icons.outdoor_grill,
    "Event": Icons.celebration,
    "Meetup": Icons.handshake,
    //fair
    "Fair": Icons.attractions,
    "Science": Icons.science,
    "Market": Icons.storefront,
    "Circus": Icons.festival_outlined,
    //hobbies
    "Books": Icons.auto_stories,
    //computers
    "Computers": Icons.computer,
    "Esport": Icons.sports_esports,
    //leisure
    "Beach": Icons.beach_access,
    "Cruise": Icons.anchor,
    "Standup": Icons.mic,
    //general
    "Tournament": Icons.emoji_events,
    "Premium": Icons.diamond,
    "Protest": Icons.priority_high,
    //misc
    "Robots": Icons.precision_manufacturing,
    "Gambling": Icons.casino,
    "Animals": Icons.pets,
  };

  @override
  bool updateShouldNotify(EventsData oldWidget) =>
      !const ListEquality().equals(eventData, oldWidget.eventData) ||selected != oldWidget.selected;

  static EventsData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EventsData>();

  static EventsData of(BuildContext context) {
    final EventsData? result = maybeOf(context);
    assert(result != null, 'No Data found');
    return result!;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_map/flutter_map.dart';

class EventsData extends InheritedWidget {
  const EventsData(
      {required super.child,
      required this.eventData,
      super.key,
      this.mapControl,
      this.snapshotData,
      this.selected,
      this.selector});

  final MapController? mapControl;

  final File? snapshotData;

  final Map<String, dynamic> eventData;

  final Function? selected;
  final Function? selector;

  static Map<String, IconData> eventIcons = {
    "Music": Icons.music_note,
    "Food": Icons.fastfood,
    "Outdoor": Icons.forest,
    "Sailing": Icons.sailing,
    "Match": Icons.stadium,
    "Party": Icons.nightlife,
    "Fair": Icons.attractions,
    "Movie": Icons.local_movies,
    "Theatre": Icons.theater_comedy,
    "Esport": Icons.sports_esports,
    "Soccer":Icons.sports_soccer,
    "Science": Icons.science,
    "Birthday": Icons.cake,
    "Tennis": Icons.sports_tennis,
    "Grill": Icons.outdoor_grill,
    "Baseball": Icons.sports_baseball,
    "Volleyball":Icons.sports_volleyball,
    "Football": Icons.sports_football,
    "Handball": Icons.sports_handball,
    "Sport": Icons.sports,
    "Kayaking": Icons.kayaking,
    "Motorsports": Icons.sports_motorsports,
    "IceSkating": Icons.ice_skating,
    "Diving": Icons.scuba_diving,
    "Networking": Icons.groups,
    "Tournament": Icons.emoji_events,
    "Workshop": Icons.construction,
    "Psychology": Icons.psychology,
    "Robots": Icons.precision_manufacturing,
    "Campfire": Icons.local_fire_department,
    "Camping": Icons.details,
    "Market": Icons.storefront,
    "Swimming": Icons.pool,
    "Beach": Icons.beach_access,
    "Gambling": Icons.casino,
    "Golf": Icons.golf_course,
    "Event": Icons.celebration,
    "Cycling": Icons.pedal_bike,
    "Hiking": Icons.terrain,
    "Premium": Icons.diamond,
    "Art": Icons.palette,
    "Photography": Icons.camera,
    "Standup": Icons.mic,
    "Meetup": Icons.handshake,
    "Baking": Icons.cookie,
    "Seminary" :Icons.psychology_alt,
    "Lecture": Icons.school,
    "Animals": Icons.pets,
    "Computers": Icons.computer,
    "Fishing": Icons.phishing,
    "Books": Icons.auto_stories,
    "Cruise": Icons.directions_boat,
    "Protest": Icons.priority_high,
  };

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static EventsData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EventsData>();

  static EventsData of(BuildContext context) {
    final EventsData? result = maybeOf(context);
    assert(result != null, 'No HomeTabData found');
    return result!;
  }
}

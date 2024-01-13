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

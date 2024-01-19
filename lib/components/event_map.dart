import 'package:event_flutter_application/components/events_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class EventMap extends StatefulWidget {
  const EventMap({super.key, this.controller});

  static LatLng centralPoint = const LatLng(38.1858, 15.5561);

  final AnimatedMapController? controller;

  @override
  State<EventMap> createState() => _EventMapState();
}

class _EventMapState extends State<EventMap>
    with SingleTickerProviderStateMixin {
  late AnimatedMapController animatedController =
      widget.controller ?? AnimatedMapController(vsync: this);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        clipBehavior: Clip.hardEdge,
        elevation: 10,
        child: FlutterMap(
            mapController: animatedController.mapController,
            options: MapOptions(
                keepAlive: true,
                initialCenter: EventMap.centralPoint,
                initialZoom: 16),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'eventManager.app',
              ),
              const MapMarkers(),
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => animatedController.animatedRotateReset(),
                    icon: const Icon(Icons.navigation_rounded),
                    color: Theme.of(context).primaryColor,
                  ))
            ]));
  }
}

class MapMarkers extends StatefulWidget {
  const MapMarkers({super.key});

  @override
  State<MapMarkers> createState() => _MapMarkersState();
}

class _MapMarkersState extends State<MapMarkers> {
  int? selectedIndex;
  late List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    data = EventsData.of(context).eventData;
    selectedIndex = EventsData.of(context).selected;
    return MarkerLayer(
        rotate: true,
        markers: data.map((e) {
          int index = data.indexOf(e);
          return Marker(
              alignment: const Alignment(0, -0.7),
              point: LatLng(e["Address"]["X"], e["Address"]["Y"]),
              child: IconButton(
                  iconSize: 30,
                  padding: const EdgeInsetsDirectional.all(0),
                  icon: Icon(
                    Icons.place,
                    color: selectedIndex == index
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                  ),
                  onPressed: () => EventsData.of(context).selector!(
                      index, LatLng(e["Address"]["X"], e["Address"]["Y"]))));
        }).toList());
  }
}

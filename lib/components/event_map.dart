import 'package:event_flutter_application/components/events_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class EventMap extends StatefulWidget {
  const EventMap({super.key});

  static LatLng centralPoint = const LatLng(38.1858, 15.5561);

  @override
  State<EventMap> createState() => _EventMapState();
}

class _EventMapState extends State<EventMap>  with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = EventsData.of(context).eventData;

    String? selectedId;

    AnimatedMapController animatedController =
        EventsData.of(context).mapControl ?? AnimatedMapController(vsync: this);

    if (EventsData.of(context).selected != null) {
      selectedId = EventsData.of(context).selected!();
    }

    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        clipBehavior: Clip.hardEdge,
        elevation: 10,
        child: FlutterMap(
            mapController: animatedController.mapController,
            options: MapOptions(
                keepAlive: true, initialCenter: EventMap.centralPoint, initialZoom: 16),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                  rotate: true,
                  markers: data
                      .map((String eventId, value) => MapEntry(
                          eventId,
                          Marker(
                              alignment: const Alignment(0, -0.7),
                              point: LatLng(
                                  value["Address"]["X"], value["Address"]["Y"]),
                              child: IconButton(
                                  iconSize: 30,
                                  padding: const EdgeInsetsDirectional.all(0),
                                  icon: Icon(
                                    Icons.place,
                                    color: 
                                    selectedId == eventId
                                        ? Colors.red
                                        : Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => EventsData.of(context)
                                          .selector!(
                                      eventId,
                                      LatLng(data[eventId]["Address"]["X"],
                                          data[eventId]["Address"]["Y"]))))))
                      .values
                      .toList()),
              Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => animatedController.animatedRotateReset(),
                    icon: const Icon(Icons.navigation_rounded),
                    color: Theme.of(context).primaryColor,
                  ))
            ]));
  }
}

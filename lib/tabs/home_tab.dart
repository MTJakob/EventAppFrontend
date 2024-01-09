import 'package:event_flutter_application/event_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  LatLng centralPoint = const LatLng(38.1858, 15.5561);

  @override
  Widget build(BuildContext context) {
    final controller = MapController();

    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 2, child: EventList(mapController: controller)),
          Expanded(
            flex: 1,
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              clipBehavior: Clip.hardEdge,
              elevation: 10,
              child: FlutterMap(
                  mapController: controller,
                  options: const MapOptions(
                    keepAlive: true,
                      initialCenter: LatLng(38.1858, 15.5561), initialZoom: 16),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

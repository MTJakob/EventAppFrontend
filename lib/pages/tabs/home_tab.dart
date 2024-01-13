import 'package:event_flutter_application/data_widget.dart';
import 'package:event_flutter_application/events/event_map.dart';
import 'package:event_flutter_application/events/event_view.dart';
import 'package:event_flutter_application/events/events_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:convert';
import 'package:flutter_cache_manager/file.dart';
import 'package:latlong2/latlong.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? selectedId;
  MapController controller = MapController();

  void selector(String id, LatLng coordinates) {
    controller.move(coordinates, controller.camera.zoom);
    if (selectedId == id) {
      setState(() {
        selectedId = null;
      });
    } else {
      setState(() {
        selectedId = id;
      });
    }
  }

  String? selected() {
    return selectedId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MyAppData.of(context).getFile(),
        builder: (context, AsyncSnapshot<File> snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return EventsData(
              mapControl: controller,
              snapshotData: snapshot.data,
              eventData: json.decode(snapshot.data!.readAsStringSync()),
              selected: selected,
              selector: selector,
              child: const Column(
                children: [
                  Expanded(flex: 2, child: EventView()),
                  Expanded(flex: 1, child: EventMap())
                ],
              ),
            );
          } else {
            return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator());
          }
        });
  }
}

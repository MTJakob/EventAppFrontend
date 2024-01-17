import 'package:event_flutter_application/components/data_widget.dart';
import 'package:event_flutter_application/components/event_map.dart';
import 'package:event_flutter_application/components/event_view.dart';
import 'package:event_flutter_application/components/events_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:convert';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  String? selectedId;
  MapController controller = MapController();
  late final AnimatedMapController animatedController =
      AnimatedMapController(vsync: this, mapController: controller);

  void selector(String id, LatLng coordinates) {
    animatedController.animateTo(
        dest: coordinates, zoom: controller.camera.zoom);
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
    bool isHorizontal = MediaQuery.of(context).size.aspectRatio > 1;

    List<Widget> content = [
      Expanded(flex: 2, child: EventView(clip: isHorizontal ? Clip.antiAlias : Clip.none,)),
      Expanded(flex: isHorizontal ? 3 : 1, child: const EventMap())
    ];

    return FutureBuilder(
        future: MyAppData.of(context).getFile(),
        builder: (context, AsyncSnapshot<File> snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return EventsData(
                mapControl: animatedController,
                snapshotData: snapshot.data,
                eventData: json.decode(snapshot.data!.readAsStringSync()),
                selected: selected,
                selector: selector,
                child: isHorizontal
                    ? Row(
                        textDirection: TextDirection.rtl,
                        children: content,
                      )
                    : Column(
                        children: content,
                      ));
          } else {
            return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator());
          }
        });
  }
}

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
  int? selectedIndex;
  MapController controller = MapController();
  late final AnimatedMapController animatedController =
      AnimatedMapController(vsync: this, mapController: controller);

  void selector(int index, LatLng coordinates) {
    animatedController.animateTo(
        dest: coordinates, zoom: controller.camera.zoom);
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  int? selected() {
    return selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MyAppData.of(context).getFile(),
        builder: (context, AsyncSnapshot<File> snapshot) {
          bool isHorizontal = MediaQuery.of(context).size.aspectRatio > 1;

          if (snapshot.hasData && !snapshot.hasError) {
            return EventsData(
                mapControl: animatedController,
                snapshotData: snapshot.data,
                eventData: json
                    .decode(snapshot.data!.readAsStringSync())
                    .cast<Map<String, dynamic>>(),
                selected: selected,
                selector: selector,
                child: Flex(
                    direction: isHorizontal ? Axis.horizontal : Axis.vertical,
                    textDirection:
                        isHorizontal ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Expanded(
                          flex: 2,
                          child: EventView(
                            clip: isHorizontal ? Clip.antiAlias : Clip.none,
                          )),
                      Expanded(
                          flex: isHorizontal ? 3 : 1, child: const EventMap())
                    ]));
          } else {
            return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator());
          }
        });
  }
}

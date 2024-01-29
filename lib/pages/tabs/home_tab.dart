import 'package:event_flutter_application/components/http_interface.dart';
import 'package:event_flutter_application/components/event_map.dart';
import 'package:event_flutter_application/components/event_view.dart';
import 'package:event_flutter_application/components/events_data.dart';
import 'package:event_flutter_application/components/data_structures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

  @override
  Widget build(BuildContext context) {
    bool isHorizontal = MediaQuery.sizeOf(context).aspectRatio > 1;
    return FutureBuilder<List<Event>>(
        future: AppHttpInterface.of(context).getEventList(isParticipant: true),
        builder: (context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.hasData) {
            return EventsData(
                eventData: snapshot.data!,
                selected: selectedIndex,
                selector: selector,
                isAttending: true,
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
                          flex: isHorizontal ? 3 : 1,
                          child: EventMap(
                            controller: animatedController,
                          ))
                    ]));
          } else {
            return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator());
          }
        });
  }
}

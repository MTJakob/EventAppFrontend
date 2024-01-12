import 'package:event_flutter_application/data_widget.dart';
import 'package:event_flutter_application/event_card_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:flutter_cache_manager/file.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  LatLng centralPoint = const LatLng(38.1858, 15.5561);

  int? selectedId;

  Map<int, Map<String, dynamic>> data = {};

  @override
  Widget build(BuildContext context) {
    final controller = MapController();

    void onTap(int currentId) {
      setState(() {
        if (selectedId != currentId) {
          selectedId = currentId;
          controller.move(
              LatLng(data[currentId]!["Adress"]["x"],
                  data[currentId]!["Adress"]["y"]),
              controller.camera.zoom);
        } else {
          selectedId = null;
        }
      });
    }

    return Scaffold(
      body: FutureBuilder(
          future: MyAppData.of(context).getFile(),
          builder: (context, AsyncSnapshot<File> snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              data = json
                  .decode(snapshot.data!.readAsStringSync())
                  .map<int, Map<String, dynamic>>((key, value) =>
                      MapEntry<int, Map<String, dynamic>>(
                          int.parse(key), value));
            }
            return Column(
              children: [
                Expanded(
                    flex: 2,
                    child: ListView.builder(
                        clipBehavior: Clip.none,
                        itemCount: data.length,
                        itemBuilder: (_, index) {
                          int dataId = data.keys.elementAt(index);
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.abc),
                              title: Text(data[dataId]!["Name"]),
                              subtitle: EventCardBody(data[dataId],
                                  isSelected: selectedId == dataId),
                              onTap: () => onTap(dataId),
                            ),
                          );
                        })),
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
                            initialCenter: LatLng(38.1858, 15.5561),
                            initialZoom: 16),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(
                              rotate: true,
                              markers: data
                                  .map((int key, value) => MapEntry(
                                      key,
                                      Marker(
                                          alignment: const Alignment(0, -0.7),
                                          point: LatLng(value["Adress"]["x"],
                                              value["Adress"]["y"]),
                                          child: IconButton(
                                            iconSize: 30,
                                            padding:
                                                const EdgeInsetsDirectional.all(
                                                    0),
                                            icon: Icon(
                                              Icons.place,
                                              color: key == selectedId
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .primaryColor,
                                            ),
                                            onPressed: () => onTap(key),
                                          ))))
                                  .values
                                  .toList()),
                          Container(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  controller.rotate(0);
                                },
                                icon: const Icon(Icons.navigation_rounded),
                                color: Theme.of(context).primaryColor,
                              ))
                        ]),
                  ),
                )
              ],
            );
          }),
    );
  }
}

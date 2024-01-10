import 'package:event_flutter_application/event_card_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  LatLng centralPoint = const LatLng(38.1858, 15.5561);

  int? selectedId;

  @override
  Widget build(BuildContext context) {
    final controller = MapController();

    //this string is just for testing purposes
    //(easier to manage than adding an asset)
    const String aaaaaaa = '''{
    "12": {
        "Name": "Rave",
        "Date": "21/02/2024",
        "Adress": {
            "x": 38.1858,
            "y": 15.5571
        },
        "Organiser": "Mark",
        "Price": 5
    },
    "122": {
        "Name": "Concert",
        "Date": "25/02/2024",
        "Adress": {
            "x": 38.1850,
            "y": 15.5560
        },
        "Organiser": "Don",
        "Price": 50
    },
    "34": {
        "Name": "Fishing together",
        "Date": "21/02/2024",
        "Adress": {
            "x": 38.1859,
            "y": 15.5569
        },
        "Organiser": "Anastasia",
        "Price": 0
    },
    "43": {
        "Name": "Bowling",
        "Date": "10/02/2024",
        "Adress": {
            "x": 38.1847,
            "y": 15.5563
        },
        "Organiser": "Anna",
        "Price": 10
    },
    "9": {
        "Name": "Bake-off",
        "Date": "09/02/2024",
        "Adress": {
            "x": 38.1878,
            "y": 15.5562
        },
        "Organiser": "Carol",
        "Price": 10
    },
    "145":{
        "Name": "DnD",
        "Date": "11/03/2024",
        "Adress": {
            "x": 38.1857,
            "y": 15.5560
        },
        "Organiser": "Ezekiel",
        "Price": 0
    }
  }
  ''';

    Map<int, Map<String, dynamic>> data = json
        .decode(aaaaaaa)
        .map<int, Map<String, dynamic>>((key, value) =>
            MapEntry<int, Map<String, dynamic>>(int.parse(key), value));

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
      body: Column(
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
                                          const EdgeInsetsDirectional.all(0),
                                      icon: Icon(
                                        Icons.place,
                                        color: key == selectedId
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
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
      ),
    );
  }
}

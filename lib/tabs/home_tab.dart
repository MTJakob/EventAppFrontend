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

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final controller = MapController();

    //this string is just for testing purposes
    //(easier to manage than adding an asset)
    const String aaaaaaa = '''[
    {
        "Name": "Rave",
        "Date": "21/02/2024",
        "Adress": {
            "x": 38.1858,
            "y": 15.5571
        },
        "Organiser": "Mark",
        "Price": 5
    },
    {
        "Name": "Concert",
        "Date": "25/02/2024",
        "Adress": {
            "x": 38.1850,
            "y": 15.5560
        },
        "Organiser": "Don",
        "Price": 50
    },
    {
        "Name": "Fishing together",
        "Date": "21/02/2024",
        "Adress": {
            "x": 38.1859,
            "y": 15.5569
        },
        "Organiser": "Anastasia",
        "Price": 0
    },
    {
        "Name": "Bowling",
        "Date": "10/02/2024",
        "Adress": {
            "x": 38.1847,
            "y": 15.5563
        },
        "Organiser": "Anna",
        "Price": 10
    },
    {
        "Name": "Bake-off",
        "Date": "09/02/2024",
        "Adress": {
            "x": 38.1878,
            "y": 15.5562
        },
        "Organiser": "Carol",
        "Price": 10
    },
    {
        "Name": "DnD",
        "Date": "11/03/2024",
        "Adress": {
            "x": 38.1857,
            "y": 15.5560
        },
        "Organiser": "Ezekiel",
        "Price": 0
    }
]
  ''';

    var data = json.decode(aaaaaaa);

    List<LatLng> locations = [];

    for (var i in data) {
      locations.add(LatLng(i["Adress"]["x"], i["Adress"]["y"]));
    }

    void onTap(int current) {
      setState(() {
        selectedIndex = current;
        controller.move(locations[current], 16);
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
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.abc),
                        title: Text(data[index]["Name"]),
                        subtitle: EventCardBody(data[index],
                            isSelected: selectedIndex == index),
                        onTap: () => onTap(index),
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
                        markers: locations
                            .map((e) => Marker(
                                alignment: const Alignment(0, -0.7),
                                  point: e,
                                  child: Icon(Icons.place, color: e == locations[selectedIndex!] ? Colors.red : Colors.yellow,)
                                ))
                            .toList())
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

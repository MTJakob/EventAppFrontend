import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(itemBuilder: (_, index){return const Placeholder();})),
        Expanded(
          flex: 1,
          child: Card(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
            clipBehavior: Clip.hardEdge,
            elevation: 10,
            child: FlutterMap(options: const MapOptions(
              initialCenter: LatLng(38.1858, 15.5561),
              initialZoom: 16
              ), 
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
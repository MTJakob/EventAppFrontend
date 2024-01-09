import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, this.mapController});
  final MapController? mapController;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  //List events <= request
  int? selectedIndex;

  void onTap(int current) {
    setState(() {
      if (widget.mapController != null){
      widget.mapController!.move(const LatLng(38.1858, 15.5561), 16);
      }
      selectedIndex = current;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        clipBehavior: Clip.none,
        //itemCount: events.length,
        itemBuilder: (_, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.abc),
              title: const Text('Event name here'),
              subtitle: selectedIndex != index
                  ? const Text('Date here')
                  : const Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date here"),
                            Text("Adress here"),
                            Text("Organiser name here")
                            ],
                        ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Price here", style: TextStyle(fontWeight: FontWeight.bold),),
                          IconButton(icon: Icon(Icons.favorite), onPressed: null,),
                      ],)
                    ],
                  ),
              onTap: () => onTap(index),
            ),
          );
        });
  }
}

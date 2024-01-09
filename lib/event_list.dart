import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  //List events <= request
  int? selectedIndex;

  void onTap(int current) {
    setState(() {
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
                          Icon(Icons.favorite),
                      ],)
                    ],
                  ),
              onTap: () => onTap(index),
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  //List events = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
              clipBehavior: Clip.none,
              //itemCount: events.length,
              itemBuilder: (_, index){
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.abc),
                  title: const Text('Placeholder'),
                  subtitle: Text('$index'),
                  onTap: (){},
                  ),
              );
              });
  }
}
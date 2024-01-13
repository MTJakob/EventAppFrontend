import 'package:event_flutter_application/events_data.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  String? selectedId;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> eventsData = EventsData.of(context).eventData;

    if (EventsData.of(context).selected != null) {
      selectedId = EventsData.of(context).selected!();
    }

    return ListView.builder(
        clipBehavior: Clip.none,
        itemCount: eventsData.length,
        itemBuilder: (_, index) {
          String dataId = eventsData.keys.elementAt(index);
          var event = eventsData[dataId];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.abc),
              title: Text(event["Name"]),
              subtitle: dataId != selectedId
                  ? Text(event["Date"])
                  : Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event["Date"]),
                            Text(
                                '${event["Adress"]["x"]}, ${event["Adress"]["y"]}'),
                            Text(event["Organiser"])
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${event["Price"]}\$',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite),
                              color:
                                  true // later a reference to events liked by the user
                                      ? Colors.red
                                      : Theme.of(context).disabledColor,
                              onPressed: () {
                                setState(() {
                                  // later adds / removes the event from liked
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
              onTap: () => EventsData.of(context).selector!(
                  dataId, LatLng(event["Adress"]["x"], event["Adress"]["y"])),
            ),
          );
        });
  }
}

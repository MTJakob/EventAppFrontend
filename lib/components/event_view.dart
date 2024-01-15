import 'package:event_flutter_application/components/events_data.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class EventView extends StatelessWidget {
  const EventView({super.key, this.clip = Clip.none});
  final Clip clip;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> eventsData = EventsData.of(context).eventData;

    return AnimatedList(
        clipBehavior: clip,
        initialItemCount: eventsData.length,
        itemBuilder: (_, index, animation) {
          String eventId = eventsData.keys.elementAt(index);
          return EventCard(eventId:eventId);
        });
  }
}

class EventCard extends StatefulWidget {
  const EventCard({super.key, required this.eventId});
  final String eventId;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  String? selectedId;

  bool noneSelected = true;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> eventInfo = EventsData.of(context).eventData[widget.eventId];

    if (EventsData.of(context).selected != null) {
      selectedId = EventsData.of(context).selected!();
    } else {
      noneSelected = false;
    }

    return AnimatedSize(
            duration: Durations.medium1,
            child: Card(
              child: ListTile(
                leading:
                    Icon(EventsData.eventIcons[eventInfo["Category"]] ?? Icons.event, size: 30,),
                title: Text(eventInfo["Name"], softWrap: true),
                subtitle: widget.eventId != selectedId && noneSelected
                    ? Text(eventInfo["Date"], softWrap: true)
                    : Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(eventInfo["Date"], softWrap: true),
                              Text(
                                  '${eventInfo["Address"]["X"]}, ${eventInfo["Address"]["Y"]}',
                                  softWrap: true),
                              Text(eventInfo["Organiser"], softWrap: true)
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  eventInfo["Price"] != null
                                      ? '${eventInfo["Price"]}\$'
                                      : "Free",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  softWrap: true),
                              // is admin
                              true
                                  ? IconButton(
                                      onPressed: () =>
                                          Navigator.pushNamed(context, '/manage'),
                                      icon: const Icon(
                                        Icons.settings,
                                        color: Colors.grey,
                                      ))
                                  : IconButton(
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
                    widget.eventId, LatLng(eventInfo["Address"]["X"], eventInfo["Address"]["Y"])),
              ),
            ),
          );
  }
}

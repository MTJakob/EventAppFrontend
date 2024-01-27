import 'package:event_flutter_application/components/events_data.dart';
import 'package:event_flutter_application/pages/mange_event_page.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class EventView extends StatelessWidget {
  const EventView({super.key, this.clip = Clip.none});
  final Clip clip;

  @override
  Widget build(BuildContext context) {
    int numberOfEntries = EventsData.of(context).eventData.length;
    return AnimatedList(
        clipBehavior: clip,
        initialItemCount: numberOfEntries,
        itemBuilder: (_, index, animation) {
          return EventCard(eventIndex: index);
        });
  }
}

class EventCard extends StatefulWidget {
  const EventCard({super.key, required this.eventIndex});
  final int eventIndex;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  int? selectedIndex;
  late Event event;
  Function? selector;

  void onTap() {
    // if (selector != null) {
    //   selector!(widget.eventIndex,
    //       LatLng(eventInfo["Address"]["X"], eventInfo["Address"]["Y"]));
    // }
  }

  @override
  Widget build(BuildContext context) {
    event = EventsData.of(context).eventData.elementAt(widget.eventIndex);
    selector = EventsData.of(context).selector;
    selectedIndex = EventsData.of(context).selected;

    return AnimatedSize(
      duration: Durations.medium1,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          selected: widget.eventIndex == selectedIndex,
          leading: Icon(
            EventsData.eventIcons[event.category] ?? Icons.event,
            size: 30,
          ),
          title: Text(event.name, softWrap: true),
          subtitle: widget.eventIndex != selectedIndex && selector != null
              ? Text(event.timeRange.start.toString(), softWrap: true)
              : Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.timeRange.start.toString(), softWrap: true),
                        Text('assa',
                            //'${event["Address"]["X"]}, ${event["Address"]["Y"]}',
                            softWrap: true),
                        Text(event.organiser ?? "", softWrap: true)
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            event.price != null
                                ? '${event.price}\$'
                                : "Free",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            softWrap: true),
                        // is admin
                        true
                            ? IconButton(
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ManageEventPage(
                                            eventData: event))),
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
          onTap: onTap,
        ),
      ),
    );
  }
}

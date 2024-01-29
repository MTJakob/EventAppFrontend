import 'package:event_flutter_application/components/events_data.dart';
import 'package:event_flutter_application/components/data_structures.dart';
import 'package:event_flutter_application/components/http_interface.dart';
import 'package:event_flutter_application/pages/mange_event_page.dart';
import 'package:flutter/material.dart';

class EventView extends StatefulWidget {
  const EventView({super.key, this.clip = Clip.antiAlias});
  final Clip clip;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        clipBehavior: widget.clip,
        itemCount: EventsData.of(context).eventData.length,
        itemBuilder: (context, index) {
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
    if (selector != null) {
      selector!(widget.eventIndex, event.location);
    }
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
          title: Text(event.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              softWrap: true),
          subtitle: widget.eventIndex != selectedIndex && selector != null
              ? Text(event.timeRange.start.toString().substring(0, 16),
                  softWrap: true)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "By: ${event.organiser!.name} ${event.organiser!.surname}",
                            softWrap: true),
                        Text(
                            "From: ${event.timeRange.start.toString().substring(0, 16)}",
                            softWrap: true),
                        Text(
                            "To:      ${event.timeRange.end.toString().substring(0, 16)}",
                            softWrap: true)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(event.price != 0 ? '${event.price}\$' : "Free",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            softWrap: true),
                        Text('${event.capacity} max',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            softWrap: true),
                        event.organiser!.id ==
                                AppHttpInterface.of(context).userID!
                            ? IconButton(
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ManageEventPage(eventData: event))),
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

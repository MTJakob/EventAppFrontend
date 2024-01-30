import 'package:event_flutter_application/components/event_view.dart';
import 'package:event_flutter_application/components/events_data.dart';
import 'package:event_flutter_application/components/http_interface.dart';
import 'package:event_flutter_application/components/data_structures.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  int? selectedIndex;

  late Future<List<Event>> events;
  List<Event> oldEvents = [];

  void search(String query) {
    setState(() {
      selectedIndex = null;
      events.then((value) => oldEvents = value);
      events = AppHttpInterface.of(context).searchEvents(query);
    });
  }

  void selector(int index, _) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  void didChangeDependencies() {
    events = AppHttpInterface.of(context).searchEvents("");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SearchBar(
        onChanged: (value) => search(value),
      ),
      Flexible(
          fit: FlexFit.tight,
          child: FutureBuilder<List<Event>>(
              future: events,
              builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                return EventsData(
                  eventData: snapshot.hasData ? snapshot.data! : oldEvents,
                  selected: selectedIndex,
                  selector: selector,
                  child: const EventView(),
                );
              }))
    ]);
  }
}

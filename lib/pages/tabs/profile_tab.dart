import 'package:event_flutter_application/events/event_view.dart';
import 'package:flutter/material.dart';
import 'package:event_flutter_application/data_widget.dart';
import 'package:event_flutter_application/events/events_data.dart';
import 'dart:convert';
import 'package:flutter_cache_manager/file.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    void logOut() {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) {
        return route.toString() == "/";
      });
    }

    return Column(children: [
      const Expanded(
          flex: 2,
          child: Card(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                children: [
                  Text("NAME"),
                  Text("SURNAME"),
                  Text("Birthday"),
                  Text("Email")
                ],
              ),
            ),
          )),
      Expanded(
        flex: 2,
        child: FutureBuilder(
            future: MyAppData.of(context).getFile(),
            builder: (context, AsyncSnapshot<File> snapshot) {
              if (snapshot.hasData) {
                return EventsData(
                  snapshotData: snapshot.data,
                  eventData: json.decode(snapshot.data!.readAsStringSync()),
                  child: const Expanded(
                      flex: 2,
                      child: EventView(
                        clip: Clip.hardEdge,
                      )),
                );
              } else {
                return const Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator());
              }
            }),
      ),
      TextButton(onPressed: logOut, child: const Text("Log Out")),
    ]);
  }
}

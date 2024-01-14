import 'package:event_flutter_application/events/event_view.dart';
import 'package:event_flutter_application/pages/form_fields.dart';
import 'package:flutter/material.dart';
import 'package:event_flutter_application/data_widget.dart';
import 'package:event_flutter_application/events/events_data.dart';
import 'dart:convert';
import 'package:flutter_cache_manager/file.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool isLocked = true;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerSurname = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerBirth = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    void logOut() {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) {
        return route.toString() == "/";
      });
    }

    Widget card = Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NameField(controller: controllerName, isLocked: isLocked),
              NameField(
                controller: controllerSurname,
                isLocked: isLocked,
                hintText: "Surname",
              ),
              EmailField(
                controller: controllerEmail,
                isLocked: isLocked,
              ),
              BirthdayField(
                controller: controllerBirth,
                isLocked: isLocked,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: logOut, child: const Text("Log Out")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isLocked
                          ? const SizedBox()
                          : IconButton(
                              tooltip: "Cancel",
                              onPressed: () {
                                setState(() {
                                  controllerBirth.clear();
                                  controllerEmail.clear();
                                  controllerName.clear();
                                  controllerSurname.clear();
                                  isLocked = !isLocked;
                                });
                              },
                              icon: const Icon(Icons.close)),
                      IconButton(
                          tooltip: isLocked ? "Edit" : "Accept",
                          onPressed: () => setState(() {
                                isLocked = !isLocked;
                              }),
                          icon: Icon(
                              isLocked ? Icons.border_color : Icons.check)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    Widget list = FutureBuilder(
        future: MyAppData.of(context).getFile(),
        builder: (context, AsyncSnapshot<File> snapshot) {
          if (snapshot.hasData) {
            return EventsData(
              snapshotData: snapshot.data,
              eventData: json.decode(snapshot.data!.readAsStringSync()),
              child: const EventView(
                clip: Clip.hardEdge,
              ),
            );
          } else {
            return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator());
          }
        });

    return aspectRatio > 1
        ? Row(children: [Expanded(child: card), Expanded(child: list)])
        : Column(
            children: [card, Expanded(child: list)],
          );
  }
}

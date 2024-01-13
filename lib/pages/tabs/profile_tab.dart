import 'package:event_flutter_application/events/event_view.dart';
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
    void logOut() {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) {
        return route.toString() == "/";
      });
    }

    TextStyle style = const TextStyle(fontSize: 25);

    return Column(children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                textCapitalization: TextCapitalization.words,
                style: style,
                controller: controllerName,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                maxLength: isLocked ? null : 16,
                decoration: const InputDecoration(hintText: "Name", prefixIcon: Icon(Icons.person),),
                readOnly: isLocked,
              ),
              TextField(
                textCapitalization: TextCapitalization.words,
                style: style,
                controller: controllerSurname,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                maxLength: isLocked ? null : 16,
                decoration: const InputDecoration(hintText: "Surame", prefixIcon: Icon(Icons.person)),
                readOnly: isLocked,
              ),
              TextField(
                style: style,
                controller: controllerEmail,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.mail)),
                readOnly: isLocked,
              ),
              // need to change to a datetime picker
              TextField(
                style: style,
                controller: controllerBirth,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: "Birthday", prefixIcon: Icon(Icons.cake)),
                readOnly: isLocked,
              ),
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
                      icon: Icon(isLocked ? Icons.border_color : Icons.check)),
                ],
              )
            ],
          ),
        ),
      ),
      Expanded(
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

import 'package:event_flutter_application/components/event_view.dart';
import 'package:event_flutter_application/components/form_fields.dart';
import 'package:event_flutter_application/pages/dialogs/password_dialog.dart';
import 'package:event_flutter_application/pages/mange_event_page.dart';
import 'package:flutter/material.dart';
import 'package:event_flutter_application/components/data_widget.dart';
import 'package:event_flutter_application/components/events_data.dart';
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
    Size size = MediaQuery.of(context).size;
    bool isHorizontal = size.aspectRatio > 1;

    final formKey = GlobalKey<FormState>();

    void logOut() {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) {
        return route.toString() == "/";
      });
    }

    void lockToggle() {
      setState(() {
        isLocked = !isLocked;
      });
    }

    controllerName.text = "Name";
    controllerSurname.text = "Surname";
    controllerEmail.text = "xyz@gmail.com";
    controllerBirth.text = "2000-10-02";

    return Flex(
      direction: isHorizontal ? Axis.horizontal : Axis.vertical,
      children: [
        ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: size.width / (isHorizontal ? 2.2 : 1)),
          child: Card(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NameField(
                        controller: controllerName,
                        isLocked: isLocked,
                        isDense: isHorizontal),
                    NameField(
                        controller: controllerSurname,
                        isLocked: isLocked,
                        hintText: "Surname",
                        isDense: isHorizontal),
                    EmailField(
                        controller: controllerEmail,
                        isLocked: isLocked,
                        isDense: isHorizontal),
                    BirthdayField(
                        controller: controllerBirth,
                        isLocked: isLocked,
                        isDense: isHorizontal),
                    Wrap(
                      spacing: 20,
                      alignment: WrapAlignment.spaceBetween,
                      children: isLocked
                          ? [
                              ActionChip(
                                  label: const Text("Change password"),
                                  avatar: const Icon(Icons.password),
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const PasswordDialog(),
                                      barrierDismissible: false)),
                              ActionChip(
                                label: const Text("Edit profile"),
                                avatar: const Icon(Icons.border_color),
                                onPressed: lockToggle,
                              ),
                              ActionChip(
                                  label: const Text("Log out"),
                                  avatar: const Icon(Icons.logout),
                                  onPressed: logOut),
                              ActionChip(
                                label: const Text("Add event"),
                                avatar: const Icon(Icons.event),
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ManageEventPage())),
                              )
                            ]
                          : [
                              ActionChip(
                                label: const Text("Cancel"),
                                avatar: const Icon(Icons.close),
                                onPressed: () {
                                  controllerBirth.clear();
                                  controllerEmail.clear();
                                  controllerName.clear();
                                  controllerSurname.clear();
                                  lockToggle();
                                },
                              ),
                              ActionChip(
                                label: const Text("Accept"),
                                avatar: const Icon(Icons.check),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    lockToggle();
                                  }
                                },
                              ),
                            ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Flexible(
            fit: FlexFit.tight,
            child: FutureBuilder(
                future: MyAppData.of(context).getFile(),
                builder: (context, AsyncSnapshot<File> snapshot) {
                  if (snapshot.hasData) {
                    return EventsData(
                      snapshotData: snapshot.data,
                      eventData: json
                          .decode(snapshot.data!.readAsStringSync())
                          .cast<Map<String, dynamic>>(),
                      child: const EventView(
                        clip: Clip.hardEdge,
                      ),
                    );
                  } else {
                    return const Align(
                        alignment: Alignment.topCenter,
                        child: LinearProgressIndicator());
                  }
                }))
      ],
    );
  }
}

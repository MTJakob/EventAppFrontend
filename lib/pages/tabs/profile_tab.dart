import 'package:event_flutter_application/components/event_view.dart';
import 'package:event_flutter_application/components/form_fields.dart';
import 'package:event_flutter_application/pages/dialogs/password_dialog.dart';
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
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

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

    Widget card = Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NameField(
                  controller: controllerName,
                  isLocked: isLocked,
                ),
                NameField(
                  controller: controllerSurname,
                  isLocked: isLocked,
                ),
                EmailField(
                  controller: controllerEmail,
                  isLocked: isLocked,
                ),
                BirthdayField(
                  controller: controllerBirth,
                  isLocked: isLocked,
                ),
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
                                  builder: (context) => const PasswordDialog(),
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

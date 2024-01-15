import 'package:event_flutter_application/components/title.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:event_flutter_application/components/form_fields.dart';

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({super.key, this.eventData});

  final dynamic eventData;

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  Duration duration = const Duration();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    TextEditingController nameController = TextEditingController();
    // TextEditingController surnameController = TextEditingController();
    // TextEditingController emailController = TextEditingController();
    // TextEditingController passwordController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    void submit() {
      if (formKey.currentState!.validate()) {}
    }

    return Scaffold(
      appBar: AppBar(title: const TitleText(), actions: [IconButton(onPressed: submit, icon: const Icon(Icons.check))],),
      body: Card(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Form(
            key: formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                clipBehavior: Clip.antiAlias,
                children: [
                  //name, time, duration, capacity, price, address, category
                  NameField(
                    controller: nameController,
                    hintText: "Name",
                    icon: Icons.abc,
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    controller: dateController,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    icon: const Icon(Icons.event_note),
                    dateHintText: "Date",
                    timeHintText: "Time",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

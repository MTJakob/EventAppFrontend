import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:event_flutter_application/components/form_fields.dart';

class ManageEventDialog extends StatefulWidget {
  const ManageEventDialog({super.key, this.eventData});

  final dynamic eventData;

  @override
  State<ManageEventDialog> createState() => _ManageEventDialogState();
}

class _ManageEventDialogState extends State<ManageEventDialog> {
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

    return AlertDialog(
      title: const Text("Edit event"),
      content: Form(
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
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(onPressed: submit, child: const Text("Save"))
      ],
    );
  }
}

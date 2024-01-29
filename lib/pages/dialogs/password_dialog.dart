import 'package:event_flutter_application/components/form_fields.dart';
import 'package:event_flutter_application/components/http_interface.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class PasswordDialog extends StatefulWidget {
  const PasswordDialog({super.key});

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isHorizontal = MediaQuery.sizeOf(context).aspectRatio > 1;

    TextEditingController oldPwd = TextEditingController();
    TextEditingController newPwd = TextEditingController();
    TextEditingController repeatPwd = TextEditingController();

    void submit() {
      if (formKey.currentState!.validate()) {
        AppHttpInterface.of(context)
            .changePassword(newPwd.text, oldPwd.text)
            .then((response) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(json.decode(response.body)["message"])));
          if (response.statusCode == 201) Navigator.pop(context);
        });
      }
    }

    return AlertDialog(
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
      insetPadding: const EdgeInsets.symmetric(horizontal: 50),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: isHorizontal
          ? null
          : const Text(
              "Password change",
              textAlign: TextAlign.center,
            ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              PasswordField(
                controller: oldPwd,
                hintText: "Old Password",
                isDense: isHorizontal,
              ),
              PasswordField(
                  controller: newPwd,
                  hintText: "New Password",
                  showPolicy: true,
                  isDense: isHorizontal),
              PasswordField(
                  controller: repeatPwd,
                  hintText: "Repeat Password",
                  firstField: newPwd,
                  isDense: isHorizontal)
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(onPressed: submit, child: const Text("Submit"))
      ],
    );
  }
}

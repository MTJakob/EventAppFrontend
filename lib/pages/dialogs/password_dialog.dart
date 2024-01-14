import 'package:event_flutter_application/components/form_fields.dart';
import 'package:flutter/material.dart';

class PasswordDialog extends StatelessWidget {
  const PasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    TextEditingController oldPwd = TextEditingController();
    TextEditingController newPwd = TextEditingController();
    TextEditingController repeatPwd = TextEditingController();

    void submit() {
      if (formKey.currentState!.validate()) {
        Navigator.pop(context);
      }
    }

    return AlertDialog(
      title: const Text("Password change"),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            children: [
              PasswordField(controller: oldPwd, hintText: "Old Password",),
              PasswordField(controller: newPwd, hintText: "New Password",showPolicy: true,),
              PasswordField(controller: repeatPwd, hintText: "Repeat Password", firstField: newPwd,)
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
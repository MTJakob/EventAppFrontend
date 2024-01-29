import 'package:event_flutter_application/components/form_fields.dart';
import 'package:event_flutter_application/components/http_interface.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class RegistrationDialog extends StatefulWidget {
  const RegistrationDialog({super.key});

  @override
  State<RegistrationDialog> createState() => _RegistrationDialogState();
}

class _RegistrationDialogState extends State<RegistrationDialog> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isHorizontal = MediaQuery.sizeOf(context).aspectRatio > 1;

    TextEditingController nameController = TextEditingController();
    TextEditingController surnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    void submit() {
      if (formKey.currentState!.validate()) {
        AppHttpInterface.of(context)
            .register(
                email: emailController.text,
                name: nameController.text,
                surname: surnameController.text,
                dateOfBirth: dateController.text,
                password: passwordController.text)
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
              "Tell us about yourself",
              textAlign: TextAlign.center,
            ),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            children: [
              NameField(
                controller: nameController,
                isDense: isHorizontal,
              ),
              NameField(
                  controller: surnameController,
                  hintText: "Surname",
                  isDense: isHorizontal),
              BirthdayField(controller: dateController, isDense: isHorizontal),
              EmailField(controller: emailController, isDense: isHorizontal),
              PasswordField(
                  controller: passwordController,
                  showPolicy: true,
                  isDense: isHorizontal),
              PasswordField(
                  hintText: "Repeat Password",
                  firstField: passwordController,
                  isDense: isHorizontal)
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(onPressed: submit, child: const Text("Register"))
      ],
    );
  }
}

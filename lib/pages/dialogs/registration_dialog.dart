import 'package:event_flutter_application/components/form_fields.dart';
import 'package:flutter/material.dart';

class RegistrationDialog extends StatelessWidget {
  const RegistrationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    TextEditingController nameController = TextEditingController();
    TextEditingController surnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    void submit() {
      if (formKey.currentState!.validate()) {
        // Map <String, String> formData = {
        //   "Name" : nameController.text,
        //   "Surname" : surnameController.text,
        //   "Email" : emailController.text,
        //   "DateOfBirth" : dateController.text
        // };
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) {
          return route.toString() == "/";
        });
      }
    }

    return AlertDialog(
      title: const Text("Tell us about yourself"),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            children: [
              NameField(controller: nameController),
              NameField(controller: surnameController, hintText: "Surname"),
              EmailField(controller: emailController),
              PasswordField(controller: passwordController, showPolicy: true,),
              BirthdayField(controller: dateController)
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

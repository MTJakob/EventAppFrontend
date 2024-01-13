import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';

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
              TextFormField(
                controller: nameController,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                maxLength: 16,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? current) {
                  return isAlpha(current!)
                      ? null
                      : "Only english characters allowed!";
                },
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person), labelText: "Name"),
              ),
              TextFormField(
                controller: surnameController,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                maxLength: 16,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? current) {
                  return isAlpha(current!)
                      ? null
                      : "Only english characters allowed!";
                },
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person), labelText: "Surname"),
              ),
              TextFormField(
                controller: emailController,
                validator: (String? current) {
                  return isEmail(current!) ? null : "Not a valid email adress!";
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail), labelText: "Email adress"),
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock), labelText: "Password"),
              ),
              TextFormField(
                  validator: (String? current) {
                    return isDate(current!) ? null : "Not a valid date!";
                  },
                  controller: dateController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.cake),
                      labelText: "Birthday"),
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                        helpText: "Select your birthday",
                        initialDatePickerMode: DatePickerMode.year,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        context: context,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 13)));
                    if (picked != null) {
                      dateController.text = picked.toString().split(' ').first;
                    }
                  })
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

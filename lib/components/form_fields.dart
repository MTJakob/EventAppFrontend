import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';

class NameField extends StatelessWidget {
  const NameField(
      {super.key,
      required this.controller,
      this.hintText = "Name",
      this.isLocked = false});
  final TextEditingController controller;
  final String hintText;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isLocked,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: isLocked ? null : 16,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (String? current) {
        return isAlpha(current!) ? null : "Only english characters allowed!";
      },
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person), hintText: hintText),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField(
      {super.key,
      required this.controller,
      this.hintText = "Email",
      this.isLocked = false});
  final TextEditingController controller;
  final String hintText;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isLocked,
      validator: (String? current) {
        return isEmail(current!) ? null : "Not a valid email adress!";
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail), hintText: hintText),
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField(
      {super.key,
      required this.controller,
      this.hintText = "Password",
      this.isLocked = false,
      this.firstField,
      this.showPolicy = false});
  final TextEditingController controller;
  final String hintText;
  final bool isLocked;
  final TextEditingController? firstField;
  final bool showPolicy;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: isLocked,
      validator: (current) {
        if (current == null) {
          return "Cannot be empty";
        } else if (firstField != null) {
          return current == firstField!.text ? null : "Passwords do not match";
        }
        String prompt = "";
        if (!current.contains(RegExp(r'[A-Z]'))) {
          prompt += "uppercase, ";
        }
        if (!current.contains(RegExp(r'[a-z]'))) {
          prompt += "lowercase, ";
        }
        if (!current.contains(RegExp(r'[0-9]'))) {
          prompt += "digit, ";
        }
        if (!current.contains(RegExp(r'[!@#\$&%.*]'))) {
          prompt += "special";
        }
        if (prompt != "") {
          return "Missing: $prompt";
        } else if (current.length < 8 || current.length > 20) {
          return "Has to be 8-20 characters";
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          hintText: hintText,
          helperText: showPolicy? "8-20 characters: A-Z, a-z, 0-9, (!@#\$&%.*)":null,
          helperMaxLines: 6),
    );
  }
}

class BirthdayField extends StatelessWidget {
  const BirthdayField(
      {super.key,
      required this.controller,
      this.hintText = "Birthday",
      this.isLocked = false});
  final TextEditingController controller;
  final String hintText;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (String? current) {
          return isDate(current!) ? null : "Not a valid date!";
        },
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.cake), hintText: hintText),
        readOnly: true,
        onTap: () async {
          if (!isLocked) {
            DateTime? picked = await showDatePicker(
                helpText: "Select your birthday",
                initialDatePickerMode: DatePickerMode.year,
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                context: context,
                firstDate: DateTime(1900),
                lastDate:
                    DateTime.now().subtract(const Duration(days: 365 * 13)));
            if (picked != null) {
              controller.text = picked.toString().split(' ').first;
            }
          }
        });
  }
}

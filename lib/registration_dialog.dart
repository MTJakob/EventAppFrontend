import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class RegistrationDialog extends StatelessWidget {
  const RegistrationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    void submit() {
      if(formKey.currentState!.validate()){Navigator.pushNamedAndRemoveUntil(context, '/main', (route) {
        return route.toString() == "/";
      });}
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? current){return isAlpha(current!) ? null : "Only english characters allowed!";},
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person), labelText: "Name"),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? current){return isAlpha(current!) ? null : "Only english characters allowed!";},
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person), labelText: "Surname"),
              ),
              TextFormField(
                validator: (String? current){return isEmail(current!) ? null : "Not a valid email adress!";},
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail), labelText: "Email adress"),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock), labelText: "Password"),
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                    labelText: "Birthday"),
                    smartDashesType: SmartDashesType.enabled,
              )
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

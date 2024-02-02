import 'package:event_flutter_application/components/http_interface.dart';
import 'package:event_flutter_application/pages/dialogs/registration_dialog.dart';
import 'package:event_flutter_application/components/title.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController loginController = TextEditingController();
    TextEditingController pwdController = TextEditingController();

    void submit() {
      AppHttpInterface.of(context)
          .logIn(loginController.text, pwdController.text)
          .then((value) => value == null
              ? null
              : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(value),
                  duration: const Duration(seconds: 2),
                )));
    }

    return Scaffold(
      body: Center(
        child: Form(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const TitleText(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: loginController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Email:",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 5)),
                  ),
                ),
              ),
              TextFormField(
                controller: pwdController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Password:",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 5)),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Not registered yet?"),
                TextButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (_) => const RegistrationDialog(),
                        barrierDismissible: false),
                    child: const Text("SIGN UP")),
              ]),
              FilledButton.tonal(
                  onPressed: submit, child: const Text("Submit")),
            ],
          ),
        )),
      ),
    );
  }
}

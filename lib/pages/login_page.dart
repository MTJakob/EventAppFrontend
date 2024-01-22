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
      Navigator.pushNamedAndRemoveUntil(context, '/main', ModalRoute.withName('/'));
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

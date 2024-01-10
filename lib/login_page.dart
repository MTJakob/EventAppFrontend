import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController loginController = TextEditingController();
    TextEditingController pwdController = TextEditingController();

    void submit() {
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) {
        return route.toString() == "/";
      });
    }

    return Scaffold(
      body: Form(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: [
              const Text(
                "Event manager",
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(2),
              ),
              TextFormField(
                controller: loginController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Login:",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 5)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: pwdController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password:",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 5)),
                  ),
                ),
              ),
              FilledButton.tonal(
                  onPressed: submit, child: const Text("Submit")),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Not registered yet?"),
                TextButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel")),
                                TextButton(
                                    onPressed: submit,
                                    child: const Text("Register"))
                              ],
                            ),
                        barrierDismissible: false),
                    child: const Text("SIGN UP"))
              ])
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:event_flutter_application/login_page.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    void logOut() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }

    return Center(
      child: TextButton(onPressed: logOut, child: const Text("Log Out")),
    );
  }
}

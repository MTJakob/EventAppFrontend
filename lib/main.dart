import 'package:event_flutter_application/pages/login_page.dart';
import 'package:event_flutter_application/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'components/http_interface.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:event_flutter_application/components/title.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  void refreshUser() {
    setState(() => ());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.read(key: "jwt"),
      builder: ((context, snapshot) {
        final Widget page;
        int? id;
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic>? jwt = JwtDecoder.tryDecode(snapshot.data ?? "");
          if (jwt != null &&
              jwt["sub"] != null &&
              !JwtDecoder.isExpired(snapshot.data!)) {
            id = jwt["sub"];
            page = const MainPage();
          } else {
            page = const LoginPage();
          }
        } else {
          page = Scaffold(
              appBar: AppBar(
                title: const TitleText(),
              ),
              body: const Center(child: CircularProgressIndicator()));
        }
        return AppHttpInterface(
            userID: id,
            refreshUser: refreshUser,
            storage: storage,
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Event Manager',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.amber.shade900,
                      brightness: Brightness.dark),
                  useMaterial3: true,
                ),
                home: page));
      }),
    );
  }
}

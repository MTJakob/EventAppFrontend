import 'package:event_flutter_application/tabs/home_tab.dart';
import 'package:event_flutter_application/tabs/profile_tab.dart';
import 'package:event_flutter_application/tabs/search_tab.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Manager"),
      ),
      bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.search), label: "Search"),
        NavigationDestination(icon: Icon(Icons.person), label: "Profile")
      ],
      selectedIndex: currentPageIndex,
      onDestinationSelected:(int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      ),
      body: SafeArea(child: [
        const HomeTab(),
        const SearchTab(),
        const ProfileTab()
      ][currentPageIndex])
    );
  }
}
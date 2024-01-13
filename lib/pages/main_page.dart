import 'package:event_flutter_application/pages/tabs/home_tab.dart';
import 'package:event_flutter_application/pages/tabs/profile_tab.dart';
import 'package:event_flutter_application/pages/tabs/search_tab.dart';
import 'package:event_flutter_application/title.dart';
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
    PageController controller = PageController(initialPage: currentPageIndex);
    return Scaffold(
        appBar: AppBar(
          title: const TitleText(),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.search), label: "Search"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile")
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            controller.jumpToPage(index);
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
        body: SafeArea(
            child: PageView(
          controller: controller,
          children: const [HomeTab(), SearchTab(), ProfileTab()],
        )));
  }
}

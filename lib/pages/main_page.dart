import 'package:event_flutter_application/pages/tabs/home_tab.dart';
import 'package:event_flutter_application/pages/tabs/profile_tab.dart';
import 'package:event_flutter_application/pages/tabs/search_tab.dart';
import 'package:event_flutter_application/components/title.dart';
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
    bool isHorizontal = MediaQuery.of(context).size.aspectRatio > 1;

    destinationSelect(int index) {
      setState(() {
        currentPageIndex = index;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const TitleText(),
        ),
        bottomNavigationBar: isHorizontal
            ? null
            : NavigationBar(
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                  NavigationDestination(
                      icon: Icon(Icons.search), label: "Search"),
                  NavigationDestination(
                      icon: Icon(Icons.person), label: "Profile")
                ],
                selectedIndex: currentPageIndex,
                onDestinationSelected: (int index) {
                  controller.animateToPage(index,
                      duration: Durations.extralong4,
                      curve: Curves.fastEaseInToSlowEaseOut);
                  destinationSelect(index);
                },
              ),
        body: SafeArea(
            child: Row(
          children: [
            isHorizontal
                ? NavigationRail(
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                          icon: Icon(Icons.home), label: Text("Home")),
                      NavigationRailDestination(
                          padding:
                              EdgeInsetsDirectional.symmetric(vertical: 25),
                          icon: Icon(Icons.search),
                          label: Text("Search")),
                      NavigationRailDestination(
                          icon: Icon(Icons.person), label: Text("Profile"))
                    ],
                    selectedIndex: currentPageIndex,
                    onDestinationSelected: (int index) {
                      controller.animateToPage(index,
                          duration: Durations.extralong4,
                          curve: Curves.fastEaseInToSlowEaseOut);
                      destinationSelect(index);
                    },
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: PageView(
                scrollDirection: isHorizontal
                    ? Axis.vertical
                    : Axis.horizontal,
                onPageChanged: (int newIndex) {
                  currentPageIndex != newIndex
                      ? destinationSelect(newIndex)
                      : null;
                },
                controller: controller,
                children: const [HomeTab(), SearchTab(), ProfileTab()],
              ),
            ),
          ],
        )));
  }
}

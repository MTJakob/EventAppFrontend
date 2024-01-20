import 'package:event_flutter_application/components/http_interface.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.topCenter,
      child: SearchAnchor.bar(
        isFullScreen: false,
          suggestionsBuilder: (context, searchcontroller) async {
            Future<List<String>> list = AppHttpInterface.of(context).searchEvents(searchcontroller.text);
             return list.then((value) => List.generate(value.length, (index) =>  ListTile(title: Text(value.elementAt(index)),)));
          }),
    );
  }
}

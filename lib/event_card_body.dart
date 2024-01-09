import 'package:flutter/material.dart';

class EventCardBody extends StatelessWidget {
  const EventCardBody(this.data,
      {super.key,  this.isSelected = false});
  final dynamic data;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return !isSelected
        ? Text(data["Date"])
        : Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["Date"]),
                  Text('${data["Adress"]["x"]}, ${data["Adress"]["y"]}'),
                  Text(data["Organiser"])
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data["Price"]}\$',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: null,
                  ),
                ],
              )
            ],
          );
  }
}

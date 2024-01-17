import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:event_flutter_application/components/form_fields.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:validators/validators.dart';
//import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({super.key, this.eventData});

  final Map<String, dynamic>? eventData;

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  TextEditingController daysController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  MapController mapController = MapController();
  LatLng? coordinates;
  Duration duration = const Duration();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.eventData != null) {
      nameController.text = widget.eventData!["Name"];
      categoryController.text = widget.eventData!["Category"];
      priceController.text = widget.eventData!["Price"] == null
          ? ""
          : '${widget.eventData!["Price"]}';
      //capacityController.text = widget.eventData["Capacity"];
      //dateController.text = widget.eventData["Date"];
      coordinates = LatLng(
          widget.eventData!["Address"]["X"], widget.eventData!["Address"]["Y"]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isHorizontal = MediaQuery.of(context).size.aspectRatio > 1;

    void submit() {
      if (formKey.currentState!.validate()) {}
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage your event",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [IconButton(onPressed: submit, icon: const Icon(Icons.check))],
      ),
      body: Card(
        margin: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
          clipBehavior: Clip.antiAlias,
          children: [
            Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Table(
                    children: [
                      TableRow(children: [
                        NameField(
                          isDense: isHorizontal,
                          controller: nameController,
                          hintText: "Name",
                          icon: Icons.abc,
                        ),
                        CategoryPick(controller: categoryController),
                      ]),
                      TableRow(children: [
                        NumberField(
                          controller: priceController,
                          hintText: "Price",
                          suffix: "\$",
                          icon: Icons.price_change,
                          isDense: isHorizontal,
                        ),
                        NumberField(
                          controller: capacityController,
                          hintText: "Capacity",
                          suffix: "max",
                          icon: Icons.people,
                          isDense: isHorizontal,
                        ),
                      ]),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DateTimePicker(
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      type: DateTimePickerType.dateTimeSeparate,
                      controller: dateController,
                      dateHintText: "Date of the event",
                      timeHintText: "Hour",
                      icon: const Icon(Icons.event_note),
                      validator: (val) => isDate(val!) ? null : "Select a date",
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: NumberField(
                          controller: daysController,
                          suffix: "days",
                          icon: Icons.more_time,
                          isDense: isHorizontal,
                        ),
                      ),
                      Flexible(
                          child: NumberField(
                              controller: hoursController,
                              suffix: "h",
                              isDense: isHorizontal)),
                      Flexible(
                          child: NumberField(
                              controller: minutesController,
                              suffix: "min",
                              isDense: isHorizontal)),
                    ],
                  )
                ],
              ),
            ),
            // SizedBox.square(
            //   dimension: 500,
            //   child: FlutterMap(
            //           mapController: mapController,
            //           options: const MapOptions(
            //               keepAlive: true,
            //               initialCenter: LatLng(38.1858, 15.5561),
            //               initialZoom: 16),
            //           children: [
            //         TileLayer(
            //           urlTemplate:
            //               'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            //         ),
            //         Container(
            //             alignment: Alignment.topRight,
            //             child: IconButton(
            //               onPressed: () => mapController.rotate(0),
            //               icon: const Icon(Icons.navigation_rounded),
            //               color: Theme.of(context).primaryColor,
            //             ))
            //       ]),
            // )
          ],
        ),
      ),
    );
  }
}

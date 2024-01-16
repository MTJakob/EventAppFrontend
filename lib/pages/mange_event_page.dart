import 'package:event_flutter_application/components/title.dart';
import 'package:flutter/material.dart';
import 'package:event_flutter_application/components/form_fields.dart';
import 'package:latlong2/latlong.dart';
//import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({super.key, this.eventData});

  final dynamic eventData;

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  LatLng? coordinates;
  Duration duration = const Duration();

  @override
  void initState() {
    if (widget.eventData != null) {
      nameController.text = widget.eventData["Name"];
      categoryController.text = widget.eventData["Category"];
      priceController.text = widget.eventData["Price"] == "null"
          ? ""
          : '${widget.eventData["Price"]}';
      //capacityController.text = widget.eventData["Capacity"];
      //dateController.text = widget.eventData["Date"];
      coordinates = LatLng(
          widget.eventData["Address"]["X"], widget.eventData["Address"]["Y"]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    void submit() {
      if (formKey.currentState!.validate()) {}
    }

    return Scaffold(
      appBar: AppBar(
        title: const TitleText(),
        actions: [IconButton(onPressed: submit, icon: const Icon(Icons.check))],
      ),
      body: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Form(
            key: formKey,
            child: ListView(
              scrollDirection:
                  aspectRatio > 1 ? Axis.horizontal : Axis.vertical,
              clipBehavior: Clip.antiAlias,
              children: [
                //time, duration, location
                Expanded(
                  child: Table(
                    children: [
                      TableRow(children: [
                        NameField(
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
                        ),
                        NumberField(
                          controller: capacityController,
                          hintText: "Capacity",
                          suffix: "max",
                          icon: Icons.people,
                        ),
                      ])
                    ],
                  ),
                ),
                // SizedBox(
                //   width: 500,
                //   height: 400,
                //   child: FlutterLocationPicker(
                //       searchBarBackgroundColor:
                //           Theme.of(context).cardColor.withAlpha(196),
                //       selectedLocationButtonTextstyle:
                //           const TextStyle(fontSize: 15),
                //       selectLocationButtonText: "Select location",
                //       selectLocationButtonWidth: 200,
                //       showZoomController: false,
                //       showLocationController: false,
                //       loadingWidget: const CircularProgressIndicator(),
                //       urlTemplate:
                //           'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                //       initPosition: coordinates == null
                //           ? const LatLong(38.1858, 15.5561)
                //           : LatLong(
                //               coordinates!.latitude, coordinates!.longitude),
                //       onPicked: (pickedData) {
                //         coordinates = pickedData.latLong.toLatLng();
                //       }),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

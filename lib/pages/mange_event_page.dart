import 'package:event_flutter_application/components/title.dart';
import 'package:flutter/material.dart';
// import 'package:date_time_picker/date_time_picker.dart';
import 'package:event_flutter_application/components/form_fields.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({super.key, this.eventData});

  final dynamic eventData;

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  Duration duration = const Duration();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    TextEditingController nameController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    LatLng coordinates;

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
            child: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                clipBehavior: Clip.antiAlias,
                children: [
                  //time, duration, capacity, price
                  NameField(
                    controller: nameController,
                    hintText: "Name",
                    icon: Icons.abc,
                  ),
                  // DateTimePicker(
                  //   type: DateTimePickerType.dateTimeSeparate,
                  //   controller: dateController,
                  //   firstDate: DateTime.now(),
                  //   lastDate: DateTime.now().add(const Duration(days: 365)),
                  //   initialEntryMode: DatePickerEntryMode.calendarOnly,
                  //   icon: const Icon(Icons.event_note),
                  //   dateHintText: "Date",
                  //   timeHintText: "Time",
                  // ),
                  CategoryPick(controller: categoryController),
                  SizedBox(
                    width: 500,
                    height: 400,
                    child: FlutterLocationPicker(
                        searchBarBackgroundColor:
                            Theme.of(context).cardColor.withAlpha(196),
                        selectedLocationButtonTextstyle:
                            const TextStyle(fontSize: 15),
                        selectLocationButtonText: "Select location",
                        selectLocationButtonWidth: 200,
                        showZoomController: false,
                        showLocationController: false,
                        loadingWidget: const CircularProgressIndicator(),
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        initPosition: const LatLong(38.1858, 15.5561),
                        onPicked: (pickedData) {
                          coordinates = pickedData.latLong.toLatLng();
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

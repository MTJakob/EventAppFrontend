import 'package:date_time_picker/date_time_picker.dart';
import 'package:event_flutter_application/components/data_structures.dart';
import 'package:event_flutter_application/components/http_interface.dart';
import 'package:flutter/material.dart';
import 'package:event_flutter_application/components/form_fields.dart';
import 'package:latlong2/latlong.dart';
import 'package:validators/validators.dart';

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({super.key, this.eventData});

  final Event? eventData;

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  final formKey = GlobalKey<FormState>();

  int? id;

  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController capacityController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController daysController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  Duration duration = const Duration();

  LatLng coordinates = const LatLng(0, 0);

  @override
  void initState() {
    if (widget.eventData != null) {
      id = widget.eventData!.id;
      nameController.text = widget.eventData!.name;
      categoryController.text = widget.eventData!.category;
      priceController.text = widget.eventData!.price.toString();
      capacityController.text = widget.eventData!.capacity.toString();
      dateController.text = widget.eventData!.timeRange.start.toString();
      duration = widget.eventData!.timeRange.duration;
      daysController.text = duration.inDays.toString();
      hoursController.text = (duration.inHours % 24).toString();
      minutesController.text = (duration.inMinutes % 60).toString();
      coordinates = widget.eventData!.location;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool isHorizontal = size.aspectRatio > 1;

    void submit() {
      if (formKey.currentState!.validate()) {
        duration = Duration(
            days:
                daysController.text == "" ? 0 : int.parse(daysController.text),
            hours: hoursController.text == ""
                ? 0
                : int.parse(hoursController.text),
            minutes: minutesController.text == ""
                ? 0
                : int.parse(minutesController.text));
        DateTime start = DateTime.parse(dateController.text);
        Event event = Event(
            id: id,
            name: nameController.text,
            price: double.parse(priceController.text),
            capacity: int.parse(capacityController.text),
            category: categoryController.text,
            location: coordinates,
            timeRange: DateTimeRange(start: start, end: start.add(duration)));

        AppHttpInterface.of(context).placeEvent(event).then((value) {
          if (value != "") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value),
              duration: const Duration(seconds: 2),
            ));
            Navigator.of(context).pop();
          }
        });
      }
    }

    void remove() {
      AppHttpInterface.of(context).deleteEvent(widget.eventData!).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value)));
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }

    void changeLocation(LatLng location) {
      coordinates = location;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage your event",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          id == null
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                              "Are you sure you want to delete this event?",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              OutlinedButton.icon(
                                onPressed: Navigator.of(context).pop,
                                label: const Text("No"),
                                icon: const Icon(Icons.close),
                              ),
                              OutlinedButton.icon(
                                onPressed: remove,
                                label: const Text("Yes"),
                                icon: const Icon(Icons.check),
                              ),
                            ],
                          )),
                  icon: const Icon(Icons.delete_forever)),
          IconButton(onPressed: submit, icon: const Icon(Icons.check))
        ],
      ),
      body: Card(
        margin: const EdgeInsets.all(10),
        child: Flex(
          direction: isHorizontal ? Axis.horizontal : Axis.vertical,
          clipBehavior: Clip.antiAlias,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: size.width / (isHorizontal ? 2.2 : 1)),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                              isDouble: true,
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
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          type: DateTimePickerType.dateTimeSeparate,
                          controller: dateController,
                          dateHintText: "Date of the event",
                          timeHintText: "Hour",
                          icon: const Icon(Icons.event_note),
                          validator: (val) =>
                              isDate(val!) ? null : "Select a date",
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
              ),
            ),
            Expanded(
              child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  clipBehavior: Clip.hardEdge,
                  elevation: 10,
                  child: MapInput(submit: changeLocation)),
            )
          ],
        ),
      ),
    );
  }
}

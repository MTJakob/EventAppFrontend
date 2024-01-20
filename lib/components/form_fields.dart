import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';
import 'package:event_flutter_application/components/events_data.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class NameField extends StatelessWidget {
  const NameField(
      {super.key,
      required this.controller,
      this.hintText = "Name",
      this.isLocked = false,
      this.icon = Icons.person,
      this.isDense = false});
  final TextEditingController controller;
  final String hintText;
  final bool isLocked;
  final IconData icon;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: controller,
          readOnly: isLocked,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLength: isLocked ? null : 20,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? current) {
            return isAlpha(current!)
                ? null
                : "Only english characters allowed!";
          },
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              prefixIcon: Icon(icon), hintText: hintText, isDense: isDense),
        ));
  }
}

class EmailField extends StatelessWidget {
  const EmailField(
      {super.key,
      required this.controller,
      this.hintText = "Email",
      this.isLocked = false,
      this.isDense = false});
  final TextEditingController controller;
  final String hintText;
  final bool isLocked;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: controller,
          readOnly: isLocked,
          validator: (String? current) {
            return isEmail(current!) ? null : "Not a valid email adress!";
          },
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail),
              hintText: hintText,
              isDense: isDense),
        ));
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField(
      {super.key,
      required this.controller,
      this.hintText = "Password",
      this.isLocked = false,
      this.firstField,
      this.showPolicy = false,
      this.isDense = false});
  final TextEditingController controller;
  final String hintText;
  final bool isLocked;
  final TextEditingController? firstField;
  final bool showPolicy;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: controller,
          readOnly: isLocked,
          validator: (current) {
            if (current == null) {
              return "Cannot be empty";
            } else if (firstField != null) {
              return current == firstField!.text
                  ? null
                  : "Passwords do not match";
            }
            String prompt = "";
            if (!current.contains(RegExp(r'[A-Z]'))) {
              prompt += "uppercase, ";
            }
            if (!current.contains(RegExp(r'[a-z]'))) {
              prompt += "lowercase, ";
            }
            if (!current.contains(RegExp(r'[0-9]'))) {
              prompt += "digit, ";
            }
            if (!current.contains(RegExp(r'[!@#\$&%.*]'))) {
              prompt += "special";
            }
            if (prompt != "") {
              return "Missing: $prompt";
            } else if (current.length < 8 || current.length > 20) {
              return "Has to be 8-20 characters";
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          obscureText: true,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              helperText: showPolicy
                  ? "8-20 characters: A-Z, a-z, 0-9, (!@#\$&%.*)"
                  : null,
              helperMaxLines: 6,
              hintText: hintText,
              isDense: isDense),
        ));
  }
}

class BirthdayField extends StatelessWidget {
  const BirthdayField(
      {super.key,
      required this.controller,
      this.hintText = "Birthday",
      this.isLocked = false,
      this.isDense = false});
  final TextEditingController controller;
  final String hintText;
  final bool isLocked;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
            validator: (String? current) {
              return isDate(current!) ? null : "Not a valid date!";
            },
            controller: controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.cake),
                hintText: hintText,
                isDense: isDense),
            readOnly: true,
            onTap: () async {
              if (!isLocked) {
                DateTime? picked = await showDatePicker(
                    helpText: "Select your birthday",
                    initialDatePickerMode: DatePickerMode.year,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now()
                        .subtract(const Duration(days: 365 * 13)));
                if (picked != null) {
                  controller.text = picked.toString().split(' ').first;
                }
              }
            }));
  }
}

class CategoryPick extends StatefulWidget {
  const CategoryPick({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<CategoryPick> createState() => _CategoryPickState();
}

class _CategoryPickState extends State<CategoryPick> {
  TextEditingController search = TextEditingController();

  void onPressed() {
    showDialog(
            context: context,
            builder: (context) => CategoryDialog(controller: widget.controller))
        .then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: widget.controller.text == ""
            ? TextButton(
                onPressed: onPressed, child: const Text("Choose category"))
            : TextButton.icon(
                icon: Icon(EventsData.eventIcons[widget.controller.text]),
                onPressed: onPressed,
                label: Text(widget.controller.text)));
  }
}

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> content = EventsData.eventIcons.entries
        .where((element) =>
            element.key.toLowerCase().contains(search.text.toLowerCase()))
        .map((entry) {
      return ActionChip(
        label: Text(entry.key),
        avatar: Icon(entry.value),
        onPressed: () {
          setState(() {
            widget.controller.text = entry.key;
          });
          Navigator.pop(context);
        },
      );
    }).toList();

    return Dialog(
        clipBehavior: Clip.hardEdge,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: SearchBar(
                  hintText: "Search categories...",
                  controller: search,
                  onChanged: (text) => setState(() {
                        search.text = text;
                      })),
            ),
            Flexible(
              child: AnimatedSize(
                duration: Durations.short4,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  clipBehavior: Clip.antiAlias,
                  child: Wrap(
                      spacing: 10,
                      alignment: WrapAlignment.spaceEvenly,
                      children: content),
                ),
              ),
            )
          ],
        ));
  }
}

class NumberField extends StatelessWidget {
  const NumberField(
      {super.key,
      required this.controller,
      this.hintText,
      this.isLocked = false,
      this.suffix,
      this.icon,
      this.isDense = false});
  final TextEditingController controller;
  final String? hintText;
  final bool isLocked;
  final String? suffix;
  final IconData? icon;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        readOnly: isLocked,
        validator: (String? current) {
          return isInt(current!) || current == ""
              ? null
              : "Not a valid number!";
        },
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            suffixText: suffix,
            isDense: isDense),
      ),
    );
  }
}

class MapInput extends StatefulWidget {
  const MapInput({super.key, this.submit});
  final Function? submit;

  @override
  State<MapInput> createState() => _MapInputState();
}

class _MapInputState extends State<MapInput> with TickerProviderStateMixin {
  LatLng pointer = const LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    AnimatedMapController animatedController =
        AnimatedMapController(vsync: this);
    return FlutterMap(
        mapController: animatedController.mapController,
        options: const MapOptions(
            keepAlive: true,
            initialCenter: LatLng(38.1858, 15.5561),
            initialZoom: 16),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'eventManager.app',
          ),
          MarkerLayer(rotate: true, markers: [
            Marker(
                alignment: const Alignment(-0.7, -2),
                point: pointer,
                child: IconButton(
                    iconSize: 50,
                    padding: const EdgeInsetsDirectional.all(0),
                    icon: Icon(
                      Icons.place,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => ()))
          ]),
          Builder(builder: (context) {
            return Center(
                child: IconButton(
                    icon: const Icon(
                      Icons.filter_center_focus,
                      color: Colors.black,
                    ),
                    onPressed: () => setState(() {
                          pointer = MapController.of(context).camera.center;
                          widget.submit == null
                              ? null
                              : widget.submit!(pointer);
                        })));
          }),
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => animatedController.animatedRotateReset(),
                icon: const Icon(Icons.navigation_rounded),
                color: Theme.of(context).primaryColor,
              )),
        ]);
  }
}

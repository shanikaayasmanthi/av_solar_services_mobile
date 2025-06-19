import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/colors.dart';

class TechnicianFormWidget extends StatefulWidget {
  const TechnicianFormWidget({super.key,required this.serviceId});

  final int serviceId;
  @override
  State<TechnicianFormWidget> createState() => _TechnicianFormWidgetState();
}

class _TechnicianFormWidgetState extends State<TechnicianFormWidget> {
  final TextEditingController _name = TextEditingController();
  List<String> technicians = [];

  void _saveTechniciansLive() {
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';

    // Read existing data or initialize a map
    Map<String, dynamic> existingData = jsonDecode(box.read(serviceKey)) ?? {};

    existingData['technicians'] = technicians;

    box.write(serviceKey, jsonEncode(existingData));
  }


  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';

    final rawData = box.read(serviceKey);

    // Check if null first
    if (rawData != null) {
      final serviceData = jsonDecode(rawData);

      if (serviceData != null && serviceData['technicians'] != null) {
        technicians = List<String>.from(serviceData['technicians']);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Technicians",
          style: TextStyle(
            color: textBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 45,
                child: TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: "technician name",
                    hintStyle: const TextStyle(color: textGrey),
                    fillColor: bgGrey,
                    filled: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                flex: 2,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgBlue,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      final technicianName = _name.text.trim();
                      if (technicianName.isNotEmpty) {
                        setState(() {
                          technicians.add(technicianName);
                          _name.clear();
                          _saveTechniciansLive();
                          debugPrint(technicians.toString());
                        });
                      }
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(color: textWhite),
                    )))
          ],
        ),
        technicians.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: technicians.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tech = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: textGrey, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tech,
                            style:
                                const TextStyle(fontSize: 16, color: textBlack),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove, color: textRed),
                          onPressed: () {
                            setState(() {
                              technicians.removeAt(index);
                            });
                            _saveTechniciansLive();
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

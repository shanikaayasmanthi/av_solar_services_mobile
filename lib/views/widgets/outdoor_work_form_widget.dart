import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/colors.dart';

class OutdoorWorkFormWidget extends StatefulWidget {
  const OutdoorWorkFormWidget({
    super.key,
    required this.serviceId
  });

  final int serviceId;

  @override
  State<OutdoorWorkFormWidget> createState() => _OutdoorWorkFormWidgetState();
}

class _OutdoorWorkFormWidgetState extends State<OutdoorWorkFormWidget> {

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';
    final rawData = box.read(serviceKey);

    // Check if null first
    if (rawData != null) {
      final serviceData = jsonDecode(rawData);

      if (serviceData != null && serviceData['outdoor_work'] != null) {
        final data = serviceData['outdoor_work'];

        _cebExportController.text = data["cebExport"]["value"].toString();
        _cebExportCommentController.text = data["cebExport"]["comment"];
        _cebImportController.text = data["cebImport"]["value"].toString();
        _cebImportCommentController.text = data["cebImport"]["comment"];
        _groundResistanceController.text =
            data["groundResistance"]["value"].toString();
        _groundResistanceCommentController.text =
        data["groundResistance"]["comment"];
        earthRod = data["earthRod"]["checked"];
        _earthRodController.text = data["earthRod"]["comment"];
      }
    }
  }


  final TextEditingController _cebExportController = TextEditingController();
  final TextEditingController _cebExportCommentController = TextEditingController();
  final TextEditingController _cebImportController = TextEditingController();
  final TextEditingController _cebImportCommentController = TextEditingController();
  final TextEditingController _groundResistanceController = TextEditingController();
  final TextEditingController _groundResistanceCommentController = TextEditingController();
  bool? earthRod = false;
  final TextEditingController _earthRodController = TextEditingController();

  void _saveOutdoorWorkLive() {
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';

    // Read existing data
    Map<String, dynamic> existingData = jsonDecode(box.read(serviceKey)) ?? {};

    existingData['outdoor_work'] = {
      "cebExport": {
        "value": _cebExportController.text,
        "comment": _cebExportCommentController.text
      },
      "cebImport": {
        "value": _cebImportController.text,
        "comment": _cebImportCommentController.text
      },
      "groundResistance": {
        "value": _groundResistanceController.text,
        "comment": _groundResistanceCommentController.text
      },
      "earthRod": {
        "checked": earthRod ?? false,
        "comment": _earthRodController.text
      }
    };

    box.write(serviceKey, jsonEncode(existingData));
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Outdoor Work Activities",
          style: TextStyle(
            color: textBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),) ,
        const SizedBox(height: 10,),
        //CEB Export data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("ECB Export Reading",
              style: TextStyle(
                  color: textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 3,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _cebExportController,
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          _saveOutdoorWorkLive();
                        } ,
                        decoration: InputDecoration(
                          hintText: "CEB Import",
                          hintStyle: const TextStyle(color: textGrey),
                          fillColor: bgGrey,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                ),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _cebExportCommentController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveOutdoorWorkLive();
                        } ,
                        decoration: InputDecoration(
                          hintText: "comments",
                          hintStyle: const TextStyle(color: textGrey),
                          fillColor: bgGrey,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10,),
        //CEB Import data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("CEB Import Reading",
              style: TextStyle(
                  color: textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child:
                  TextFormField(
                    controller: _cebImportController,
                    keyboardType: TextInputType.number,
                    onChanged: (value){
                      _saveOutdoorWorkLive();
                    } ,
                    decoration: InputDecoration(
                      hintText: "CEB Export",
                      hintStyle: const TextStyle(color: textGrey),
                      fillColor: bgGrey,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _cebImportCommentController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveOutdoorWorkLive();
                        } ,
                        decoration: InputDecoration(
                          hintText: "comments",
                          hintStyle: const TextStyle(color: textGrey),
                          fillColor: bgGrey,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10,),
        //Ground Resistance data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ground Resistance",
              style: TextStyle(
                  color: textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child:
                  TextFormField(
                    controller: _groundResistanceController,
                    keyboardType: TextInputType.number,
                    onChanged: (value){
                      _saveOutdoorWorkLive();
                    } ,
                    decoration: InputDecoration(
                      hintText: "resistance",
                      hintStyle: const TextStyle(color: textGrey),
                      fillColor: bgGrey,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _groundResistanceCommentController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveOutdoorWorkLive();
                        } ,
                        decoration: InputDecoration(
                          hintText: "comments",
                          hintStyle: const TextStyle(color: textGrey),
                          fillColor: bgGrey,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10,),
        //Earth Rod data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Earthing Rod Connection Checked",
              style: TextStyle(
                  color: textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child:
                  Checkbox(
                    tristate: true, // Example with tristate
                    value: earthRod,
                    onChanged: (bool? newValue) {
                      setState(() {
                        earthRod = newValue;
                        _saveOutdoorWorkLive();
                      });
                    },
                  ),),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _earthRodController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveOutdoorWorkLive();
                        } ,
                        decoration: InputDecoration(
                          hintText: "comments",
                          hintStyle: const TextStyle(color: textGrey),
                          fillColor: bgGrey,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

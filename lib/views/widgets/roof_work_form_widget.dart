import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/colors.dart';

class RoofWorkFormWidget extends StatefulWidget {
  const RoofWorkFormWidget({
    super.key,
    required this.serviceId,
  });

  final int serviceId;

  @override
  State<RoofWorkFormWidget> createState() => _RoofWorkFormWidgetState();
}

class _RoofWorkFormWidgetState extends State<RoofWorkFormWidget> {

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    //load the roof work data
    final serviceKey = 'service_${widget.serviceId}';
    final rawData = box.read(serviceKey);

    // Check if null first
    if (rawData != null) {
      final serviceData = jsonDecode(rawData);

      if (serviceData != null && serviceData['roof_work'] != null) {
        final data = serviceData['roof_work'];

        //set roof data if exist
        _cloudinessController.text = data["cloudiness"]["value"].toString();
        _cloudinessCommentController.text = data["cloudiness"]["comment"];
        panelService = data["panelService"]["checked"];
        _panelServiceController.text = data["panelService"]["comment"];
        structureService = data["structureService"]["checked"];
        _structureServiceController.text = data["structureService"]["comment"];
        nutnbolts = data["nutsBolts"]["checked"];
        _nutnboltsController.text = data["nutsBolts"]["comment"];
        shadow = data["shadow"]["checked"];
        _shadowController.text = data["shadow"]["comment"];
        panelmp4 = data["panelMp4"]["checked"];
        _panelmp4Controller.text = data["panelMp4"]["comment"];
        photos = data["photos"]["checked"];
        _photosController.text = data["photos"]["comment"];

        setState(() {});
      }
    }
  }


  final TextEditingController _cloudinessController = TextEditingController();
  final TextEditingController _cloudinessCommentController = TextEditingController();
  bool? panelService = false;
  final TextEditingController _panelServiceController = TextEditingController();
  bool? structureService = false;
  final TextEditingController _structureServiceController = TextEditingController();
  bool? nutnbolts = false;
  final TextEditingController _nutnboltsController = TextEditingController();
  bool? shadow = false;
  final TextEditingController _shadowController = TextEditingController();
  bool? panelmp4 = false;
  final TextEditingController _panelmp4Controller = TextEditingController();
  bool? photos = false;
  final TextEditingController _photosController = TextEditingController();

  void _saveRoofDataLive() {//save data to get storage for more flexibility
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';

    // Load existing service data if available
    Map<String, dynamic> existingData = jsonDecode(box.read(serviceKey)) ?? {};

    // Update the roof work section
    existingData['roof_work'] = {
      "cloudiness": {
        "value": int.tryParse(_cloudinessController.text) ?? 0,
        "comment": _cloudinessCommentController.text
      },
      "panelService": {
        "checked": panelService ?? false,
        "comment": _panelServiceController.text
      },
      "structureService": {
        "checked": structureService ?? false,
        "comment": _structureServiceController.text
      },
      "nutsBolts": {
        "checked": nutnbolts ?? false,
        "comment": _nutnboltsController.text
      },
      "shadow": {
        "checked": shadow ?? false,
        "comment": _shadowController.text
      },
      "panelMp4": {
        "checked": panelmp4 ?? false,
        "comment": _panelmp4Controller.text
      },
      "photos": {
        "checked": photos ?? false,
        "comment": _photosController.text
      }
    };

    // Save the full service structure back to storage
    box.write(serviceKey, jsonEncode(existingData));
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text("Roof Work Activities",
         style: TextStyle(
         color: textBlack,
         fontSize: 18,
         fontWeight: FontWeight.bold,
       ),) ,
        const SizedBox(height: 10,),
        //cloudiness data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Cloudiness",
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
                    child: TextFormField(
                      controller: _cloudinessController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required*";
                        }else if(int.tryParse(value)!<0||int.tryParse(value)!>10){
                          return "Invalid Reading";
                        }else{
                        return null;}
                      },
                      onChanged: (value){
                        _saveRoofDataLive();
                      } ,
                      decoration: InputDecoration(
                        hintText: "(0-10)",
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
                  ),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                      child: TextFormField(
                        controller: _cloudinessCommentController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveRoofDataLive();
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
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10,),
        //panel service data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Panel Service",
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
                  value: panelService,
                  onChanged: (bool? newValue) {
                    setState(() {
                      panelService = newValue;
                      _saveRoofDataLive();
                    });
                  },
                ),),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                      child: TextFormField(
                        controller: _panelServiceController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveRoofDataLive();
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
                    ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10,),
        //Structure service data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Structure Service",
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
                    value: structureService,
                    onChanged: (bool? newValue) {
                      setState(() {
                        structureService = newValue;
                        _saveRoofDataLive();
                      });
                    },
                  ),),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _structureServiceController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveRoofDataLive();
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
        //Nut and bolt data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Condition of Tightness of nut & bolts ",
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
                    value: nutnbolts,
                    onChanged: (bool? newValue) {
                      setState(() {
                        nutnbolts = newValue;
                        _saveRoofDataLive();
                      });
                    },
                  ),),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _nutnboltsController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveRoofDataLive();
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
        //shadow data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Shadow",
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
                    value: shadow,
                    onChanged: (bool? newValue) {
                      setState(() {
                        shadow = newValue;
                        _saveRoofDataLive();
                      });
                    },
                  ),),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _shadowController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveRoofDataLive();
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
        //panel MP4 Condition data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Panel MP4 Condition",
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
                    value: panelmp4,
                    onChanged: (bool? newValue) {
                      setState(() {
                        panelmp4 = newValue;
                        _saveRoofDataLive();
                      });
                    },
                  ),),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _panelmp4Controller,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveRoofDataLive();
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
        //photos data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Took photos",
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
                    value: photos,
                    onChanged: (bool? newValue) {
                      setState(() {
                        photos = newValue;
                        _saveRoofDataLive();
                      });
                    },
                  ),),
                const SizedBox(width: 15,),
                Expanded(
                    flex: 5,
                    child:  SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _photosController,
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _saveRoofDataLive();
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
        )
      ],
    );
  }
}

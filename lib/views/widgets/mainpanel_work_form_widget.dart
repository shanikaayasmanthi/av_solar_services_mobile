import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/colors.dart';

class MainpanelWorkFormWidget extends StatefulWidget {
  const MainpanelWorkFormWidget({super.key, required this.serviceId});

  final int serviceId;
  @override
  State<MainpanelWorkFormWidget> createState() =>
      _MainpanelWorkFormWidgetState();
}

class _MainpanelWorkFormWidgetState extends State<MainpanelWorkFormWidget> {
  @override
  void initState() {
    super.initState();
      _loadMainPanelData();
}

void _loadMainPanelData() async {
  final box = GetStorage();
  final serviceKey = 'service_${widget.serviceId}';
  
  // Add delay to ensure data is saved
  await Future.delayed(const Duration(milliseconds: 100));

  debugPrint('Loading main panel data for key: $serviceKey');
  final rawData = box.read(serviceKey);
  debugPrint('Raw storage data for main panel: $rawData');
 
  // Check if null first
  if (rawData != null) {
    try {
      final serviceData = jsonDecode(rawData);
      debugPrint('Main panel data from storage: ${serviceData['main_panel_work']}');

      if (serviceData['main_panel_work'] != null) {
        final data = serviceData['main_panel_work'];
        debugPrint('Complete main panel data: $data');

        // Debug print the entire structure
        debugPrint('Main Panel Work Data Structure:');
        data.forEach((key, value) {
          debugPrint('$key: ${value.toString()} (${value.runtimeType})');
          if (value is Map) {
            value.forEach((subKey, subValue) {
              debugPrint('  $subKey: $subValue (${subValue.runtimeType})');
            });
          }
        });

        _offlineGridVoltage.text = data['offlineGridVoltage']?['value']?.toString() ?? '';
        _offlineGridVoltageComment.text = data['offlineGridVoltage']?['comment']?.toString() ?? '';

        _onlineGridVoltage.text = data['onlineGridVoltage']?['value']?.toString() ?? '';
        _onlineGridVoltageComment.text = data['onlineGridVoltage']?['comment']?.toString() ?? '';

        invertorService = (data['invertorServiceFanTime']?['checked'] is int)
            ? (data['invertorServiceFanTime']?['checked'] == 1)
            : (data['invertorServiceFanTime']?['checked'] ?? false);
        _invertorServiceComment.text = data['invertorServiceFanTime']?['comment']?.toString() ?? '';

        breaker = (data['breakerService']?['checked'] is int)
            ? (data['breakerService']?['checked'] == 1)
            : (data['breakerService']?['checked'] ?? false);
        _breakerComment.text = data['breakerService']?['comment']?.toString() ?? '';

        dcSurgeArrestor = (data['dcSurgeArrestors']?['checked'] is int)
            ? (data['dcSurgeArrestors']?['checked'] == 1)
            : (data['dcSurgeArrestors']?['checked'] ?? false);
        _dcSurgeArrestorComment.text = data['dcSurgeArrestors']?['comment']?.toString() ?? '';

        acSurgeArrestor = (data['acSurgeArrestors']?['checked'] is int)
            ? (data['acSurgeArrestors']?['checked'] == 1)
            : (data['acSurgeArrestors']?['checked'] ?? false);
        _acSurgeArrestorComment.text = data['acSurgeArrestors']?['comment']?.toString() ?? '';

        debugPrint('invertorConnection: ${data['invertorConnection']}');
        invertorConnection = (data['invertorConnection']?['checked'] is int)
            ? (data['invertorConnection']?['checked'] == 1)
            : (data['invertorConnection']?['checked'] ?? false);
        _invertorConnectionComment.text = data['invertorConnection']?['comment']?.toString() ?? '';

        _lowVoltage.text = data['lowVoltageRange']?['value']?.toString() ?? '';
        _lowVoltageComment.text = data['lowVoltageRange']?['comment']?.toString() ?? '';

        _highVoltage.text = data['highVoltageRange']?['value']?.toString() ?? '';
        _highVoltageComment.text = data['highVoltageRange']?['comment']?.toString() ?? '';

        _lowFrequency.text = data['lowFrequencyRange']?['value']?.toString() ?? '';
        _lowFrequencyComment.text = data['lowFrequencyRange']?['comment']?.toString() ?? '';

        _highFrequency.text = data['highFrequencyRange']?['value']?.toString() ?? '';
        _highFrequencyComment.text = data['highFrequencyRange']?['comment']?.toString() ?? '';

        _invertorSetupTime.text = data['invertorSetupTime']?['value']?.toString() ?? '';
        _invertorSetupTimeComment.text = data['invertorSetupTime']?['comment']?.toString() ?? '';

        _eTodayInvertor.text = data['eTodayInvertor']?['value']?.toString() ?? '';
        _eTodayInvertorComment.text = data['eTodayInvertor']?['comment']?.toString() ?? '';

        _eTotalInvertor.text = data['eTotalInvertor']?['value']?.toString() ?? '';
        _eTotalInvertorComment.text = data['eTotalInvertor']?['comment']?.toString() ?? '';

        wifiConfig = (data['wifiConfig']?['checked'] is int)
            ? (data['wifiConfig']?['checked'] == 1)
            : (data['wifiConfig']?['checked'] ?? false);
        _wifiConfigComment.text = data['wifiConfig']?['comment']?.toString() ?? '';

        powerBulb = data['powerBulbBlinkingStyle']?['value']?.toString() ?? '';
        _powerBulbComment.text = data['powerBulbBlinkingStyle']?['comment']?.toString() ?? '';

        _wifiUsername.text = data['routerUsername']?['value']?.toString() ?? '';
        _wifiUsernameComment.text = data['routerUsername']?['comment']?.toString() ?? '';

        _wifiPassword.text = data['routerPassword']?['value']?.toString() ?? '';
        _wifiPasswordComment.text = data['routerPassword']?['comment']?.toString() ?? '';

        _routerSerialNo.text = data['routerSerialNo']?['value']?.toString() ?? '';
        _routerSerialNoComment.text = data['routerSerialNo']?['comment']?.toString() ?? '';

        avSticker = (data['serviceAVSticker']?['checked'] is int)
            ? (data['serviceAVSticker']?['checked'] == 1)
            : (data['serviceAVSticker']?['checked'] ?? false);
        _avStickerComment.text = data['serviceAVSticker']?['comment']?.toString() ?? '';

        tookPhotos = (data['tookPhotos']?['checked'] is int)
            ? (data['tookPhotos']?['checked'] == 1)
            : (data['tookPhotos']?['checked'] ?? false);
        _tookPhotosComment.text = data['tookPhotos']?['comment']?.toString() ?? '';
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading main panel data: $e');
    }
  } else {
    debugPrint('No data found in storage for key: $serviceKey');
  }
}

  final TextEditingController _offlineGridVoltage = TextEditingController();
  final TextEditingController _offlineGridVoltageComment =
      TextEditingController();
  final TextEditingController _onlineGridVoltage = TextEditingController();
  final TextEditingController _onlineGridVoltageComment =
      TextEditingController();
  final TextEditingController _invertorServiceComment = TextEditingController();
  bool? invertorService = false;
  final TextEditingController _breakerComment = TextEditingController();
  bool? breaker = false;
  final TextEditingController _dcSurgeArrestorComment = TextEditingController();
  bool? dcSurgeArrestor = false;
  final TextEditingController _acSurgeArrestorComment = TextEditingController();
  bool? acSurgeArrestor = false;
  final TextEditingController _invertorConnectionComment =
      TextEditingController();
  bool? invertorConnection = false;
  final TextEditingController _lowVoltage = TextEditingController();
  final TextEditingController _lowVoltageComment = TextEditingController();
  final TextEditingController _highVoltage = TextEditingController();
  final TextEditingController _highVoltageComment = TextEditingController();
  final TextEditingController _lowFrequency = TextEditingController();
  final TextEditingController _lowFrequencyComment = TextEditingController();
  final TextEditingController _highFrequency = TextEditingController();
  final TextEditingController _highFrequencyComment = TextEditingController();
  final TextEditingController _invertorSetupTime = TextEditingController();
  final TextEditingController _invertorSetupTimeComment =
      TextEditingController();
  final TextEditingController _eTodayInvertor = TextEditingController();
  final TextEditingController _eTodayInvertorComment = TextEditingController();
  final TextEditingController _eTotalInvertor = TextEditingController();
  final TextEditingController _eTotalInvertorComment = TextEditingController();
  final TextEditingController _wifiConfigComment = TextEditingController();
  bool? wifiConfig = false;
  String? powerBulb;
  final TextEditingController _powerBulbComment = TextEditingController();
  final TextEditingController _wifiUsername = TextEditingController();
  final TextEditingController _wifiUsernameComment = TextEditingController();
  final TextEditingController _wifiPassword = TextEditingController();
  final TextEditingController _wifiPasswordComment = TextEditingController();
  final TextEditingController _routerSerialNo = TextEditingController();
  final TextEditingController _routerSerialNoComment = TextEditingController();
  final TextEditingController _avStickerComment = TextEditingController();
  bool? avSticker = false;
  final TextEditingController _tookPhotosComment = TextEditingController();
  bool? tookPhotos = false;

  void _saveMainPanelWorkLive() {
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';

    Map<String, dynamic> existingData = jsonDecode(box.read(serviceKey));

    existingData['main_panel_work'] = {
      "offlineGridVoltage": {
        "value": _offlineGridVoltage.text,
        "comment": _offlineGridVoltageComment.text
      },
      "onlineGridVoltage": {
        "value": _onlineGridVoltage.text,
        "comment": _onlineGridVoltageComment.text
      },
      "invertorServiceFanTime": {
        "checked": invertorService ?? false,
        "comment": _invertorServiceComment.text
      },
      "breakerService": {
        "checked": breaker ?? false,
        "comment": _breakerComment.text
      },
      "dcSurgeArrestors": {
        "checked": dcSurgeArrestor ?? false,
        "comment": _dcSurgeArrestorComment.text
      },
      "acSurgeArrestors": {
        "checked": acSurgeArrestor ?? false,
        "comment": _acSurgeArrestorComment.text
      },
      "invertorConnection": {
        "checked": invertorConnection ?? false,
        "comment": _invertorConnectionComment.text
      },
      "lowVoltageRange": {
        "value": _lowVoltage.text,
        "comment": _lowVoltageComment.text
      },
      "highVoltageRange": {
        "value": _highVoltage.text,
        "comment": _highVoltageComment.text
      },
      "lowFrequencyRange": {
        "value": _lowFrequency.text,
        "comment": _lowFrequencyComment.text
      },
      "highFrequencyRange": {
        "value": _highFrequency.text,
        "comment": _highFrequencyComment.text
      },
      "invertorSetupTime": {
        "value": _invertorSetupTime.text,
        "comment": _invertorSetupTimeComment.text
      },
      "eTodayInvertor": {
        "value": _eTodayInvertor.text,
        "comment": _eTodayInvertorComment.text
      },
      "eTotalInvertor": {
        "value": _eTotalInvertor.text,
        "comment": _eTotalInvertorComment.text
      },
      "wifiConfig": {
        "checked": wifiConfig ?? false,
        "comment": _wifiConfigComment.text
      },
      "powerBulbBlinkingStyle": {
        "value": powerBulb.toString(),
        "comment": _powerBulbComment.text,
      },
      "routerUsername": {
        "value": _wifiUsername.text,
        "comment": _wifiUsernameComment.text
      },
      "routerPassword": {
        "value": _wifiPassword.text,
        "comment": _wifiPasswordComment.text
      },
      "routerSerialNo": {
        "value": _routerSerialNo.text,
        "comment": _routerSerialNoComment.text
      },
      "serviceAVSticker": {
        "checked": avSticker ?? false,
        "comment": _avStickerComment.text
      },
      "tookPhotos": {
        "checked": tookPhotos ?? false,
        "comment": _tookPhotosComment.text
      }
    };
    box.write(serviceKey, jsonEncode(existingData));
  }

  @override
  Widget build(BuildContext context) {
      final box = GetStorage();
  final allKeys = box.getKeys();
  debugPrint('All storage keys: $allKeys');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Main Panel Activities",
          style: TextStyle(
            color: textBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        //offline grid voltage
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Offline Grid Voltage",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _offlineGridVoltage,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
                        decoration: InputDecoration(
                          hintText: "voltage",
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
                    )),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _offlineGridVoltageComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //online grid voltage
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Online Grid Voltage",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _onlineGridVoltage,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "voltage",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _onlineGridVoltageComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //inverter service fan time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Inverter Service/Fan/Time",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Checkbox(
                    tristate: true, // Example with tristate
                    value: invertorService ?? false,
                    onChanged: (bool? newValue) {
                      setState(() {
                        invertorService = newValue ?? false;
                      });
                      _saveMainPanelWorkLive();
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _invertorServiceComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //breaker service
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Breaker Service",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Checkbox(
                    tristate: true, // Example with tristate
                    value: breaker ?? false,
                    onChanged: (bool? newValue) {
                      setState(() {
                        breaker = newValue ?? false;
                      });
                      _saveMainPanelWorkLive();
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _breakerComment,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //dc surge arrestors
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DC Surge Arrestors",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Checkbox(
                    tristate: true, // Example with tristate
                    value: dcSurgeArrestor ?? false,
                    onChanged: (bool? newValue) {
                      setState(() {
                        dcSurgeArrestor = newValue ?? false;
                      });
                      _saveMainPanelWorkLive();
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _dcSurgeArrestorComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //ac surge arrestors
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AC Surge Arrestors",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Checkbox(
                    tristate: true, // Example with tristate
                    value: acSurgeArrestor ?? false,
                    onChanged: (bool? newValue) {
                      setState(() {
                        acSurgeArrestor = newValue ?? false;
                      });
                      _saveMainPanelWorkLive();
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _acSurgeArrestorComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Inverter Connection MC4 condition
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Inverter Connection(MC4) condition",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Checkbox(
                    tristate: true, // Example with tristate
                    value: invertorConnection ?? false,
                    onChanged: (bool? newValue) {
                      setState(() {
                        invertorConnection = newValue ?? false;
                      });
                      _saveMainPanelWorkLive();
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _invertorConnectionComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Low Voltage Range
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Low Voltage Range",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _lowVoltage,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "voltage range",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _lowVoltageComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //High Voltage Range
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "High Voltage Range",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _highVoltage,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "voltage range",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _highVoltageComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Low Frequency Range
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Low Frequency Range",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _lowFrequency,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "frequency range",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _lowFrequencyComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //High Frequency Range
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "High Frequency Range",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _highFrequency,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "frequency range",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _highFrequencyComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Inverter Setup time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Inverter Setup Time",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _invertorSetupTime,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "setup time",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _invertorSetupTimeComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //E Today Inverter
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "E Today Inverter",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _eTodayInvertor,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "E-Today Inverter",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _eTodayInvertorComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //E Total Inverter
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "E Total Inverter",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _eTotalInvertor,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "E-Total Inverter",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _eTotalInvertorComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Wifi Config
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Wifi Config. Done?",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Checkbox(
                    tristate: true, // Example with tristate
                    value: wifiConfig ?? false,
                    onChanged: (bool? newValue) {
                      setState(() {
                        wifiConfig = newValue ?? false;
                      });
                      _saveMainPanelWorkLive();
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _wifiConfigComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Power bulb blinking style
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Power Bulb Blinking Style",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 45,
                      child: DropdownButton<String>(
  value: (powerBulb != null && powerBulb!.isNotEmpty) ? powerBulb : null,
  hint: const Text("Select"),
  underline: null,
  items: <String>['Slow', 'Solid', 'Fast'].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList(),
  onChanged: (String? value) {
    setState(() {
      powerBulb = value ?? '';
    });
    _saveMainPanelWorkLive();
  },
),
                    )),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _powerBulbComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Router Username
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Router Username",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _wifiUsername,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "username",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _wifiUsernameComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Router Password
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Router Password",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _wifiPassword,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "password",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _wifiPasswordComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Router Serial Number
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Router Serial Number",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _routerSerialNo,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _saveMainPanelWorkLive();
                    },
                    decoration: InputDecoration(
                      hintText: "serial No:",
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
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _routerSerialNoComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Av Sticker
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Service / Alta Vision Sticker",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Checkbox(
                    tristate: true, // Example with tristate
                    value: avSticker ?? false,
                    onChanged: (bool? newValue) {
                      setState(() {
                        avSticker = newValue ?? false;
                      });
                      _saveMainPanelWorkLive();
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _avStickerComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //Took Photos
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Took Photos of Main Panel Board",
              style: TextStyle(
                  color: textBlack, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Checkbox(
                    tristate: true, // Example with tristate
                    value: tookPhotos ?? false,
                    onChanged: (bool? newValue) {
                      setState(() {
                        tookPhotos = newValue ?? false;
                      });
                      _saveMainPanelWorkLive();
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _tookPhotosComment,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          _saveMainPanelWorkLive();
                        },
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
                    )),
              ],
            )
          ],
        ),
      ],
    );
  }
}
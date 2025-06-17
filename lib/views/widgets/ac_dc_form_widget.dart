import 'package:av_solar_services/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AcDcFormWidget extends StatefulWidget {
  const AcDcFormWidget({
    super.key,
    required this.serviceId,
  });

  final int serviceId;
  @override
  State<AcDcFormWidget> createState() => _AcDcFormWidgetState();
}

class _AcDcFormWidgetState extends State<AcDcFormWidget> {

  void _loadACDC(){
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';
    final data = box.read(serviceKey);

    if (data != null) {
      final dc = data['dc'] ?? {};
      final ac = data['ac'] ?? {};

      void _populate(List<TextEditingController> controllers, List<dynamic>? values) {
        for (int i = 0; i < controllers.length && values != null && i < values.length; i++) {
          controllers[i].text = values[i] ?? '';
        }
      }

      _populate(_dcOCVoltageControllers, dc['OCVoltage']);
      _populate(_dcLoadVoltageControllers, dc['LoadVoltage']);
      _populate(_dcLoadCurrentControllers, dc['LoadCurrent']);

      _populate(_acOCVoltageControllers, ac['OCVoltage']);
      _populate(_acLoadVoltageControllers, ac['LoadVoltage']);
      _populate(_acLoadCurrentControllers, ac['LoadCurrent']);
    }
  }

  void _loadMainData() {
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';
    final data = box.read(serviceKey);

    if (data != null && data['mainData'] != null) {
      final mainData = data['mainData'];
      _longitudeController.text = mainData['longitude'] ?? '';
      _latitudeController.text = mainData['latitude'] ?? '';
      _powerController.text = mainData['power'] ?? '';
      _timeController.text = mainData['time'] ?? '';
      wifiConnectivity = mainData['wifiConnectivity'];
      electricitybill = mainData['electricityBill'];
      setState(() {}); // Update UI if using checkbox state
    }
  }


  @override
  void initState() {
    super.initState();
    _acLoadCurrentControllers = List.generate(
      _acLoadCurrentLabels.length,
      (_) => TextEditingController(),
    );
    _acLoadVoltageControllers = List.generate(
      _acVoltageLabels.length,
      (_) => TextEditingController(),
    );
    _acOCVoltageControllers = List.generate(
      _acVoltageLabels.length,
      (_) => TextEditingController(),
    );
    _loadACDC();
    _loadMainData();
  }


  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<String> _acVoltageLabels = [
    "L1-N",
    "L2-N",
    "L3-N",
    "L1-L2",
    "L1-L3",
    "L2-L3",
    "N-E",
  ];
  final List<String> _acLoadCurrentLabels = [
    "L1-N",
    "L2-N",
    "L3-N",
  ];

  late final List<TextEditingController> _acOCVoltageControllers;
  late final List<TextEditingController> _acLoadVoltageControllers;
  late final List<TextEditingController> _acLoadCurrentControllers;
  final List<TextEditingController> _dcOCVoltageControllers =
      List.generate(8, (_) => TextEditingController());
  final List<TextEditingController> _dcLoadVoltageControllers =
      List.generate(8, (_) => TextEditingController());
  final List<TextEditingController> _dcLoadCurrentControllers =
      List.generate(8, (_) => TextEditingController());
  bool? wifiConnectivity = false;
  bool? electricitybill = false;

  void _saveMainDataLive() {
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';

    Map<String, dynamic> existingData = box.read(serviceKey) ?? {};

    existingData['mainData'] = {
      "longitude": _longitudeController.text.trim(),
      "latitude": _latitudeController.text.trim(),
      "power": _powerController.text.trim(),
      "time": _timeController.text.trim(),
      "wifiConnectivity": wifiConnectivity,
      "electricityBill": electricitybill,
    };

    box.write(serviceKey, existingData);
    debugPrint("Saved mainData: ${existingData['mainData']}");
  }


  void _saveACDCLive(){
    final box = GetStorage();
    final serviceKey = 'service_${widget.serviceId}';
    final Map<String, dynamic> existingData = box.read(serviceKey) ?? {};

    // Helper to convert list of controllers to string list
    List<String> _extractValues(List<TextEditingController> controllers) {
      return controllers.map((controller) => controller.text.trim()).toList();
    }

    existingData['dc'] = {
      "OCVoltage": _extractValues(_dcOCVoltageControllers),
      "LoadVoltage": _extractValues(_dcLoadVoltageControllers),
      "LoadCurrent": _extractValues(_dcLoadCurrentControllers),
    };

    existingData['ac'] = {
      "OCVoltage": _extractValues(_acOCVoltageControllers),
      "LoadVoltage": _extractValues(_acLoadVoltageControllers),
      "LoadCurrent": _extractValues(_acLoadCurrentControllers),
    };

    box.write(serviceKey, existingData);
    debugPrint("Saved Voltage/Current Data: ${box.read(serviceKey)}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(   // Only the title is centered
          child: Text(
            "Service Details",
            style: TextStyle(
              color: textBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),

        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: SizedBox(
              height: 45,
              child: TextField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _saveMainDataLive();
                },
                decoration: InputDecoration(
                  hintText: "Longitude",
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
            )),
            const SizedBox(width: 10),
            Expanded(
                child: SizedBox(
              height: 45,
              child: TextField(
                onChanged: (value){
                  _saveMainDataLive();
                },
                controller: _latitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Latitude",
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
            )),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: SizedBox(
              height: 45,
              child: TextField(
                onChanged: (value){
                  _saveMainDataLive();
                },
                controller: _powerController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Power",
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
            )),
            const SizedBox(width: 10),
            Expanded(
                child: SizedBox(
              height: 45,
              child: TextField(
                onChanged: (value){
                  _saveMainDataLive();
                  },
                controller: _timeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: "Time",
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
            )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  'Wifi Connectivity',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Checkbox(
                  tristate: true, // Example with tristate
                  value: wifiConnectivity,
                  onChanged: (bool? newValue) {
                    setState(() {
                      wifiConnectivity = newValue;
                    });
                    _saveMainDataLive();
                  },
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  'Electricity bill',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Checkbox(
                  tristate: true, // Example with tristate
                  value: electricitybill,
                  onChanged: (bool? newValue) {
                    setState(() {
                      electricitybill = newValue;
                    });
                    _saveMainDataLive();
                  },
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DC (O/C) Voltage",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textBlack,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_dcOCVoltageControllers.length, (index) {
                return SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    onChanged: (value){
                      _saveACDCLive();
                    },
                    controller: _dcOCVoltageControllers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'string ${index + 1}',
                      filled: true,
                      fillColor: bgGrey,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DC (Load Voltage)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textBlack,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  List.generate(_dcLoadVoltageControllers.length, (index) {
                return SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    onChanged: (value){
                      _saveACDCLive();
                    },
                    controller: _dcLoadVoltageControllers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'string ${index + 1}',
                      filled: true,
                      fillColor: bgGrey,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DC (Load Current)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textBlack,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  List.generate(_dcLoadCurrentControllers.length, (index) {
                return SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    onChanged: (value){
                      _saveACDCLive();
                    },
                    controller: _dcLoadCurrentControllers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'string ${index + 1}',
                      filled: true,
                      fillColor: bgGrey,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AC (O/C Voltage)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textBlack,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_acOCVoltageControllers.length, (index) {
                return SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    controller: _acOCVoltageControllers[index],
                    decoration: InputDecoration(
                      hintText: _acVoltageLabels[index],
                      filled: true,
                      fillColor: bgGrey,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AC (Load Voltage)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textBlack,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  List.generate(_acLoadVoltageControllers.length, (index) {
                return SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    onChanged: (value){
                      _saveACDCLive();
                    },
                    controller: _acLoadVoltageControllers[index],
                    decoration: InputDecoration(
                      hintText: _acVoltageLabels[index],
                      filled: true,
                      fillColor: bgGrey,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AC (Load Current)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textBlack,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_acLoadCurrentLabels.length, (index) {
                return SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    onChanged: (value){
                      _saveACDCLive();
                      },
                    controller: _acLoadCurrentControllers[index],
                    decoration: InputDecoration(
                      hintText: _acVoltageLabels[index],
                      filled: true,
                      fillColor: bgGrey,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}

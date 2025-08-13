import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/constants/base_url.dart';
import 'package:av_solar_services/controllers/services.dart';
import 'package:av_solar_services/views/widgets/ac_dc_form_widget.dart';
import 'package:av_solar_services/views/widgets/mainpanel_work_form_widget.dart';
import 'package:av_solar_services/views/widgets/outdoor_work_form_widget.dart';
import 'package:av_solar_services/views/widgets/roof_work_form_widget.dart';
import 'package:av_solar_services/views/widgets/technician_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../controllers/sup_page.dart';
import '../../models/User.dart';
import 'package:http/http.dart' as http;
//import 'package:av_solar_services/views/layouts/service_details_layout.dart';

class ServiceFormToEdit extends StatefulWidget {
  final int currentStep;
  final Function(int) onStepChanged;
  final int serviceId;
  final Map<String, dynamic> serviceData;

  const ServiceFormToEdit({
    super.key,
    required this.serviceId,
    required this.currentStep,
    required this.onStepChanged,
    required this.serviceData,
  });

  @override
  State<ServiceFormToEdit> createState() => _ServiceFormToEditState();
}

class _ServiceFormToEditState extends State<ServiceFormToEdit> {
  final box = GetStorage();
  final _formKeys = List.generate(6, (index) => GlobalKey<FormState>());
  final ServicesController _servicesController = Get.put(ServicesController());
  var formResult;
  Map<String, dynamic> _serviceData = {};
  bool _isSubmitting = false;
  late int _currentStep;

  @override
  void initState() {
    super.initState();
    _serviceData = _initializeServiceData(widget.serviceData);
    _currentStep = widget.currentStep;
    _saveInitialDataToStorage();
    _printDebugData();
  }

  void _printDebugData() {
    try {
      debugPrint('Initialized service data: ${jsonEncode(_serviceData)}');
      debugPrint('Data types:');
      _serviceData.forEach((key, value) {
        debugPrint('$key: ${value.runtimeType}');
        if (value is Map) {
          value.forEach((subKey, subValue) {
            debugPrint('  $subKey: ${subValue.runtimeType}');
          });
        }
      });
    } catch (e) {
      debugPrint('Error printing debug data: $e');
    }
  }

  void _onStepChanged(int step) {
    setState(() {
      _currentStep = step;
    });
    widget.onStepChanged(step);
  }

  Map<String, dynamic> _initializeServiceData(
      Map<String, dynamic> serviceData) {
    debugPrint(
        'Original main_panel_work data: ${serviceData['main_panel_work']}');
    // Ensure all required sections exist with proper structure
    debugPrint('Raw serviceData: ${jsonEncode(serviceData)}');
    Map<String, dynamic> mainPanelWork = {};
    if (serviceData['main_panel_work'] != null &&
        serviceData['main_panel_work'] is Map) {
      final mpData = serviceData['main_panel_work'];

      mainPanelWork = {
        'offlineGridVoltage': {
          'value': mpData['off_grid_valtage']?.toString() ?? '',
          'comment': mpData['off_grid_valtage_comments']?.toString() ?? ''
        },
        'onlineGridVoltage': {
          'value': mpData['on_grid_valtage']?.toString() ?? '',
          'comment': mpData['on_grid_valtage_comments']?.toString() ?? ''
        },
        'invertorServiceFanTime': {
          'checked': mpData['invertor_service_fan_time'] is int
              ? mpData['invertor_service_fan_time'] == 1
              : mpData['invertor_service_fan_time'] ?? false,
          'comment':
              mpData['invertor_service_fan_time_comments']?.toString() ?? ''
        },
        'breakerService': {
          'checked': mpData['breaker_service'] is int
              ? mpData['breaker_service'] == 1
              : mpData['breaker_service'] ?? false,
          'comment': mpData['breaker_service_comments']?.toString() ?? ''
        },
        'dcSurgeArrestors': {
          'checked': mpData['DC_surge_arrestors'] is int
              ? mpData['DC_surge_arrestors'] == 1
              : mpData['DC_surge_arrestors'] ?? false,
          'comment': mpData['DC_surge_arrestors_comments']?.toString() ?? ''
        },
        'acSurgeArrestors': {
          'checked': mpData['AC_surge_arrestors'] is int
              ? mpData['AC_surge_arrestors'] == 1
              : mpData['AC_surge_arrestors'] ?? false,
          'comment': mpData['AC_surge_arrestors_comments']?.toString() ?? ''
        },
        'invertorConnection': {
          'checked': mpData['invertor_connection_MC4_condition'] is int
              ? mpData['invertor_connection_MC4_condition'] == 1
              : mpData['invertor_connection_MC4_condition'] ?? false,
          'comment': mpData['invertor_connection_MC4_condition_comments']
                  ?.toString() ??
              ''
        },
        'lowVoltageRange': {
          'value': mpData['low_valtage_range']?.toString() ?? '',
          'comment': mpData['low_valtage_range_comments']?.toString() ?? ''
        },
        'highVoltageRange': {
          'value': mpData['high_valtage_range']?.toString() ?? '',
          'comment': mpData['high_valtage_range_comments']?.toString() ?? ''
        },
        'lowFrequencyRange': {
          'value': mpData['low_freaquence_range']?.toString() ?? '',
          'comment': mpData['low_freaquence_range_comments']?.toString() ?? ''
        },
        'highFrequencyRange': {
          'value': mpData['high_freaquence_range']?.toString() ?? '',
          'comment': mpData['high_freaquence_range_comments']?.toString() ?? ''
        },
        'invertorSetupTime': {
          'value': mpData['invertor_startup_time']?.toString() ?? '',
          'comment': mpData['invertor_startup_time_comments']?.toString() ?? ''
        },
        'eTodayInvertor': {
          'value': mpData['e_today_invertor']?.toString() ?? '',
          'comment': mpData['e_today_invertor_comments']?.toString() ?? ''
        },
        'eTotalInvertor': {
          'value': mpData['e_total_invertor']?.toString() ?? '',
          'comment': mpData['e_total_invertor_comments']?.toString() ?? ''
        },
        'wifiConfig': {
          'checked': mpData['wifi_config_done'] is int
              ? mpData['wifi_config_done'] == 1
              : mpData['wifi_config_done'] ?? false,
          'comment': mpData['wifi_config_done_comments']?.toString() ?? ''
        },
        'powerBulbBlinkingStyle': {
          'value': mpData['power_bulb_blinking_style']?.toString() ?? '',
          'comment':
              mpData['power_bulb_blinking_style_comments']?.toString() ?? ''
        },
        'routerUsername': {
          'value': mpData['router_username']?.toString() ?? '',
          'comment': mpData['router_username_comments']?.toString() ?? ''
        },
        'routerPassword': {
          'value': mpData['router_password']?.toString() ?? '',
          'comment': mpData['router_password_comments']?.toString() ?? ''
        },
        'routerSerialNo': {
          'value': mpData['router_serial_number']?.toString() ?? '',
          'comment': mpData['router_serial_number_comments']?.toString() ?? ''
        },
        'serviceAVSticker': {
          'checked': mpData['alta_vision_sticker'] is int
              ? mpData['alta_vision_sticker'] == 1
              : mpData['alta_vision_sticker'] ?? false,
          'comment': mpData['alta_vision_sticker_comments']?.toString() ?? ''
        },
        'tookPhotos': {
          'checked': mpData['took_photos'] is int
              ? mpData['took_photos'] == 1
              : mpData['took_photos'] ?? false,
          'comment': mpData['took_photos_comments']?.toString() ?? ''
        }
      };
    }
    debugPrint('Transformed main panel work: $mainPanelWork');
    return {
      ...serviceData,
      'dc': serviceData['dc'] is Map ? serviceData['dc'] : {},
      'ac': serviceData['ac'] is Map ? serviceData['ac'] : {},
      'roof_work': _initializeRoofWorkData(serviceData['roof_work']),
      'outdoor_work': _initializeOutdoorWorkData(serviceData['outdoor_work']),
      'main_panel_work': mainPanelWork,
      'technicians':
          serviceData['technicians'] is List ? serviceData['technicians'] : [],
      // Handle any numeric fields that should be strings
      if (serviceData['mainData'] != null)
        'mainData': {
          ...serviceData['mainData'],
          'power': serviceData['mainData']['power']?.toString() ?? '',
          'time': serviceData['mainData']['time']?.toString() ?? '',
        },
    };
  }

  Map<String, dynamic> _initializeRoofWorkData(dynamic roofData) {
    if (roofData == null) {
      return {
        'cloudiness': {
          'value': roofData['cloudiness']?['value'] ?? 0,
          'comment': roofData['cloudiness']?['comment'] ?? '',
        },
        'panelService': {
          'value': roofData['panel_service']?['value'] ?? false,
          'comment': roofData['panel_service']?['comment'] ?? '',
        },
        'structureService': {
          'value': roofData['structure_service']?['value'] ?? false,
          'comment': roofData['structure_service']?['comment'] ?? '',
        },
        'nutsBolts': {
          'value': roofData['nut_bolt_condition']?['value'] ?? false,
          'comment': roofData['nut_bolt_condition']?['comment'] ?? '',
        },
        'shadow': {
          'value': roofData['shadow']?['value'] ?? false,
          'comment': roofData['shadow']?['comment'] ?? '',
        },
        'panelMp4': {
          'value': roofData['panel_MC4_condition']?['value'] ?? false,
          'comment': roofData['panel_MC4_condition']?['comment'] ?? '',
        },
        'photos': {
          'value': roofData['took_photos']?['value'] ?? false,
          'comment': roofData['took_photos']?['comment'] ?? '',
        },
      };
    }
    return roofData;
  }

  Map<String, dynamic> _initializeOutdoorWorkData(dynamic outdoorData) {
    if (outdoorData == null || outdoorData is! Map) {
      return {
        'cebExport': {'value': '', 'comment': ''},
        'cebImport': {'value': '', 'comment': ''},
        'groundResistance': {'value': '', 'comment': ''},
        'earthRod': {'checked': false, 'comment': ''},
      };
    }

    // Handle both old API field names and new structure
    return {
      'cebExport': {
        'value': (outdoorData['CEB_export_reading'] ??
                outdoorData['cebExport']?['value'] ??
                '')
            .toString(),
        'comment': (outdoorData['CEB_export_reading_comments'] ??
                outdoorData['cebExport']?['comment'] ??
                '')
            .toString(),
      },
      'cebImport': {
        'value': (outdoorData['CEB_import_reading'] ??
                outdoorData['cebImport']?['value'] ??
                '')
            .toString(),
        'comment': (outdoorData['CEB_import_reading_comments'] ??
                outdoorData['cebImport']?['comment'] ??
                '')
            .toString(),
      },
      'groundResistance': {
        'value': (outdoorData['round_resistence'] ??
                outdoorData['groundResistance']?['value'] ??
                '')
            .toString(),
        'comment': (outdoorData['round_resistence_comments'] ??
                outdoorData['groundResistance']?['comment'] ??
                '')
            .toString(),
      },
      'earthRod': {
        'checked': outdoorData['earthing_rod_connection'] ??
            outdoorData['earthRod']?['checked'] ??
            false,
        'comment': (outdoorData['earthing_rod_connection_comments'] ??
                outdoorData['earthRod']?['comment'] ??
                '')
            .toString(),
      },
    };
  }

  void _saveInitialDataToStorage() {
    final serviceKey = 'service_${widget.serviceId}';
    debugPrint(
        'Saving initial data with main panel: ${_serviceData['mainpanel_work']}');
    box.write(serviceKey, jsonEncode(_serviceData));

    final savedData = box.read(serviceKey);
    debugPrint(
        'Verified saved data: ${savedData != null ? jsonDecode(savedData)['mainpanel_work'] : 'null'}');
  }

  Future<bool> _updateServiceDetails() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      final box = GetStorage();
      final token = box.read('token');
      final userMap = box.read('user');

      if (token == null || userMap == null) {
        throw Exception('Authentication data not found');
      }

      final user = User.fromJson(userMap);

      // Get the latest form data from storage
      final serviceKey = 'service_${widget.serviceId}';
      final storedData = box.read(serviceKey);
      final formData = jsonDecode(storedData);

      final response = await http.post(
        Uri.parse('$baseUrl/services/update-details'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'service_id': widget.serviceId,
          'supervisor_id': user.id,
          ...formData, // Include all form data
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Update failed');
        }
      } else {
        throw Exception('Failed to update service: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating service: $e');
      rethrow;
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
            color: textBlack,
          ),
          style: IconButton.styleFrom(
            backgroundColor: bgLightGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            final supervisorController = Get.find<SupervisorPageController>();
            supervisorController.goToSummarize();
          },
        ),
        //centerTitle: true,
        title: const Text(
          'Edit Service',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Stepper(
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: _currentStep,
            onStepContinue: () async {
              final lastStep = _currentStep == getSteps().length - 1;
              final formState = _formKeys[_currentStep].currentState;

              if (formState != null && formState.validate()) {
                if (!lastStep) {
                  _onStepChanged(_currentStep + 1);
                } else {
                  try {
                    final success = await _updateServiceDetails();
                    if (success) {
                      Get.snackbar(
                        'Success',
                        'Service updated successfully',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: bgLightGreen,
                        colorText: textBlack,
                      );
                      final supervisorController =
                          Get.find<SupervisorPageController>();
                      supervisorController.closeServiceDetails();
                    }
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      e.toString(),
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              } else {
                debugPrint("Validation failed on Step ${_currentStep + 1}");
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                _onStepChanged(_currentStep - 1);
              }
            },
          ),
          if (_isSubmitting)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 0,
          title: const Text("1"),
          content: Form(
            key: _formKeys[0],
            child: AcDcFormWidget(serviceId: widget.serviceId),
          ),
        ),
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 1,
          title: const Text("2"),
          content: Form(
            key: _formKeys[1],
            child: RoofWorkFormWidget(serviceId: widget.serviceId),
          ),
        ),
        Step(
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 2,
          title: const Text("3"),
          content: Form(
            key: _formKeys[2],
            child: OutdoorWorkFormWidget(serviceId: widget.serviceId),
          ),
        ),
        Step(
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 3,
          title: const Text("4"),
          content: Form(
            key: _formKeys[3],
            child: MainpanelWorkFormWidget(serviceId: widget.serviceId),
          ),
        ),
        Step(
          state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 4,
          title: const Text("5"),
          content: Form(
            key: _formKeys[4],
            child: TechnicianFormWidget(serviceId: widget.serviceId),
          ),
        ),
      ];
}

import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/services.dart';
import 'package:av_solar_services/views/widgets/ac_dc_form_widget.dart';
import 'package:av_solar_services/views/widgets/mainpanel_work_form_widget.dart';
import 'package:av_solar_services/views/widgets/outdoor_work_form_widget.dart';
import 'package:av_solar_services/views/widgets/roof_work_form_widget.dart';
import 'package:av_solar_services/views/widgets/technician_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../../controllers/sup_page.dart';

class ServiceForm extends StatefulWidget {
  final int currentStep;
  final Function(int) onStepChanged;
  final int serviceId;

  const ServiceForm({
    super.key,
    required this.serviceId,
    required this.currentStep,
    required this.onStepChanged,
  });

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final box = GetStorage();
  final _formKeys = List.generate(6, (index) => GlobalKey<FormState>());
  final ServicesController _servicesController = Get.put(ServicesController());
  var formResult;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      steps: getSteps(),
      currentStep: widget.currentStep,
      onStepContinue: () async {
        final lastStep = widget.currentStep == getSteps().length - 1;
        final formState = _formKeys[widget.currentStep].currentState;

        if (formState != null && formState.validate()) {
          if (!lastStep) {
            widget.onStepChanged(widget.currentStep + 1);
          } else {
            final result = await _servicesController.submitServiceForm(
              serviceId: widget.serviceId,
              userId: box.read('user')['id'],
            );
            debugPrint("Submit result: $result");
            Get.snackbar("${_servicesController.result.value.toString()}","",
              snackPosition: SnackPosition.TOP,
              backgroundColor: bgLightGreen,
              colorText: textBlack
            );
            if (result == true) {
              debugPrint("Form complete, submitting data...");
              final SupervisorPageController supervisorController = Get.find();
              supervisorController.closeServiceDetails();//close the service details page
            }

            debugPrint(widget.serviceId.toString());

          }
        } else {
          debugPrint("Validation failed on Step ${widget.currentStep + 1}");
        }
      },
      onStepCancel: () {
        if (widget.currentStep > 0) {
          widget.onStepChanged(widget.currentStep - 1);
        }
      },
    );
  }

  List<Step> getSteps() => [
    Step(
      state: widget.currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: widget.currentStep >= 0,
      title: const Text("1"),
      content: Form(
        key: _formKeys[0],
        child: AcDcFormWidget(serviceId: widget.serviceId),
      ),
    ),
    Step(
      state: widget.currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: widget.currentStep >= 1,
      title: const Text("2"),
      content: Form(
        key: _formKeys[1],
        child: RoofWorkFormWidget(serviceId: widget.serviceId),
      ),
    ),
    Step(
      state: widget.currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: widget.currentStep >= 2,
      title: const Text("3"),
      content: Form(
        key: _formKeys[2],
        child: OutdoorWorkFormWidget(serviceId: widget.serviceId),
      ),
    ),
    Step(
      state: widget.currentStep > 3 ? StepState.complete : StepState.indexed,
      isActive: widget.currentStep >= 3,
      title: const Text("4"),
      content: Form(
        key: _formKeys[3],
        child: MainpanelWorkFormWidget(serviceId: widget.serviceId),
      ),
    ),
    Step(
      state: widget.currentStep > 4 ? StepState.complete : StepState.indexed,
      isActive: widget.currentStep >= 4,
      title: const Text("5"),
      content: Form(
        key: _formKeys[4],
        child: TechnicianFormWidget(serviceId: widget.serviceId),
      ),
    ),
  ];
}

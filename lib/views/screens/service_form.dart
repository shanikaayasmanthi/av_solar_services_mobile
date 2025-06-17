import 'package:av_solar_services/views/widgets/ac_dc_form_widget.dart';
import 'package:av_solar_services/views/widgets/mainpanel_work_form_widget.dart';
import 'package:av_solar_services/views/widgets/outdoor_work_form_widget.dart';
import 'package:av_solar_services/views/widgets/roof_work_form_widget.dart';
import 'package:av_solar_services/views/widgets/technician_form_widget.dart';
import 'package:flutter/material.dart';

class ServiceForm extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepChanged;//callback function for set the current step of service form
  final int serviceId;

  const ServiceForm({
    super.key,
    required this.serviceId,
    required this.currentStep,
    required this.onStepChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      steps: getSteps(),
      currentStep: currentStep,
      onStepContinue: () {
        final lastStep = currentStep == getSteps().length - 1;
        if (!lastStep) {
          onStepChanged(currentStep + 1);
        } else {
          // Submit form
        }
      },
      onStepCancel: () {
        if (currentStep > 0) {
          onStepChanged(currentStep - 1);
        }
      },
    );
  }

  List<Step> getSteps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text("1"),
      content: AcDcFormWidget(
        serviceId: serviceId,
      ),
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text("2"),
      content: RoofWorkFormWidget(
        serviceId: serviceId,
      ),
    ),
    Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: const Text("3"),
      content: OutdoorWorkFormWidget(
        serviceId: serviceId,
      ),
    ),
    Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: const Text("4"),
        content: MainpanelWorkFormWidget(
          serviceId: serviceId,
        )
    ),
    Step(
        state: currentStep > 4 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 4,
        title: const Text("5"),
        content: TechnicianFormWidget(
          serviceId: serviceId,
        )
    ),
    Step(
        state: currentStep > 5 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 5,
        title: const Text("6"),
        content: Text("6")
    ),
  ];
}

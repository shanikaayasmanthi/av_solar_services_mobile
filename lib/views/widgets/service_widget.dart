import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/models/Service.dart';
import 'package:av_solar_services/views/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ServiceWidget extends StatefulWidget {
  const ServiceWidget({
    super.key,
    required this.service,
    required this.onTimeSet,
    required this.onContinue,
  });

  final Service service;
  final VoidCallback onTimeSet; //call back to refresh the home
  final void Function(String serviceId)
      onContinue; //callback to redirect service details page
  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
  //get the suffix for service rounds
  String getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) return 'th';
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgDarkGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bgLightGreen, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Project No : ${widget.service.projectNo} ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${widget.service.serviceRound}${getOrdinalSuffix(widget.service.serviceRound)} service round(${widget.service.serviceType})',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.service.customerName,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            widget.service.projectName,
            style: const TextStyle(fontSize: 13, color: textGrey),
          ),
          Text(
            widget.service.projectAddress,
            style: const TextStyle(fontSize: 13, color: textGrey),
          ),
          widget.service.serviceTime != null
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "Time : ${widget.service.serviceTime}",
                    style: const TextStyle(color: textBlack),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 10),
          //time button or continue button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  widget.service.serviceTime != null
                      ? ElevatedButton(
                          //continue button
                          onPressed: () {
                            // Handle continue button action
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //to direct to services page
                                        ElevatedButton(
                                            onPressed: () {
                                              widget.onContinue(widget
                                                  .service.serviceId
                                                  .toString()); //pass service id for continue the service
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: bgGreen,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                            ),
                                            child: const Text(
                                              "Continue",
                                              style:
                                                  TextStyle(color: textWhite),
                                            )),
                                        ElevatedButton(
                                            //get location for the project site
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: bgGreen,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                            ),
                                            child: const Text(
                                              "Location",
                                              style:
                                                  TextStyle(color: textWhite),
                                            )),
                                      ],
                                    ),
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(color: textWhite),
                          ),
                        )
                      : ElevatedButton(
                          //get a time button
                          onPressed: () async {
                            // Handle Get a time button action
                            final result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                      height: 450,
                                      child: TimePicker(
                                        projectNo: widget.service.projectNo,
                                        serviceId: widget.service.serviceId,
                                        projectId: widget.service.projectId,
                                      ));
                                });
                            if (result == true) {
                              //callback
                              widget.onTimeSet();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text(
                            'Get a time',
                            style: TextStyle(color: textWhite),
                          ),
                        ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      if (widget.service.phone.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: widget.service.phone.map((phoneNumber) {
                            return Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      FlutterPhoneDirectCaller.callNumber(
                                          phoneNumber);
                                      // launch(phoneNumber);
                                    },
                                    icon: const Icon(
                                      Icons.phone,
                                      size: 15,
                                    )),
                                // const SizedBox(width: 4),
                                // Text(phoneNumber),
                                // const SizedBox(width: 12),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

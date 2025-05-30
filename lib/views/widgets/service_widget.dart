import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/models/Service.dart';
import 'package:flutter/material.dart';

class ServiceWidget extends StatefulWidget {
  const ServiceWidget({
    super.key,
    required this.service,
  });

  final Service service;
  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {

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
                style: TextStyle(fontSize: 14),
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
          widget.service.serviceTime!=null? Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Text(
              "Time : ${widget.service.serviceTime}"
            ),
          ):SizedBox.shrink(),
          const SizedBox(height: 10),
          //time button or continue button
          widget.service.serviceTime != null? ElevatedButton(
            onPressed: () {
              // Handle button action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: bgGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
                'Continue',
              style: TextStyle(
                color: textWhite
              ),
            ),
          )
          :ElevatedButton(
            onPressed: () {
              // Handle button action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: bgGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Get a time',
              style: TextStyle(
                  color: textWhite
              ),
            ),
          ),
        ],
      ),
    );
  }
}

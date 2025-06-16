import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/services.dart';

class ServiceSummery extends StatelessWidget {
  ServiceSummery({super.key});

  final ServicesController servicesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 0.0, top: 10.0),
          child: Text(
            "No of service rounds done",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 4.0),
          child: Row(
            children: [
              Text(
                "free : ",
                style: TextStyle(
                  fontSize: 15,
                  color: textBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "paid : ",
                style: TextStyle(
                  fontSize: 15,
                  color: textBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(left: 10.0, top: 4.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: bgGrey,
            border: Border.all(color: textGreen, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.0, top: 4.0),
                child: Text(
                  "1st service round",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 2.0),
              Padding(
                padding: EdgeInsets.only(left: 16.0, top: 2.0),
                child: Row(
                  children: [
                    Text(
                      "2024-10-15",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "2.00 pm",
                      style: TextStyle(
                        fontSize: 13,
                        color: textBlack,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.0),
              Padding(
                padding: EdgeInsets.only(left: 16.0, top: 4.0),
                child: Text(
                  "Bus Bar Box Cu tapes cleaned. Nut and Bolts newly fixed",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/services.dart';
import 'package:av_solar_services/models/completed_service.dart';

class ServiceSummery extends StatefulWidget {
  final int projectId;

  const ServiceSummery({super.key, required this.projectId});

  @override
  State<ServiceSummery> createState() => _ServiceSummeryState();
}

class _ServiceSummeryState extends State<ServiceSummery> {
  final ServicesController servicesController = Get.find();
  late Future<List<CompletedService>> _completedServicesFuture;
  int freeServicesCount = 0;
  int paidServicesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCompletedServices();
  }

  void _loadCompletedServices() {
    _completedServicesFuture = servicesController
        .getCompletedServicesByProject(
      projectId: widget.projectId,
    )
        .then((services) {
      // Calculate free and paid counts
      freeServicesCount = services.where((s) => !s.isPaid).length;
      paidServicesCount = services.where((s) => s.isPaid).length;
      return services;
    });
  }

  Widget _buildServiceRoundCard(CompletedService service, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, top: 4.0, right: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: bgGrey,
        border: Border.all(color: textGreen, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 4.0),
            child: Text(
              "${_getOrdinalNumber(index + 1)} service round ${service.isPaid ? '(Paid)' : '(Free)'}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 2.0),
            child: Row(
              children: [
                Text(
                  "${service.serviceDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  service.serviceTime,
                  style: const TextStyle(
                    fontSize: 13,
                    color: textBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2.0),
          if (service.remarks != null && service.remarks!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4.0),
              child: Text(
                service.remarks!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getOrdinalNumber(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CompletedService>>(
      future: _completedServicesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final services = snapshot.data ?? [];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                child: Text(
                  "No of service rounds done",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                child: Row(
                  children: [
                    Text(
                      "free : $freeServicesCount",
                      style: const TextStyle(
                        fontSize: 15,
                        color: textBlack,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "paid : $paidServicesCount",
                      style: const TextStyle(
                        fontSize: 15,
                        color: textBlack,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...services.asMap().entries.map((entry) {
                return Column(
                  children: [
                    _buildServiceRoundCard(entry.value, entry.key),
                    if (entry.key != services.length - 1)
                      const SizedBox(height: 20),
                  ],
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
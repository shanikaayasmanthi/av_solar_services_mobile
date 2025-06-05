import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/services.dart';
import 'package:av_solar_services/views/widgets/service_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:av_solar_services/models/Service.dart';

class Home extends StatefulWidget {
  final void Function(String serviceId) onServiceContinueTap;
  const Home({super.key, required this.onServiceContinueTap});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ServicesController _servicesController = Get.put(ServicesController());
  List<Service> services = [];
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  void loadServices() async {
    final result =
        await _servicesController.getServices(userId: box.read('user')['id']);
    setState(() {
      services = result.cast<Service>();
    });
    // debugPrint(services.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Services",
                  style: TextStyle(
                    color: textBlack,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _servicesController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: services.length,
                        itemBuilder: (context, index) => ServiceWidget(
                          service: services[index],
                          onTimeSet: () {
                            //refresh the home page
                            loadServices(); // reload services after time is set
                          },
                          onContinue: (serviceId) {
                            //load the service details page
                            widget.onServiceContinueTap(
                                serviceId); //pass the serviceId for the service details page when continue the service
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

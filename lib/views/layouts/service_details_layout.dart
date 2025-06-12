import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/services.dart';
import 'package:av_solar_services/views/screens/project.dart';
import 'package:av_solar_services/views/screens/service_form.dart';
import 'package:av_solar_services/views/screens/service_summery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ServiceDetailsLayout extends StatefulWidget {
  const ServiceDetailsLayout({
    super.key,
    required this.serviceId
  });

  final int serviceId;

  @override
  State<ServiceDetailsLayout> createState() => _ServiceDetailsLayoutState();
}

class _ServiceDetailsLayoutState extends State<ServiceDetailsLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ServicesController _servicesController = Get.put(ServicesController());
  final box = GetStorage();
  Map<dynamic,dynamic>? project; // project can be null

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    getProjectId(widget.serviceId);
    super.initState();
  }

  void getProjectId(int serviceId) async {
    Map<dynamic,dynamic> result = await _servicesController.getProjectId(
        userId: box.read('user')['id'],
        serviceId: serviceId
    );
    setState(() {
      project = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if project data is available
    if (project == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show a loading spinner
        ),
      );
    }

    // Once project is not null, build the main content
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Now 'project' is guaranteed not to be null here
                    "Project No: ${project!["project_no"]}",
                    style: const TextStyle(
                      color: textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${project!["project_name"]}",
                    style: const TextStyle(
                      color: textBlack,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: textBlack,
              unselectedLabelColor: textGrey,
              tabs: const [
                Tab(text: "Project"),
                Tab(text: "Summery"),
                Tab(text: "Service"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Use `project!['project_id']` or a default value
                  ProjectDetails(projectId: project!['project_id']),
                  ServiceSummery(),
                  ServiceForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
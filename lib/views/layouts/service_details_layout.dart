import 'package:av_solar_services/constants/colors.dart';
import 'package:flutter/material.dart';
class ServiceDetailsLayout extends StatefulWidget {
  const ServiceDetailsLayout({
    super.key,
    required this.serviceId
  });

  final String serviceId;

  @override
  State<ServiceDetailsLayout> createState() => _ServiceDetailsLayoutState();
}

class _ServiceDetailsLayoutState extends State<ServiceDetailsLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Aligns children to the start
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              // Adds spacing around the project info
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to left
                children: const [
                  Text(
                    "Project No: 1094",
                    style: TextStyle(
                      color: textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Project Name",
                    style: TextStyle(
                      color: textBlack,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),

            // Tab bar for project details
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Project"),
                Tab(text: "Summery"),
                Tab(text: "Service"),
              ],
            ),

            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Center(child: Text("Project Data")),
                  Center(child: Text("Summery Data")),
                  Center(child: Text("Service Data")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

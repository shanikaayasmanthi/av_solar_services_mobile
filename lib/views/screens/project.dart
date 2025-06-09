import 'package:av_solar_services/views/widgets/customer_details.dart';
import 'package:flutter/material.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({
    super.key,
    required this.projectId
  });

  final int projectId;
  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              CustomerDetails(projectId: widget.projectId)
            ],
          )
        ],
      ),
    );
  }
}

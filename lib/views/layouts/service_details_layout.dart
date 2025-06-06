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

class _ServiceDetailsLayoutState extends State<ServiceDetailsLayout> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(widget.serviceId),);
  }
}

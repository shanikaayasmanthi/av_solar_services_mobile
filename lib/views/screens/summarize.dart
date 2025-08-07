import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/constants/base_url.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:av_solar_services/models/User.dart';
import 'package:av_solar_services/views/screens/service_form.dart';

class Summarize extends StatefulWidget {
  const Summarize({super.key});

  @override
  State<Summarize> createState() => _SummarizeState();
}

class _SummarizeState extends State<Summarize> {
  String currentDate = '';
  int totalServices = 0;
  int freeServices = 0;
  int paidServices = 0;
  String totalCapacity = '0kw';
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic> completedServices = [];
  bool isLoadingServices = false;

  @override
  void initState() {
    super.initState();
    CurrentDate();
    fetchTodaySummary();
    fetchTodayCompletedServices();
  }

  void CurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    setState(() {
      currentDate = formatter.format(now);
    });
  }

  Future<void> fetchTodaySummary() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final box = GetStorage();
      final userMap = box.read('user');
      final token = box.read('token');
      
      if (userMap == null || token == null) {
        throw Exception('User data or token not found');
      }

      final user = User.fromJson(userMap);
      
      final response = await http.post(
        Uri.parse('$baseUrl/services/today-summary'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'supervisor_id': user.id,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final summary = responseData['data'];

        setState(() {
          totalServices = summary['total_services'] ?? 0;
          freeServices = summary['free_services'] ?? 0;
          paidServices = summary['paid_services'] ?? 0;
          totalCapacity = summary['total_capacity'] ?? '0kw';
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load summary: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error: ${e.toString()}';
          isLoading = false;
        });
      }
      debugPrint('Error fetching summary: $e');
    }
  }

  Future<void> fetchTodayCompletedServices() async {
    try {
      if (mounted) {
        setState(() {
          isLoadingServices = true;
        });
      }

      final box = GetStorage();
      final userMap = box.read('user');
      final token = box.read('token');
      
      if (userMap == null || token == null) {
        throw Exception('User data or token not found');
      }

      final user = User.fromJson(userMap);
      
      final response = await http.post(
        Uri.parse('$baseUrl/services/today-completed'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'supervisor_id': user.id,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            completedServices = responseData['data']['services'] ?? [];
            isLoadingServices = false;
          });
        }
      } else {
        throw Exception('Failed to load services: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingServices = false;
        });
      }
      debugPrint('Error fetching completed services: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchServiceDetails(int serviceId) async {
    try {
      final box = GetStorage();
      final token = box.read('token');
      
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/services/$serviceId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'];
      } else {
        throw Exception('Failed to load service details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching service details: $e');
      return null;
    }
  }

  Future<void> _navigateToServiceForm(int serviceId, BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      // Fetch service details
      final serviceDetails = await fetchServiceDetails(serviceId);
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      if (serviceDetails == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load service details')),
          );
        }
        return;
      }

      // Save the fetched data to GetStorage
      final box = GetStorage();
      final serviceKey = 'service_$serviceId';
      await box.write(serviceKey, jsonEncode(serviceDetails));
      
      // Navigate to ServiceForm
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceForm(
              serviceId: serviceId,
              currentStep: 0,
              onStepChanged: (step) {},
            ),
          ),
        );
        
        // Refresh the data when returning from edit
        fetchTodaySummary();
        fetchTodayCompletedServices();
      }
    } catch (e) {
      // Close loading dialog if still mounted
      if (mounted) Navigator.of(context).pop();
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      debugPrint('Navigation error: $e');
    }
  }

  Widget _buildSummaryCard() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchTodaySummary,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      color: bgLightTeal,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: bgGreen,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Services",
                  style: TextStyle(
                    color: textBlack,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "$totalServices",
                  style: const TextStyle(
                    color: textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Free Services",
                  style: TextStyle(
                    color: textBlack,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "$freeServices",
                  style: const TextStyle(
                    color: textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Paid Services",
                  style: TextStyle(
                    color: textBlack,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "$paidServices",
                  style: const TextStyle(
                    color: textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total capacity",
                  style: TextStyle(
                    color: textBlack,
                    fontSize: 16,
                  ),
                ),
                Text(
                  totalCapacity.toLowerCase(),
                  style: const TextStyle(
                    color: textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedServicesList() {
    if (isLoadingServices) {
      return const Center(child: CircularProgressIndicator());
    }

    if (completedServices.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "No completed services found for today",
          style: TextStyle(color: textBlack),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: completedServices.length,
      itemBuilder: (context, index) {
        final service = completedServices[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: bgGrey,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Project: ${service['project_name']}",
                      style: const TextStyle(
                        color: textBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Service #${service['service_no']}",
                      style: const TextStyle(
                        color: textGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Project No: ${service['project_no'] ?? 'N/A'}",
                  style: const TextStyle(color: textBlack),
                ),
                const SizedBox(height: 4),
                Text(
                  "Type: ${service['service_type']}",
                  style: const TextStyle(color: textBlack),
                ),
                const SizedBox(height: 4),
                Text(
                  "Capacity: ${service['capacity']}",
                  style: const TextStyle(color: textBlack),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _navigateToServiceForm(service['service_id'], context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textGreen,
                      foregroundColor: textWhite,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today Overview",
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currentDate,
                      style: const TextStyle(
                          color: textBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSummaryCard(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Completed Services Today",
                    style: TextStyle(
                      color: textBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildCompletedServicesList(),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/services.dart';
import 'package:av_solar_services/models/Customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({
    super.key,
    required this.projectId
  });

  final int projectId;
  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {

  final ServicesController _servicesController = Get.put(ServicesController());
  Customer? customer;

  @override
  void initState()
  {
    super.initState();
    loadCustomer(widget.projectId);
  }

  void loadCustomer(int projectId)async{
     final result = await _servicesController.getCustomer(projectId: projectId);
     debugPrint(result.toString());
     setState(() {
       customer = result;
     });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return customer != null?  Container(
      width: screenWidth,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.only(left: 25,top: 15,bottom: 15),
      decoration: BoxDecoration(
        color: bgGreen,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Customer Details",
          style: TextStyle(
            color: textWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 10.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${customer?.name}",
                style: const TextStyle(
                  color: textWhite,
                  fontSize: 16
                ),),
                Text("${customer?.address}",
                  style: const TextStyle(
                      color: textWhite,
                      fontSize: 16
                  ),),
                if (customer?.phoneNumbers == null || customer!.phoneNumbers.isEmpty)
                  const Text(
                    "No phone numbers available",
                    style: TextStyle(color: textWhite, fontSize: 16, fontStyle: FontStyle.italic),
                  )
                else
                  ...customer!.phoneNumbers.map((phone) => Text(
                    phone,
                    style: const TextStyle(
                      color: textWhite,
                      fontSize: 16,
                    ),
                  )),
              ],
            ),
          )
        ],
      )
    ):const CircularProgressIndicator();
  }
}

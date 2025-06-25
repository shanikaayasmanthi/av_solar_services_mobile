import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/services.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:get/get.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
    required this.projectNo,
    required this.serviceId,
    required this.projectId,
  });


  final int projectNo;
  final int serviceId;
  final int projectId;
  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final box = GetStorage();

  final ServicesController _servicesController = Get.put(ServicesController());

  var hour = 0;
  var minute = 0;
  var timeFormat = "AM";
  @override
  Widget build(BuildContext context) {

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;


    return SafeArea(
  child: SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.05),
    child: Column(
      mainAxisSize: MainAxisSize.min, // <- Important for bottom sheets
      children: [
          Row(
            children: [
              Text("Project No : ${widget.projectNo}",
              style: TextStyle(
                color: textBlack,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05

              ),),
            ],
          ),
          SizedBox(height: screenHeight * 0.02,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberPicker(
                    minValue: 0,
                    maxValue: 12,
                    value: hour,
                    zeroPad: true,
                    infiniteLoop: true,
                    itemWidth: screenWidth * 0.1,
                    itemHeight: screenHeight * 0.08,
                    textStyle: TextStyle(
                      color: textGrey,
                      fontSize: screenWidth * 0.05
                    ),
                    selectedTextStyle: TextStyle(
                      color: textBlack,
                      fontSize: screenWidth * 0.075
                    ),
                    onChanged: (value){
                      setState(() {
                        hour = value;
                      });
                    },
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: textGrey,
                      ),
                      bottom: BorderSide(
                        color: textGrey
                      ),
                    ),
                  ),
                ),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: minute,
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: screenWidth * 0.1,
                  itemHeight: screenHeight * 0.08,
                  textStyle: TextStyle(
                      color: textGrey,
                      fontSize: screenWidth * 0.05
                  ),
                  selectedTextStyle: TextStyle(
                      color: textBlack,
                      fontSize: screenWidth * 0.075
                  ),
                  onChanged: (value){
                    setState(() {
                      minute = value;
                    });
                  },
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: textGrey,
                      ),
                      bottom: BorderSide(
                          color: textGrey
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          timeFormat="AM";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.01
                        ),
                        decoration: BoxDecoration(
                          color: timeFormat=="AM"?bgGrey:bgWhite,
                          border: Border.all(
                              color: timeFormat=="AM"?textBlack:textGrey
                          ),
                        ),
                        child: Text("AM",
                          style: TextStyle(
                              color: timeFormat=="AM"?textBlack:textGrey,
                              fontSize: screenWidth * 0.06
                          ),),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          timeFormat="PM";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.01
                        ),
                        decoration: BoxDecoration(
                          color:  timeFormat=="PM"?bgGrey:bgWhite,
                          border: Border.all(
                              color:  timeFormat=="PM"?textBlack:textGrey
                          ),
                        ),
                        child: Text("PM",
                          style: TextStyle(
                              color: timeFormat=="PM"?textBlack:textGrey,
                              fontSize: screenWidth * 0.06
                          ),),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $timeFormat",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: textGrey
              ),)
            ],
          ),
          Obx((){
            final result = _servicesController.result.value;
            return result !=null? Align(
    alignment: Alignment.center,
    child: Text(result,
    style: TextStyle(
      color: result.toLowerCase().contains('successfully')?textGreen:textRed
    ),),
    )
    :const SizedBox.shrink();
          }),
          SizedBox(height: screenHeight * 0.02,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: (){
                    setState(() {
                      hour=0;
                      minute=0;
                      timeFormat="AM";
                      Navigator.pop(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgGrey,
                  ),
                  child: const Text("Cancel",
                  style: TextStyle(
                    color: textBlack
                  ),)

              ),
              ElevatedButton(
                  onPressed: ()async {
                    final result = await _servicesController.setTime(
                        userId: box.read("user")['id'],
                        serviceId: widget.serviceId,
                        projectId: widget.projectId,
                        projectNo: widget.projectNo,
                        time: "${hour.toString().padLeft(2, '0')}:${minute
                            .toString().padLeft(2, '0')} $timeFormat");
                    if (result == 1) {
                      Get.back(result: true);
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgGreen
                  ),
                  child: const Text("Set",
                    style: TextStyle(
                        color: textWhite
                    ),)),
            ],
          )
        ],
      ),
     ),
    );
  }
}

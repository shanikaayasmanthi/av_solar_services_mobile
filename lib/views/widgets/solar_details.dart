import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/services.dart';
import 'package:av_solar_services/models/Battery.dart';
import 'package:av_solar_services/models/Invertor.dart';
import 'package:av_solar_services/models/OffGridHybrid.dart';
import 'package:av_solar_services/models/OnGrid.dart';
import 'package:av_solar_services/models/Project.dart';
import 'package:av_solar_services/models/SolarPanel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SolarPanelInfoCard extends StatefulWidget {
  const SolarPanelInfoCard({
    super.key,
    required this.projectId,
  });

  final int projectId;

  @override
  State<SolarPanelInfoCard> createState() => _SolarPanelInfoCardState();
}

class _SolarPanelInfoCardState extends State<SolarPanelInfoCard> {
  final ServicesController _servicesController = Get.put(ServicesController());

  Project? project;
  OnGrid? onGrid;
  OffGridHybrid? offGridHybrid;
  List<SolarPanel> solarPanels = [];
  List<Invertor> invertors = [];
  List<Battery> batteries = [];
  Map<String, dynamic> projectdata = {};




  @override
  void initState(){
    super.initState();
    loadProject(widget.projectId);

  }

  void loadProject(int projectId) async {
    final result = await _servicesController.getProjectDetails(projectId: projectId);

    final data = result['data'];

    if (data == null) {
      debugPrint("No data found in result: $result");
      return;
    }

    setState(() {
      if (data['project'] != null) {
        project = Project.fromJson(data['project']);
      }

      if (data['solar_panel'] != null) {
        solarPanels = List<Map<String, dynamic>>.from(data['solar_panel'])
            .map((e) => SolarPanel.fromJson(e))
            .toList();
      }

      if (data['invertor'] != null) {
        invertors = List<Map<String, dynamic>>.from(data['invertor'])
            .map((e) => Invertor.fromJson(e))
            .toList();
      }

      if (project?.type == 'ongrid' && data['on_grid'] != null) {
        onGrid = OnGrid.fromJson(data['on_grid']);
      } else if (project?.type == 'offgrid') {
        if (data['off_grid_hybrid'] != null) {
          offGridHybrid = OffGridHybrid.fromJson(data['off_grid_hybrid']);
        }

        if (data['battery'] != null) {
          final batteryData = data['battery'];

          if (batteryData is List) {
            batteries = batteryData
                .map((e) => Battery.froJson(e as Map<String, dynamic>))
                .toList();
          } else if (batteryData is Map<String, dynamic>) {
            batteries = [Battery.froJson(batteryData)];
          }
        }

      }
      project != null? project?.type == 'ongrid'? projectdata =  {
        "project No":onGrid?.projectNo,
        "Project type": project?.type,
        "No of panels": project?.noOfPanels,
        "Panel capacity": "${project?.capacity} kW",
        "Electricity bill name":onGrid?.electricityBillName??'Not updated yet',
        "Wifi username":onGrid?.wifiUsername??'Not updated yet',
        "wifi password":onGrid?.wifiPassword??'Not updated yet',
        "Harmonic Meter":onGrid?.harmonicMeter??'Not Updated yet',
        "System On":project?.systemOn??'Not updated yet',
        "Installation Date":project?.installationDate??'Not updated yet',
        "Special note" : project?.remarks?? 'No special note',
        "remarks":onGrid?.remarks??'No remarks'
      }:projectdata = {
        "project No":offGridHybrid?.projectNo,
        "Project type": project?.type,
        "No of panels": project?.noOfPanels,
        "Panel capacity": "${project?.capacity} kW",
        "Wifi username":offGridHybrid?.wifiUsername??'Not updated yet',
        "Wifi password":offGridHybrid?.wifiPassword??'Not updated yet',
        "Connection Type":offGridHybrid?.connectionType??'Not updated yet',
        "System On":project?.systemOn??'Not updated yet',
        "Installation Date":project?.installationDate??'Not updated yet',
        "Special note" : project?.remarks?? 'No special note',
        "remarks":offGridHybrid?.remarks??'No remarks'
      }: projectdata ={};
    });

  }




  @override
  Widget build(BuildContext context) {
    return project!=null? Column(
      children: [
        const Text("Project Details",style: TextStyle(color: textBlack,fontWeight: FontWeight.bold,fontSize: 18),),
        Card(
          margin: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:Column(
              children: projectdata.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textBlack,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "${entry.value}",
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10,),
        const Text("Solar Panel Details",style: TextStyle(color: textBlack,fontWeight: FontWeight.bold,fontSize: 18),),
        Card(
          margin: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:Column(
              children: solarPanels.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.panelModel,
                          style: const TextStyle(
                            color: textGrey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          entry.panelType,
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          entry.panelModelCode,
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${entry.panelWattage}kW",
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          entry.noOfPanels,
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10,),
        const Text("Invertor Details",style: TextStyle(color: textBlack,fontWeight: FontWeight.bold,fontSize: 18),),
        Card(
          margin: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:Column(
              children: invertors.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.brand,
                          style: const TextStyle(
                            color: textGrey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.invertorCheckCode,
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.invertorModelCode,
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "${entry.capacity}kW",
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          entry.invertorSerialNo,
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10,),
        batteries.isNotEmpty?
        const Text("Battery Details",style: TextStyle(color: textBlack,fontWeight: FontWeight.bold,fontSize: 18),):const SizedBox.shrink(),
        batteries.isNotEmpty?Card(
          margin: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:Column(
              children: batteries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.brand,
                          style: const TextStyle(
                            color: textGrey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.model,
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.model,
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "${entry.capacity}kW",
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          entry.serialNo,
                          style: const TextStyle(color: textGrey),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ):const SizedBox.shrink(),
      ]
      ,
    ): const Text("Loading..",
      style: TextStyle(color: textGrey,fontStyle: FontStyle.italic),);
  }
}

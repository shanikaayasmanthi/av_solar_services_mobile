class OnGrid {
  final int projectNo;
  final String? electricityBillName;
  final String? wifiUsername;
  final String?wifiPassword;
  final String? harmonicMeter;
  final String? remarks;


  OnGrid({
    required this.projectNo,
    this.electricityBillName,
    this.wifiUsername,
    this.wifiPassword,
    this.harmonicMeter,
    this.remarks,
  });

  factory OnGrid.fromJson(Map<String,dynamic> json){
    return OnGrid(
        projectNo: json['on_grid_project_id'],
      electricityBillName: json['electricity_bill_name'],
      wifiPassword:json['wifi_password'] ,
      wifiUsername:json['wifi_username'] ,
      harmonicMeter:json['harmonic_meter'] ,
      remarks:json['remarks'] ,

    );
  }
}


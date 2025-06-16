class OffGridHybrid {
  final int projectNo;
  final String? wifiUsername;
  final String?wifiPassword;
  final String? connectionType;
  final String? remarks;


  OffGridHybrid({
    required this.projectNo,
    this.wifiUsername,
    this.wifiPassword,
    this.connectionType,
    this.remarks,
});

  factory OffGridHybrid.fromJson(Map<String,dynamic> json){
    return OffGridHybrid(
      projectNo: json['off_grid_hybrid_project_id'],
      wifiPassword:json['wifi_password'] ,
      wifiUsername:json['wifi_username'] ,
      connectionType:json['connection_type'],
      remarks:json['remarks'],

    );
  }
}
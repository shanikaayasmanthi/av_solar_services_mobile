class Project{
  final String type;
  final int noOfPanels;
  final double capacity;
  final int? serviceYears;
  final int? serviceRounds;
  final DateTime? systemOn;
  final DateTime? installationDate;
  final String? remarks;


  Project({

    required this.type,
    required this.noOfPanels,
    required this.capacity,
    this.serviceYears,
    this.serviceRounds,
    this.systemOn,
    this.installationDate,
    this.remarks,
});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      type: json['type'],
      noOfPanels: json['no_of_panels'],
      capacity: (json['panel_capacity'] as num).toDouble(),
      serviceYears: json['service_years_in_agreement'],
      serviceRounds: json['service_rounds_in_agreement'],
      systemOn: json['system_on'] != null ? DateTime.tryParse(json['system_on']) : null,
      installationDate: json['project_installation_date'] != null
          ? DateTime.tryParse(json['project_installation_date'])
          : null,
      remarks: json['remarks'],
    );
  }

}
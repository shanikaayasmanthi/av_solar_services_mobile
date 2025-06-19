class CompletedService {
  final int serviceRound;
  final String serviceType;
  final DateTime serviceDate;
  final String serviceTime;
  final String? remarks;
  final Map<String, dynamic>? outdoorWork;
  final Map<String, dynamic>? roofWork;
  final Map<String, dynamic>? mainPanelWork;
  final Map<String, dynamic>? dcWork;
  final Map<String, dynamic>? acWork;
  final bool isPaid;

  CompletedService({
    required this.serviceRound,
    required this.serviceType,
    required this.serviceDate,
    required this.serviceTime,
    this.remarks,
    this.outdoorWork,
    this.roofWork,
    this.mainPanelWork,
    this.dcWork,
    this.acWork,
    required this.isPaid,
  });

  factory CompletedService.fromJson(Map<String, dynamic> json) {
    return CompletedService(
      serviceRound: json['service_round'],
      serviceType: json['service_type'],
      serviceDate: DateTime.parse(json['service_date']),
      serviceTime: json['service_time'],
      remarks: json['remarks'],
      outdoorWork: json['outdoor_work'],
      roofWork: json['roof_work'],
      mainPanelWork: json['main_panel_work'],
      dcWork: json['dc_work'],
      acWork: json['ac_work'],
      isPaid: json['is_paid'] ?? false,
    );
  }
}
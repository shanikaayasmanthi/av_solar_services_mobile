class Service {
  final int serviceId;
  final int projectId;
  final int projectNo;
  final String projectName;
  final String projectAddress;
  final String customerName;
  final List<String> phone;
  final int serviceRound;
  final String serviceType;
  final DateTime serviceDate;
  final String? serviceTime;

  Service({
    required this.serviceId,
    required this.projectId,
    required this.projectNo,
    required this.projectName,
    required this.projectAddress,
    required this.customerName,
    required this.phone,
    required this.serviceRound,
    required this.serviceType,
    required this.serviceDate,
    this.serviceTime,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['service_id'],
      projectId: json['project_id'],
      projectNo: json['project_no'],
      projectName: json['project_name'],
      projectAddress: json['project_address'],
      customerName: json['customer_name'],
      phone: List<String>.from(json['phone'] ?? []),
      serviceRound: json['service_round'],
      serviceType: json['service_type'],
      serviceDate: DateTime.parse(json['service_date']),
      serviceTime: json['service_time'],
    );
  }
}

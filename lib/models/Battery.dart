class Battery{
  final String brand;
  final String model;
  final String capacity;
  final String serialNo;

  Battery({
    required this.brand,
    required this.model,
    required this.capacity,
    required this.serialNo,
});

  factory Battery.froJson(Map<String,dynamic> json){
    return Battery(
        brand: json['battery_brand'],
        model: json['battery_model'],
        capacity: json['battery_capacity'],
        serialNo: json['battery_serial_no']
    );
  }
}
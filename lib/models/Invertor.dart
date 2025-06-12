class Invertor {
  final String invertorModelCode;
  final String invertorCheckCode;
  final String invertorSerialNo;
  final String brand;
  final String capacity;


  Invertor({
   required this.invertorModelCode,
   required this.invertorCheckCode,
   required this.invertorSerialNo,
   required this.brand,
   required this.capacity,
});

  factory Invertor.fromJson(Map<String,dynamic> json){
    return Invertor(
        invertorModelCode: json['invertor_model_no'],
        invertorCheckCode: json['invertor_check_code'],
        invertorSerialNo: json['invertor_serial_no'],
        brand: json['brand'],
        capacity: json['invertor_capacity']
    );
  }
}
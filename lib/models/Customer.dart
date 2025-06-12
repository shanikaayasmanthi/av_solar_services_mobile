class Customer {
  final int id;
  final int userId;
  final String name;
  final String? nic;
  final String? phone;
  final String? address;
  final List<String> phoneNumbers;

  Customer({
    required this.id,
    required this.userId,
    required this.name,
    this.nic,
    this.phone,
    this.address,
    required this.phoneNumbers,
  });

  factory Customer.fromNestedJson(Map<String, dynamic> json) {
    final customerJson = json['customer'];
    return Customer(
      id: customerJson['id'],
      userId: customerJson['user_id'],
      name: customerJson['name'],
      nic: customerJson['nic'],
      phone: customerJson['phone'],
      address: customerJson['address'],
      phoneNumbers: List<String>.from(json['phone_numbers'] ?? []),
    );
  }
}

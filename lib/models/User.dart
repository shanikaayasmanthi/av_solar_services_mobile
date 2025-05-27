class User {
  final int id;
  final String name;
  final String email;
  final int userTypeId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userTypeId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userTypeId: json['user_type_id'],
    );
  }
}

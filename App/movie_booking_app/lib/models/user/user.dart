class User {
  final String fullName;
  final String phoneNumber;
  final String gender;
  final String dayOfBirth;
  final String email;
  final String password;

  User({
    required this.fullName,
    required this.phoneNumber,
    required this.gender,
    required this.dayOfBirth,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      dayOfBirth: json['dayOfBirth'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dayOfBirth': dayOfBirth,
      'email': email,
      'password': password,
    };
  }
}

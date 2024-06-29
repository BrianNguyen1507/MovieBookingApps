class Account {
  final String email;
  final String avatar;
  final String fullName;
  final String phoneNumber;
  final String gender;
  final String dayOfBirth;

  Account({
    required this.email,
    required this.avatar,
    required this.fullName,
    required this.phoneNumber,
    required this.gender,
    required this.dayOfBirth
  });

  factory Account.fromJson(Map<String, dynamic> json){
    return Account(
        email: json['email'],
        avatar: json['avatar'] ?? "",
        fullName: json['fullName'],
        phoneNumber:json['phoneNumber'] ,
        gender: json['gender'],
        dayOfBirth: json['dayOfBirth']);
  }
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dayOfBirth': dayOfBirth,
      'avatar': avatar,
    };
  }
}
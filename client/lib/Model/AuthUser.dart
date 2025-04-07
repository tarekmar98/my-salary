class AuthUser {
  final String? phoneNumber;
  final String? token;

  AuthUser({
    required this.phoneNumber,
    this.token,
  });

  factory AuthUser.fromJson(String phoneNumber, Map<String, dynamic> json) {
    return AuthUser(
      phoneNumber: phoneNumber,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'token': token,
    };
  }
}
class AuthUser {
  final String? phoneNumber;
  final String? country;
  final String? city;
  final String? religion;
  final String? language;


  AuthUser({
    required this.phoneNumber,
    this.country,
    this.city,
    this.religion,
    this.language,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      phoneNumber: json['phoneNumber'],
      country: json['country'],
      city: json['city'],
      religion: json['religion'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'country': country,
      'city': city,
      'religion': religion,
      'language': language,
    };
  }
}
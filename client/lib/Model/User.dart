class User {
  String? phoneNumber;
  String? country;
  String? city;
  String? religion;
  String? language;


  User({
    this.phoneNumber,
    this.country,
    this.city,
    this.religion,
    this.language,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
class Company {
  const Company({
    this.name = '',
    this.address = '',
    this.city = '',
    this.phone = '',
    this.email = '',
    this.recruiterName = '',
    this.position = '',
    this.offerUrl = '',
    this.website = '',
  });

  final String name;
  final String address;
  final String city;
  final String phone;
  final String email;
  final String recruiterName;
  final String position;
  final String offerUrl;
  final String website;

  bool get isEmpty =>
      name.isEmpty &&
      address.isEmpty &&
      city.isEmpty &&
      phone.isEmpty &&
      email.isEmpty &&
      recruiterName.isEmpty &&
      position.isEmpty &&
      offerUrl.isEmpty &&
      website.isEmpty;

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'city': city,
    'phone': phone,
    'email': email,
    'recruiterName': recruiterName,
    'position': position,
    'offerUrl': offerUrl,
    'website': website,
  };

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    name: json['name'] as String? ?? '',
    address: json['address'] as String? ?? '',
    city: json['city'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    email: json['email'] as String? ?? '',
    recruiterName: json['recruiterName'] as String? ?? '',
    position: json['position'] as String? ?? '',
    offerUrl: json['offerUrl'] as String? ?? '',
    website: json['website'] as String? ?? '',
  );

  Company copyWith({
    String? name,
    String? address,
    String? city,
    String? phone,
    String? email,
    String? recruiterName,
    String? position,
    String? offerUrl,
    String? website,
  }) => Company(
    name: name ?? this.name,
    address: address ?? this.address,
    city: city ?? this.city,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    recruiterName: recruiterName ?? this.recruiterName,
    position: position ?? this.position,
    offerUrl: offerUrl ?? this.offerUrl,
    website: website ?? this.website,
  );
}

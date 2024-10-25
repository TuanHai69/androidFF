class Account {
  final String id;
  final String username;
  final String name;
  final String picture;
  final DateTime birthday;
  final String gender;
  final String password;
  final String address;
  final String phonenumber;
  final String email;
  final String role;

  Account({
    required this.id,
    required this.username,
    required this.name,
    required this.picture,
    required this.birthday,
    required this.gender,
    required this.password,
    required this.address,
    required this.phonenumber,
    required this.email,
    required this.role,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['_id'],
      username: json['username'],
      name: json['name'] ?? '',
      picture: json['picture'] ?? '',
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : DateTime.now(),
      gender: json['gender'] ?? '',
      password: json['password'],
      address: json['address'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'name': name,
      'picture': picture,
      'birthday': birthday.toIso8601String(),
      'gender': gender,
      'password': password,
      'address': address,
      'phonenumber': phonenumber,
      'email': email,
      'role': role,
    };
  }

  Account copyWith({
    String? id,
    String? username,
    String? name,
    String? picture,
    DateTime? birthday,
    String? gender,
    String? password,
    String? address,
    String? phonenumber,
    String? email,
    String? role,
  }) {
    return Account(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      address: address ?? this.address,
      phonenumber: phonenumber ?? this.phonenumber,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
}

class Branch {
  final String id;
  final String name;
  final DateTime birthday;
  final String address;
  final String phonenumber;
  final String email;
  final String description;
  final String userid;
  final int storecount;
  final String state;

  Branch({
    required this.id,
    required this.name,
    required this.birthday,
    required this.address,
    required this.phonenumber,
    required this.email,
    required this.description,
    required this.userid,
    required this.storecount,
    required this.state,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'],
      name: json['name'],
      birthday: DateTime.parse(json['birthday']),
      address: json['address'],
      phonenumber: json['phonenumber'],
      email: json['email'],
      description: json['description'],
      userid: json['userid'],
      storecount: json['storecount'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'birthday': birthday.toIso8601String(),
      'address': address,
      'phonenumber': phonenumber,
      'email': email,
      'description': description,
      'userid': userid,
      'storecount': storecount,
      'state': state,
    };
  }

  Branch copyWith({
    String? id,
    String? name,
    DateTime? birthday,
    String? address,
    String? phonenumber,
    String? email,
    String? description,
    String? userid,
    int? storecount,
    String? state,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
      phonenumber: phonenumber ?? this.phonenumber,
      email: email ?? this.email,
      description: description ?? this.description,
      userid: userid ?? this.userid,
      storecount: storecount ?? this.storecount,
      state: state ?? this.state,
    );
  }
}

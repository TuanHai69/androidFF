class Store {
  final String id;
  final String name;
  final DateTime birthday;
  final String picture;
  final String address;
  final String phonenumber;
  final String email;
  final String description;
  final String opentime;
  final String userid;
  final String branchid;
  final String state;

  Store({
    required this.id,
    required this.name,
    required this.birthday,
    required this.picture,
    required this.address,
    required this.phonenumber,
    required this.email,
    required this.description,
    required this.opentime,
    required this.userid,
    required this.branchid,
    required this.state,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'],
      name: json['name'],
      birthday: DateTime.parse(json['birthday']),
      picture: json['picture'],
      address: json['address'],
      phonenumber: json['phonenumber'],
      email: json['email'],
      description: json['description'],
      opentime: json['opentime'],
      userid: json['userid'],
      branchid: json['branchid'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'birthday': birthday.toIso8601String(),
      'picture': picture,
      'address': address,
      'phonenumber': phonenumber,
      'email': email,
      'description': description,
      'opentime': opentime,
      'userid': userid,
      'branchid': branchid,
      'state': state,
    };
  }

  Store copyWith({
    String? id,
    String? name,
    DateTime? birthday,
    String? picture,
    String? address,
    String? phonenumber,
    String? email,
    String? description,
    String? opentime,
    String? userid,
    String? branchid,
    String? state,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      picture: picture ?? this.picture,
      address: address ?? this.address,
      phonenumber: phonenumber ?? this.phonenumber,
      email: email ?? this.email,
      description: description ?? this.description,
      opentime: opentime ?? this.opentime,
      userid: userid ?? this.userid,
      branchid: branchid ?? this.branchid,
      state: state ?? this.state,
    );
  }
}

class Type {
  final String id;
  final String name;
  final String description;
  final String userid;
  final String state;

  Type({
    required this.id,
    required this.name,
    required this.description,
    required this.userid,
    required this.state,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      userid: json['userid'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'userid': userid,
      'state': state,
    };
  }

  Type copyWith({
    String? id,
    String? name,
    String? description,
    String? userid,
    String? state,
  }) {
    return Type(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userid: userid ?? this.userid,
      state: state ?? this.state,
    );
  }
}

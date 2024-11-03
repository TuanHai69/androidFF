class CommentStore {
  final String id;
  final String userid;
  final String storeid;
  final int rate;
  final String commentstore;
  final String state;
  final String? name;
  final String? picture;

  CommentStore({
    required this.id,
    required this.userid,
    required this.storeid,
    required this.rate,
    required this.commentstore,
    required this.state,
    this.name,
    this.picture,
  });

  factory CommentStore.fromJson(Map<String, dynamic> json) {
    return CommentStore(
      id: json['_id'],
      userid: json['userid'],
      storeid: json['storeid'],
      rate: _parseInt(json['rate']),
      commentstore: json['commentstore'],
      state: json['state'],
      name: json['name'],
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userid,
      'storeid': storeid,
      'rate': rate,
      'commentstore': commentstore,
      'state': state,
      'name': name,
      'picture': picture,
    };
  }

  CommentStore copyWith({
    String? id,
    String? userid,
    String? storeid,
    int? rate,
    String? commentstore,
    String? state,
    String? name,
    String? picture,
  }) {
    return CommentStore(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      storeid: storeid ?? this.storeid,
      rate: rate ?? this.rate,
      commentstore: commentstore ?? this.commentstore,
      state: state ?? this.state,
      name: name ?? this.name,
      picture: picture ?? this.picture,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    } else {
      return 0;
    }
  }
}

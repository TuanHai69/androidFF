class CommentStore {
  final String id;
  final String userid;
  final String storeid;
  final int rate;
  final String commentstore;
  final String state;

  CommentStore({
    required this.id,
    required this.userid,
    required this.storeid,
    required this.rate,
    required this.commentstore,
    required this.state,
  });

  factory CommentStore.fromJson(Map<String, dynamic> json) {
    return CommentStore(
      id: json['_id'],
      userid: json['userid'],
      storeid: json['storeid'],
      rate: json['rate'],
      commentstore: json['commentstore'],
      state: json['state'],
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
    };
  }

  CommentStore copyWith({
    String? id,
    String? userid,
    String? storeid,
    int? rate,
    String? commentstore,
    String? state,
  }) {
    return CommentStore(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      storeid: storeid ?? this.storeid,
      rate: rate ?? this.rate,
      commentstore: commentstore ?? this.commentstore,
      state: state ?? this.state,
    );
  }
}

class Comment {
  final String id;
  final String userid;
  final String productid;
  final int rate;
  final String comment;
  final String state;

  Comment({
    required this.id,
    required this.userid,
    required this.productid,
    required this.rate,
    required this.comment,
    required this.state,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      userid: json['userid'],
      productid: json['productid'],
      rate: json['rate'],
      comment: json['comment'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userid,
      'productid': productid,
      'rate': rate,
      'comment': comment,
      'state': state,
    };
  }

  Comment copyWith({
    String? id,
    String? userid,
    String? productid,
    int? rate,
    String? comment,
    String? state,
  }) {
    return Comment(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      productid: productid ?? this.productid,
      rate: rate ?? this.rate,
      comment: comment ?? this.comment,
      state: state ?? this.state,
    );
  }
}

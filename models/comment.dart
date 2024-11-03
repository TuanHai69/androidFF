class Comment {
  final String id;
  final String userid;
  final String productid;
  final int rate;
  final String comment;
  final String state;
  final String? name; // Nullable
  final String? picture; // Nullable

  Comment({
    required this.id,
    required this.userid,
    required this.productid,
    required this.rate,
    required this.comment,
    required this.state,
    this.name,
    this.picture,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      userid: json['userid'],
      productid: json['productid'],
      rate: _parseInt(json['rate']),
      comment: json['comment'],
      state: json['state'],
      name: json['name'],
      picture: json['picture'],
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
      'name': name,
      'picture': picture,
    };
  }

  Comment copyWith({
    String? id,
    String? userid,
    String? productid,
    int? rate,
    String? comment,
    String? state,
    String? name,
    String? picture,
  }) {
    return Comment(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      productid: productid ?? this.productid,
      rate: rate ?? this.rate,
      comment: comment ?? this.comment,
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

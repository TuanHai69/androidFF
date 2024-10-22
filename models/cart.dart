class Cart {
  final String id;
  final String userid;
  final String productid;
  final int count;
  final String note;
  final double discount;
  final String storeid;
  final String state;

  Cart({
    required this.id,
    required this.userid,
    required this.productid,
    required this.count,
    required this.note,
    required this.discount,
    required this.storeid,
    required this.state,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'],
      userid: json['userid'],
      productid: json['productid'],
      count: json['count'],
      note: json['note'],
      discount: json['discount'],
      storeid: json['storeid'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userid,
      'productid': productid,
      'count': count,
      'note': note,
      'discount': discount,
      'storeid': storeid,
      'state': state,
    };
  }

  Cart copyWith({
    String? id,
    String? userid,
    String? productid,
    int? count,
    String? note,
    double? discount,
    String? storeid,
    String? state,
  }) {
    return Cart(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      productid: productid ?? this.productid,
      count: count ?? this.count,
      note: note ?? this.note,
      discount: discount ?? this.discount,
      storeid: storeid ?? this.storeid,
      state: state ?? this.state,
    );
  }
}

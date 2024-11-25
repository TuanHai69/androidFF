class Cart {
  final String id;
  final String userid;
  final String productid;
  final int count;
  final String? payment; // có thể null
  final String note;
  final int discount;
  final String? phonenumber; // có thể null
  final String? address; // có thể null
  final String? day; // có thể null
  final String storeid;
  final String? orderid; // có thể null
  final String state;

  Cart({
    required this.id,
    required this.userid,
    required this.productid,
    required this.count,
    this.payment, // có thể null
    required this.note,
    required this.discount,
    this.phonenumber, // có thể null
    this.address, // có thể null
    this.day, // có thể null
    required this.storeid,
    this.orderid, // có thể null
    required this.state,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'] ?? '',
      userid: json['userid'] ?? '',
      productid: json['productid'] ?? '',
      count: _parseInt(json['count'] ?? 0),
      payment: json['payment'], // có thể null
      note: json['note'] ?? '',
      discount: _parseInt(json['discount'] ?? 0),
      phonenumber: json['phonenumber'], // có thể null
      address: json['address'], // có thể null
      day: json['day'], // có thể null
      storeid: json['storeid'] ?? '',
      orderid: json['orderid'], // có thể null
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userid,
      'productid': productid,
      'count': count,
      'payment': payment, // có thể null
      'note': note,
      'discount': discount,
      'phonenumber': phonenumber, // có thể null
      'address': address, // có thể null
      'day': day, // có thể null
      'storeid': storeid,
      'orderid': orderid, // có thể null
      'state': state,
    };
  }

  Cart copyWith({
    String? id,
    String? userid,
    String? productid,
    int? count,
    String? payment, // có thể null
    String? note,
    int? discount,
    String? phonenumber, // có thể null
    String? address, // có thể null
    String? day, // có thể null
    String? storeid,
    String? orderid, // có thể null
    String? state,
  }) {
    return Cart(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      productid: productid ?? this.productid,
      count: count ?? this.count,
      payment: payment ?? this.payment, // có thể null
      note: note ?? this.note,
      discount: discount ?? this.discount,
      phonenumber: phonenumber ?? this.phonenumber, // có thể null
      address: address ?? this.address, // có thể null
      day: day ?? this.day, // có thể null
      storeid: storeid ?? this.storeid,
      orderid: orderid ?? this.orderid, // có thể null
      state: state ?? this.state,
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

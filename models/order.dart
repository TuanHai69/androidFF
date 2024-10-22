class Order {
  final String id;
  final String userid;
  final double price;
  final String note;
  final String storeid;
  final DateTime date;
  final String state;

  Order({
    required this.id,
    required this.userid,
    required this.price,
    required this.note,
    required this.storeid,
    required this.date,
    required this.state,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      userid: json['userid'],
      price: json['price'],
      note: json['note'],
      storeid: json['storeid'],
      date: DateTime.parse(json['date']),
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userid,
      'price': price,
      'note': note,
      'storeid': storeid,
      'date': date.toIso8601String(),
      'state': state,
    };
  }

  Order copyWith({
    String? id,
    String? userid,
    double? price,
    String? note,
    String? storeid,
    DateTime? date,
    String? state,
  }) {
    return Order(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      price: price ?? this.price,
      note: note ?? this.note,
      storeid: storeid ?? this.storeid,
      date: date ?? this.date,
      state: state ?? this.state,
    );
  }
}

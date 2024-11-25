class Order {
  final String id;
  final String userid;
  final int price;
  final String? note; // Cập nhật kiểu dữ liệu cho phép null
  final String storeid;
  final DateTime date;
  final String state;

  Order({
    required this.id,
    required this.userid,
    required this.price,
    this.note, // Cập nhật kiểu dữ liệu cho phép null
    required this.storeid,
    required this.date,
    required this.state,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      userid: json['userid'] ?? '',
      price: json['price'] is int ? json['price'] : int.parse(json['price']),
      note: json['note'], // Cho phép giá trị null
      storeid: json['storeid'] ?? '',
      date: DateTime.parse(json['date']),
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userid,
      'price': price,
      'note': note, // Cho phép giá trị null
      'storeid': storeid,
      'date': date.toIso8601String(),
      'state': state,
    };
  }

  Order copyWith({
    String? id,
    String? userid,
    int? price,
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

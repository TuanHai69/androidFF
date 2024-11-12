class Price {
  final String id;
  final DateTime daystart;
  final DateTime? dayend;
  final int price;
  final int? discount;
  final String productid;

  Price({
    required this.id,
    required this.daystart,
    this.dayend,
    required this.price,
    this.discount,
    required this.productid,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['_id'],
      daystart: DateTime.parse(json['daystart']),
      dayend: json['dayend'] != null ? DateTime.parse(json['dayend']) : null,
      price: _parseInt(json['price']),
      discount: _parseNullableInt(json['discount']),
      productid: json['productid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'daystart': daystart.toIso8601String(),
      'dayend': dayend?.toIso8601String(),
      'price': price,
      'discount': discount,
      'productid': productid,
    };
  }

  Price copyWith({
    String? id,
    DateTime? daystart,
    DateTime? dayend,
    int? price,
    int? discount,
    String? productid,
  }) {
    return Price(
      id: id ?? this.id,
      daystart: daystart ?? this.daystart,
      dayend: dayend ?? this.dayend,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      productid: productid ?? this.productid,
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

  static int? _parseNullableInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value);
    } else {
      return null;
    }
  }
}

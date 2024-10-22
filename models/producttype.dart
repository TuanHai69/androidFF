class ProductType {
  final String id;
  final String productid;
  final String typeid;
  final String state;

  ProductType({
    required this.id,
    required this.productid,
    required this.typeid,
    required this.state,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['_id'],
      productid: json['productid'],
      typeid: json['typeid'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productid': productid,
      'typeid': typeid,
      'state': state,
    };
  }

  ProductType copyWith({
    String? id,
    String? productid,
    String? typeid,
    String? state,
  }) {
    return ProductType(
      id: id ?? this.id,
      productid: productid ?? this.productid,
      typeid: typeid ?? this.typeid,
      state: state ?? this.state,
    );
  }
}

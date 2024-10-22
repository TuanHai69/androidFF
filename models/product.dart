class Product {
  final String id;
  final String name;
  final double cost;
  final String picture;
  final String material;
  final String size;
  final String description;
  final String warranty;
  final String delivery;
  final double discount;
  final String storeid;
  final String state;
  final int count;

  Product({
    required this.id,
    required this.name,
    required this.cost,
    required this.picture,
    required this.material,
    required this.size,
    required this.description,
    required this.warranty,
    required this.delivery,
    required this.discount,
    required this.storeid,
    required this.state,
    required this.count,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      cost: json['cost'],
      picture: json['picture'],
      material: json['material'],
      size: json['size'],
      description: json['description'],
      warranty: json['warranty'],
      delivery: json['delivery'],
      discount: json['discount'],
      storeid: json['storeid'],
      state: json['state'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'cost': cost,
      'picture': picture,
      'material': material,
      'size': size,
      'description': description,
      'warranty': warranty,
      'delivery': delivery,
      'discount': discount,
      'storeid': storeid,
      'state': state,
      'count': count,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? cost,
    String? picture,
    String? material,
    String? size,
    String? description,
    String? warranty,
    String? delivery,
    double? discount,
    String? storeid,
    String? state,
    int? count,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      picture: picture ?? this.picture,
      material: material ?? this.material,
      size: size ?? this.size,
      description: description ?? this.description,
      warranty: warranty ?? this.warranty,
      delivery: delivery ?? this.delivery,
      discount: discount ?? this.discount,
      storeid: storeid ?? this.storeid,
      state: state ?? this.state,
      count: count ?? this.count,
    );
  }
}

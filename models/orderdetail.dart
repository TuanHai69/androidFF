class OrderDetail {
  final String id;
  final String orderid;
  final String name;
  final double cost;
  final int count;
  final String picture;
  final String material;
  final String size;
  final String warranty;
  final String payment;
  final String phonenumber;
  final String address;
  final String description;
  final String state;

  OrderDetail({
    required this.id,
    required this.orderid,
    required this.name,
    required this.cost,
    required this.count,
    required this.picture,
    required this.material,
    required this.size,
    required this.warranty,
    required this.payment,
    required this.phonenumber,
    required this.address,
    required this.description,
    required this.state,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['_id'],
      orderid: json['orderid'],
      name: json['name'],
      cost: json['cost'],
      count: json['count'],
      picture: json['picture'],
      material: json['material'],
      size: json['size'],
      warranty: json['warranty'],
      payment: json['payment'],
      phonenumber: json['phonenumber'],
      address: json['address'],
      description: json['description'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderid': orderid,
      'name': name,
      'cost': cost,
      'count': count,
      'picture': picture,
      'material': material,
      'size': size,
      'warranty': warranty,
      'payment': payment,
      'phonenumber': phonenumber,
      'address': address,
      'description': description,
      'state': state,
    };
  }

  OrderDetail copyWith({
    String? id,
    String? orderid,
    String? name,
    double? cost,
    int? count,
    String? picture,
    String? material,
    String? size,
    String? warranty,
    String? payment,
    String? phonenumber,
    String? address,
    String? description,
    String? state,
  }) {
    return OrderDetail(
      id: id ?? this.id,
      orderid: orderid ?? this.orderid,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      count: count ?? this.count,
      picture: picture ?? this.picture,
      material: material ?? this.material,
      size: size ?? this.size,
      warranty: warranty ?? this.warranty,
      payment: payment ?? this.payment,
      phonenumber: phonenumber ?? this.phonenumber,
      address: address ?? this.address,
      description: description ?? this.description,
      state: state ?? this.state,
    );
  }
}

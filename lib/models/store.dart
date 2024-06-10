class Store {
  String? id;
  String? name;
  String? shortName;
  String? status;
  String? email;
  String? phone;
  String? code;
  String? organizationId;
  String? brandId;
  String? address;

  Store({
    this.id,
    this.name,
    this.shortName,
    this.status,
    this.email,
    this.phone,
    this.code,
    this.organizationId,
    this.brandId,
    this.address,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      shortName: json['shortName'],
      status: json['status'],
      email: json['email'],
      phone: json['phone'],
      code: json['code'],
      organizationId: json['organizationId'],
      brandId: json['brandId'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'status': status,
      'email': email,
      'phone': phone,
      'code': code,
      'organizationId': organizationId,
      'brandId': brandId,
      'address': address,
    };
  }
}

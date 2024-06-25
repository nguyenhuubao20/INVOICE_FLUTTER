class Organization {
  final String? id;
  final String? name;
  final String? address;
  final String? representative;
  final String? taxCode;
  final String? brandId;
  final String? brandName;
  final String? code;

  Organization({
    this.id,
    this.name,
    this.address,
    this.representative,
    this.taxCode,
    this.brandId,
    this.brandName,
    this.code,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      representative: json['representative'],
      taxCode: json['taxCode'],
      brandId: json['brandId'],
      brandName: json['brandName'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'representative': representative,
      'taxCode': taxCode,
      'brandId': brandId,
      'brandName': brandName,
      'code': code,
    };
  }
}

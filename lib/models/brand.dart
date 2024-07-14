class Brand {
  final String id;
  final String name;
  final String address;
  final String representative;
  final String taxCode;
  final String brandId;
  final String brandName;
  final String? code;

  Brand({
    required this.id,
    required this.name,
    required this.address,
    required this.representative,
    required this.taxCode,
    required this.brandId,
    required this.brandName,
    this.code,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
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

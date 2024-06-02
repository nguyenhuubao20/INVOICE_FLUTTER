class Account {
  String accessToken;
  String id;
  String? username;
  String? name;
  int? role;
  int? status;
  String? brandName;
  String? brandId;

  Account({
    required this.accessToken,
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    required this.status,
    required this.brandName,
    required this.brandId,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accessToken: json['accessToken'],
      id: json['id'],
      username: json['username'],
      name: json['name'],
      role: json['role'],
      status: json['status'],
      brandName: json['brandName'],
      brandId: json['brandId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'status': status,
      'brandName': brandName,
      'brandId': brandId,
    };
  }
}

class User {
  final String? id;
  final String? username;
  final String? name;
  final int? role;
  final int? status;
  final String? storeId;
  final String? storeCode;
  final String? brandId;
  final String? brandCode;

  User({
    this.id,
    this.username,
    this.name,
    this.role,
    this.status,
    this.storeId,
    this.storeCode,
    this.brandId,
    this.brandCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      role: json['role'],
      status: json['status'],
      storeId: json['storeId'],
      storeCode: json['storeCode'],
      brandId: json['brandId'],
      brandCode: json['brandCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'status': status,
      'storeId': storeId,
      'storeCode': storeCode,
      'brandId': brandId,
      'brandCode': brandCode,
    };
  }
}

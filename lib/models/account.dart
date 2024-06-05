class Account {
  String? accessToken;
  String? id;
  String? username;
  String? name;
  int? role;
  int? status;
  String? brandCode;
  String? brandId;
  String? organizationId;
  String? organizationCode;

  Account({
    this.accessToken,
    this.id,
    this.username,
    this.name,
    this.role,
    this.status,
    this.brandCode,
    this.brandId,
    this.organizationId,
    this.organizationCode,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accessToken: json['accessToken'],
      id: json['id'],
      username: json['username'],
      name: json['name'],
      role: json['role'],
      status: json['status'],
      brandId: json['brandId'],
      brandCode: json['brandCode'],
      organizationId: json['organizationId'],
      organizationCode: json['organizationCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'status': status,
      'brandId': brandId,
      'brandCode': brandCode,
      'organizationId': organizationId,
      'organizationCode': organizationCode,
    };
  }
}

class Account {
  String id;
  String name;
  String password;
  String status;
  String roleId;
  String userName;
  String? brandId;

  Account({
    required this.id,
    required this.name,
    required this.password,
    required this.status,
    required this.roleId,
    required this.userName,
    this.brandId,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      password: json['password'],
      status: json['status'],
      roleId: json['roleId'],
      userName: json['userName'],
      brandId: json['brandId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'status': status,
      'roleId': roleId,
      'userName': userName,
      'brandId': brandId,
    };
  }
}

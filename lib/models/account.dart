class Account {
  String accessToken;
  String id;
  String username;
  String name;
  int role;
  int status;
  String brandName;

  Account({
    required this.accessToken,
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    required this.status,
    required this.brandName,
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
    };
  }
}

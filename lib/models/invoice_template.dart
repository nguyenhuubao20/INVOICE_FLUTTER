class InvoiceTemplate {
  String? id;
  String? name;
  String? code;
  String? taxCode;
  String? descriptions;
  int? status;
  String? secretKey;

  InvoiceTemplate({
    this.id,
    this.name,
    this.code,
    this.taxCode,
    this.descriptions,
    this.status,
    this.secretKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'taxcode': taxCode,
      'descriptions': descriptions,
      'status': status,
      'secretKey': secretKey,
    };
  }

  factory InvoiceTemplate.fromJson(Map<String, dynamic> json) {
    return InvoiceTemplate(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      taxCode: json['taxcode'],
      descriptions: json['descriptions'],
      status: json['status'],
      secretKey: json['secretKey'],
    );
  }
}

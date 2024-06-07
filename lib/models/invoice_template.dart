class InvoiceTemplate {
  String? id;
  String? organizationId;
  String? organizationName;
  String? templateName;
  int? templateType;
  String? invSeries;
  int? invoiceType;
  int? status;

  InvoiceTemplate(
      {this.id,
      this.organizationId,
      this.organizationName,
      this.templateName,
      this.templateType,
      this.invSeries,
      this.invoiceType,
      this.status});

  InvoiceTemplate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organizationId'];
    organizationName = json['organizationName'];
    templateName = json['templateName'];
    templateType = json['templateType'];
    invSeries = json['invSeries'];
    invoiceType = json['invoiceType'];
    status = json['status'];
  }

  factory InvoiceTemplate.fromJsonFactory(Map<String, dynamic> json) {
    return InvoiceTemplate(
      id: json['id'],
      organizationId: json['organizationId'],
      organizationName: json['organizationName'],
      templateName: json['templateName'],
      templateType: json['templateType'],
      invSeries: json['invSeries'],
      invoiceType: json['invoiceType'],
      status: json['status'],
    );
  }
}

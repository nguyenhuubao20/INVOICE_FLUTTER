class InvoiceHistoryPartner {
  final String id;
  final String invoiceId;
  final String invoiceCode;
  final VnPayInvoiceStatus vnPayInvoiceStatus;
  final String config;
  final DateTime createDate;
  final String partnerCode;

  InvoiceHistoryPartner({
    required this.id,
    required this.invoiceId,
    required this.invoiceCode,
    required this.vnPayInvoiceStatus,
    required this.config,
    required this.createDate,
    required this.partnerCode,
  });

  factory InvoiceHistoryPartner.fromJson(Map<String, dynamic> json) {
    return InvoiceHistoryPartner(
      id: json['id'],
      invoiceId: json['invoiceId'],
      invoiceCode: json['invoiceCode'],
      vnPayInvoiceStatus:
          VnPayInvoiceStatus.fromJson(json['vnPayInvoiceStatus']),
      config: json['config'],
      createDate: DateTime.parse(json['createDate']),
      partnerCode: json['partnerCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'invoiceCode': invoiceCode,
      'vnPayInvoiceStatus': vnPayInvoiceStatus.toJson(),
      'config': config,
      'createDate': createDate.toIso8601String(),
      'partnerCode': partnerCode,
    };
  }
}

class VnPayInvoiceStatus {
  final int tvanStatus;
  final String status;
  final String invoiceStatus;

  VnPayInvoiceStatus({
    required this.tvanStatus,
    required this.status,
    required this.invoiceStatus,
  });

  factory VnPayInvoiceStatus.fromJson(Map<String, dynamic> json) {
    return VnPayInvoiceStatus(
      tvanStatus: json['tvanStatus'],
      status: json['status'],
      invoiceStatus: json['invoiceStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tvanStatus': tvanStatus,
      'status': status,
      'invoiceStatus': invoiceStatus,
    };
  }
}

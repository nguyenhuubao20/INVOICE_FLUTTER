class Invoice {
  String? id;
  String? invoiceCode;
  DateTime? createdDate;
  DateTime? updatedDate;
  int? type;
  int? status;
  String? paymentMethod;
  String? currencyCode;
  double? exchangeRate;
  double? discountRate;
  double? vatRate;
  double? totalSaleAmount;
  double? totalDiscountAmount;
  double? totalAmountWithoutVat;
  double? totalVatAmount;
  double? totalAmount;
  int? paymentStatus;
  String? templateId;
  List<InvoiceDetail>? invoiceDetail;
  String? partnerId;
  String? storeId;

  Invoice({
    this.id,
    this.invoiceCode,
    this.createdDate,
    this.updatedDate,
    this.type,
    this.status,
    this.paymentMethod,
    this.currencyCode,
    this.exchangeRate,
    this.discountRate,
    this.vatRate,
    this.totalSaleAmount,
    this.totalDiscountAmount,
    this.totalAmountWithoutVat,
    this.totalVatAmount,
    this.totalAmount,
    this.paymentStatus,
    this.templateId,
    this.invoiceDetail,
    this.partnerId,
    this.storeId,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceCode: json['invoiceCode'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      type: json['type'],
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      currencyCode: json['currencyCode'],
      exchangeRate: (json['exchangeRate'] as num?)?.toDouble(),
      discountRate: (json['discountRate'] as num?)?.toDouble(),
      vatRate: (json['vatRate'] as num?)?.toDouble(),
      totalSaleAmount: (json['totalSaleAmount'] as num?)?.toDouble(),
      totalDiscountAmount: (json['totalDiscountAmount'] as num?)?.toDouble(),
      totalAmountWithoutVat: (json['totalAmountWithoutVat'] as num?)?.toDouble(),
      totalVatAmount: (json['totalVatAmount'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      paymentStatus: json['paymentStatus'],
      templateId: json['templateId'],
      invoiceDetail: (json['invoiceDetail'] as List<dynamic>?)
          ?.map((e) => InvoiceDetail.fromJson(e))
          .toList(),
      partnerId: json['partnerId'],
      storeId: json['storeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceCode': invoiceCode,
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'type': type,
      'status': status,
      'paymentMethod': paymentMethod,
      'currencyCode': currencyCode,
      'exchangeRate': exchangeRate,
      'discountRate': discountRate,
      'vatRate': vatRate,
      'totalSaleAmount': totalSaleAmount,
      'totalDiscountAmount': totalDiscountAmount,
      'totalAmountWithoutVat': totalAmountWithoutVat,
      'totalVatAmount': totalVatAmount,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'templateId': templateId,
      'invoiceDetail': invoiceDetail?.map((e) => e.toJson()).toList(),
      'partnerId': partnerId,
      'storeId': storeId,
    };
  }
}

class InvoiceDetail {
  int? itemType;
  int? lineNumber;
  int? sortOrder;
  String? itemCode;
  String? itemName;
  String? unitName;
  double? quantity;
  double? unitPrice;
  double? discountRate;
  double? discountAmountOC;
  double? discountAmount;
  double? amountOC;
  double? amount;
  double? amountWithoutVATOC;
  double? amountWithoutVAT;
  String? vatRateName;
  double? vatAmountOC;
  double? vatAmount;

  InvoiceDetail({
    this.itemType,
    this.lineNumber,
    this.sortOrder,
    this.itemCode,
    this.itemName,
    this.unitName,
    this.quantity,
    this.unitPrice,
    this.discountRate,
    this.discountAmountOC,
    this.discountAmount,
    this.amountOC,
    this.amount,
    this.amountWithoutVATOC,
    this.amountWithoutVAT,
    this.vatRateName,
    this.vatAmountOC,
    this.vatAmount,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) {
    return InvoiceDetail(
      itemType: json['itemType'],
      lineNumber: json['lineNumber'],
      sortOrder: json['sortOrder'],
      itemCode: json['itemCode'],
      itemName: json['itemName'],
      unitName: json['unitName'],
      quantity: (json['quantity'] as num?)?.toDouble(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      discountRate: (json['discountRate'] as num?)?.toDouble(),
      discountAmountOC: (json['discountAmountOC'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      amountOC: (json['amountOC'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      amountWithoutVATOC: (json['amountWithoutVATOC'] as num?)?.toDouble(),
      amountWithoutVAT: (json['amountWithoutVAT'] as num?)?.toDouble(),
      vatRateName: json['vatRateName'],
      vatAmountOC: (json['vatAmountOC'] as num?)?.toDouble(),
      vatAmount: (json['vatAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemType': itemType,
      'lineNumber': lineNumber,
      'sortOrder': sortOrder,
      'itemCode': itemCode,
      'itemName': itemName,
      'unitName': unitName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discountRate': discountRate,
      'discountAmountOC': discountAmountOC,
      'discountAmount': discountAmount,
      'amountOC': amountOC,
      'amount': amount,
      'amountWithoutVATOC': amountWithoutVATOC,
      'amountWithoutVAT': amountWithoutVAT,
      'vatRateName': vatRateName,
      'vatAmountOC': vatAmountOC,
      'vatAmount': vatAmount,
    };
  }
}

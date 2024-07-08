class InvoiceResponse {
  int? size;
  int? page;
  int? total;
  int? totalPages;
  List<Invoice>? items;

  InvoiceResponse(
      {this.size, this.page, this.total, this.totalPages, this.items});

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      size: json['size'],
      page: json['page'],
      total: json['total'],
      totalPages: json['totalPages'],
      items: json['items'] != null
          ? List<Invoice>.from(json['items'].map((i) => Invoice.fromJson(i)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'page': page,
      'total': total,
      'totalPages': totalPages,
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }
}

class Invoice {
  String? id;
  String? invoiceCode;
  String? createdDate;
  String? lookupCode;
  int? type;
  int? status;
  String? paymentMethod;
  String? currencyUnit;
  double? currencyExchangeRate;
  double? totalTaxAmount;
  double? totalAmountAfterTax;
  double? totalSaleAmount;
  double? totalDiscountAmount;
  double? totalAmountWithoutTax;
  double? totalAmount;
  String? billCode;
  String? templateId;
  String? partnerId;
  String? storeId;
  InvoiceDetail? invoiceDetail;
  List<Item>? items;
  List<TaxType>? taxTypes;
  ResponsePartner? responsePartNer;

  Invoice({
    this.id,
    this.invoiceCode,
    this.createdDate,
    this.lookupCode,
    this.type,
    this.status,
    this.paymentMethod,
    this.currencyUnit,
    this.currencyExchangeRate,
    this.totalTaxAmount,
    this.totalAmountAfterTax,
    this.totalSaleAmount,
    this.totalDiscountAmount,
    this.totalAmountWithoutTax,
    this.totalAmount,
    this.billCode,
    this.templateId,
    this.partnerId,
    this.storeId,
    this.invoiceDetail,
    this.items,
    this.taxTypes,
    this.responsePartNer,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceCode: json['invoiceCode'],
      createdDate: json['createdDate'],
      lookupCode: json['lookupCode'],
      type: json['type'],
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      currencyUnit: json['currencyUnit'],
      currencyExchangeRate: json['currencyExchangeRate'],
      totalTaxAmount: json['totalTaxAmount'],
      totalAmountAfterTax: json['totalAmountAfterTax'],
      totalSaleAmount: json['totalSaleAmount'],
      totalDiscountAmount: json['totalDiscountAmount'],
      totalAmountWithoutTax: json['totalAmountWithoutTax'],
      totalAmount: json['totalAmount'],
      billCode: json['billCode'],
      templateId: json['templateId'],
      partnerId: json['partnerId'],
      storeId: json['storeId'],
      invoiceDetail: InvoiceDetail.fromJson(json['invoiceDetail']),
      items: List<Item>.from(json['items'].map((i) => Item.fromJson(i))),
      taxTypes:
          List<TaxType>.from(json['taxTypes'].map((i) => TaxType.fromJson(i))),
      responsePartNer: json['responsePartNer'] != null
          ? ResponsePartner.fromJson(json['responsePartNer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceCode': invoiceCode,
      'createdDate': createdDate,
      'lookupCode': lookupCode,
      'type': type,
      'status': status,
      'paymentMethod': paymentMethod,
      'currencyUnit': currencyUnit,
      'currencyExchangeRate': currencyExchangeRate,
      'totalTaxAmount': totalTaxAmount,
      'totalAmountAfterTax': totalAmountAfterTax,
      'totalSaleAmount': totalSaleAmount,
      'totalDiscountAmount': totalDiscountAmount,
      'totalAmountWithoutTax': totalAmountWithoutTax,
      'totalAmount': totalAmount,
      'billCode': billCode,
      'templateId': templateId,
      'partnerId': partnerId,
      'storeId': storeId,
      'invoiceDetail': invoiceDetail?.toJson(),
      'items': items?.map((e) => e.toJson()).toList(),
      'taxTypes': taxTypes?.map((e) => e.toJson()).toList(),
      'responsePartNer': responsePartNer?.toJson(),
    };
  }
}

class InvoiceDetail {
  String? receiptCode;
  String? buyerCustomerCode;
  String? buyerTaxCode;
  String? buyerName;
  String? buyerAddress;
  String? buyerFullName;
  String? buyerPhoneNumber;
  String? buyerEmail;
  String? buyerBankName;
  String? buyerBankAccountNumber;
  String? invoiceNote;
  String? internalNote;
  bool? discount;
  String? code;
  int? quantity;
  int? totalAmount;
  int? discountAmount;
  int? finalAmount;

  InvoiceDetail({
    this.receiptCode,
    this.buyerCustomerCode,
    this.buyerTaxCode,
    this.buyerName,
    this.buyerAddress,
    this.buyerFullName,
    this.buyerPhoneNumber,
    this.buyerEmail,
    this.buyerBankName,
    this.buyerBankAccountNumber,
    this.invoiceNote,
    this.internalNote,
    this.discount,
    this.code,
    this.quantity,
    this.totalAmount,
    this.discountAmount,
    this.finalAmount,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) {
    return InvoiceDetail(
      receiptCode: json['receiptCode'],
      buyerCustomerCode: json['buyerCustomerCode'],
      buyerTaxCode: json['buyerTaxCode'],
      buyerName: json['buyerName'],
      buyerAddress: json['buyerAddress'],
      buyerFullName: json['buyerFullName'],
      buyerPhoneNumber: json['buyerPhoneNumber'],
      buyerEmail: json['buyerEmail'],
      buyerBankName: json['buyerBankName'],
      buyerBankAccountNumber: json['buyerBankAccountNumber'],
      invoiceNote: json['invoiceNote'],
      internalNote: json['internalNote'],
      discount: json['discount'],
      code: json['code'],
      quantity: json['quantity'],
      totalAmount: json['totalAmount'],
      discountAmount: json['discountAmount'],
      finalAmount: json['finalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiptCode': receiptCode,
      'buyerCustomerCode': buyerCustomerCode,
      'buyerTaxCode': buyerTaxCode,
      'buyerName': buyerName,
      'buyerAddress': buyerAddress,
      'buyerFullName': buyerFullName,
      'buyerPhoneNumber': buyerPhoneNumber,
      'buyerEmail': buyerEmail,
      'buyerBankName': buyerBankName,
      'buyerBankAccountNumber': buyerBankAccountNumber,
      'invoiceNote': invoiceNote,
      'internalNote': internalNote,
      'discount': discount,
      'code': code,
      'quantity': quantity,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'finalAmount': finalAmount,
    };
  }
}

class Item {
  int? ordinalNumber;
  String? code;
  String? name;
  int? quantity;
  String? property;
  String? unit;
  double price;
  int? discountRate;
  double? discountAmount;
  double? amountWithoutDiscount;
  double? amount;
  double? taxAmount;
  double? amountAfterTax;
  String? tax;
  Item({
    required this.ordinalNumber,
    this.code,
    this.name,
    this.quantity,
    this.property,
    this.unit,
    required this.price,
    this.discountRate,
    this.discountAmount,
    this.amountWithoutDiscount,
    this.amount,
    this.taxAmount,
    this.amountAfterTax,
    this.tax,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      ordinalNumber: json['ordinalNumber'],
      code: json['code'],
      name: json['name'],
      quantity: json['quantity'],
      property: json['property'],
      unit: json['unit'],
      price: json['price'],
      discountRate: json['discountRate'],
      discountAmount: json['discountAmount'],
      amountWithoutDiscount: json['amountWithoutDiscount'],
      amount: json['amount'],
      taxAmount: json['taxAmount'],
      amountAfterTax: json['amountAfterTax'],
      tax: json['tax'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ordinalNumber': ordinalNumber,
      'code': code,
      'name': name,
      'quantity': quantity,
      'property': property,
      'unit': unit,
      'price': price,
      'discountRate': discountRate,
      'discountAmount': discountAmount,
      'amountWithoutDiscount': amountWithoutDiscount,
      'amount': amount,
      'taxAmount': taxAmount,
      'amountAfterTax': amountAfterTax,
      'tax': tax,
    };
  }
}

class TaxType {
  String? tax;
  double? amountWithoutTax;
  double? taxAmount;

  TaxType({
    this.tax,
    this.amountWithoutTax,
    this.taxAmount,
  });

  factory TaxType.fromJson(Map<String, dynamic> json) {
    return TaxType(
      tax: json['tax'],
      amountWithoutTax: json['amountWithoutTax'],
      taxAmount: json['taxAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tax': tax,
      'amountWithoutTax': amountWithoutTax,
      'taxAmount': taxAmount,
    };
  }
}

class ResponsePartner {
  String? code;
  String? message;
  ResponsePartNerData? data;

  ResponsePartner({
    this.code,
    this.message,
    this.data,
  });

  factory ResponsePartner.fromJson(Map<String, dynamic> json) {
    return ResponsePartner(
      code: json['code'],
      message: json['message'],
      data: json['data'] != null
          ? ResponsePartNerData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ResponsePartNerData {
  String? requestId;
  String? invoiceNumber;
  String? invoiceSymbol;
  int? invoiceType;
  String? invoiceCreatedDate;
  String? taxAuthorityCode;
  String? lookupCode;

  ResponsePartNerData({
    this.requestId,
    this.invoiceNumber,
    this.invoiceSymbol,
    this.invoiceType,
    this.invoiceCreatedDate,
    this.taxAuthorityCode,
    this.lookupCode,
  });

  factory ResponsePartNerData.fromJson(Map<String, dynamic> json) {
    return ResponsePartNerData(
      requestId: json['requestId'],
      invoiceNumber: json['invoiceNumber'],
      invoiceSymbol: json['invoiceSymbol'],
      invoiceType: json['invoiceType'],
      invoiceCreatedDate: json['invoiceCreatedDate'],
      taxAuthorityCode: json['taxAuthorityCode'],
      lookupCode: json['lookupCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'invoiceNumber': invoiceNumber,
      'invoiceSymbol': invoiceSymbol,
      'invoiceType': invoiceType,
      'invoiceCreatedDate': invoiceCreatedDate,
      'taxAuthorityCode': taxAuthorityCode,
      'lookupCode': lookupCode,
    };
  }
}

//report
class InvoiceReport {
  int? totalInvoice;
  int? totalInvoiceReportInDate;
  int? draft;
  int? success;
  int? sent;
  int? pendingApproval;
  int? completed;
  int? failed;
  int? pending;
  int? retryPending;
  int? replaced;

  InvoiceReport({
    this.totalInvoice,
    this.totalInvoiceReportInDate,
    this.draft,
    this.success,
    this.sent,
    this.pendingApproval,
    this.completed,
    this.failed,
    this.pending,
    this.retryPending,
    this.replaced,
  });

  factory InvoiceReport.fromJson(Map<String, dynamic> json) {
    return InvoiceReport(
      totalInvoice: json['totalInvoice'],
      totalInvoiceReportInDate: json['totalInvoiceReportInDate'],
      draft: json['draft'],
      success: json['success'],
      sent: json['sent'],
      pendingApproval: json['pendingApproval'],
      completed: json['completed'],
      failed: json['failed'],
      pending: json['pending'],
      retryPending: json['retryPending'],
      replaced: json['replaced'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalInvoice': totalInvoice,
      'totalInvoiceReportInDate': totalInvoiceReportInDate,
      'draft': draft,
      'success': success,
      'sent': sent,
      'pendingApproval': pendingApproval,
      'completed': completed,
      'failed': failed,
      'pending': pending,
      'retryPending': retryPending,
      'replaced': replaced,
    };
  }
}

class InvoicePaymentReport {
  int? totalInvoiceReport;
  int? totalInvoiceReportInDate;
  double? totalTaxAmountReport;
  double? totalAmountAfterTaxReport;
  double? totalSaleAmountReport;
  double? totalDiscountAmountReport;
  double? totalAmountWithoutTaxReport;
  double? totalAmountReport;

  InvoicePaymentReport({
    this.totalInvoiceReport,
    this.totalInvoiceReportInDate,
    this.totalTaxAmountReport,
    this.totalAmountAfterTaxReport,
    this.totalSaleAmountReport,
    this.totalDiscountAmountReport,
    this.totalAmountWithoutTaxReport,
    this.totalAmountReport,
  });

  factory InvoicePaymentReport.fromJson(Map<String, dynamic> json) {
    return InvoicePaymentReport(
      totalInvoiceReport: json['totalInvoiceReport'],
      totalInvoiceReportInDate: json['totalInvoiceReportInDate'],
      totalTaxAmountReport: json['totalTaxAmountReport'],
      totalAmountAfterTaxReport: json['totalAmountAfterTaxReport'],
      totalSaleAmountReport: json['totalSaleAmountReport'],
      totalDiscountAmountReport: json['totalDiscountAmountReport'],
      totalAmountWithoutTaxReport: json['totalAmountWithoutTaxReport'],
      totalAmountReport: json['totalAmountReport'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalInvoiceReport': totalInvoiceReport,
      'totalInvoiceReportInDate': totalInvoiceReportInDate,
      'totalTaxAmountReport': totalTaxAmountReport,
      'totalAmountAfterTaxReport': totalAmountAfterTaxReport,
      'totalSaleAmountReport': totalSaleAmountReport,
      'totalDiscountAmountReport': totalDiscountAmountReport,
      'totalAmountWithoutTaxReport': totalAmountWithoutTaxReport,
      'totalAmountReport': totalAmountReport,
    };
  }
}

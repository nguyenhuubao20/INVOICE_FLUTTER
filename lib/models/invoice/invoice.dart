import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable()
class Invoice {
  final String id;
  final String invoiceCode;
  final DateTime createdDate;
  @JsonKey(nullable: true)
  final String? lookupCode;
  final int type;
  final int status;
  final String paymentMethod;
  final String currencyUnit;
  final double currencyExchangeRate;
  final double totalTaxAmount;
  final double totalAmountAfterTax;
  final double totalSaleAmount;
  final double totalDiscountAmount;
  final double totalAmountWithoutTax;
  final double totalAmount;
  final String billCode;
  final String templateId;
  final String partnerId;
  final String storeId;
  final InvoiceDetail invoiceDetail;
  final List<Item> items;
  final List<TaxType> taxTypes;
  final ResponsePartner responsePartNer;

  Invoice({
    required this.id,
    required this.invoiceCode,
    required this.createdDate,
    this.lookupCode,
    required this.type,
    required this.status,
    required this.paymentMethod,
    required this.currencyUnit,
    required this.currencyExchangeRate,
    required this.totalTaxAmount,
    required this.totalAmountAfterTax,
    required this.totalSaleAmount,
    required this.totalDiscountAmount,
    required this.totalAmountWithoutTax,
    required this.totalAmount,
    required this.billCode,
    required this.templateId,
    required this.partnerId,
    required this.storeId,
    required this.invoiceDetail,
    required this.items,
    required this.taxTypes,
    required this.responsePartNer,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}

@JsonSerializable()
class InvoiceDetail {
  final String receiptCode;
  final String buyerCustomerCode;
  final String buyerTaxCode;
  final String buyerName;
  final String buyerAddress;
  final String buyerFullName;
  final String buyerPhoneNumber;
  final String buyerEmail;
  final String buyerBankName;
  final String buyerBankAccountNumber;
  final String invoiceNote;
  final String internalNote;
  final bool discount;
  final String code;
  final int quantity;
  final double totalAmount;
  final double discountAmount;
  final double finalAmount;

  InvoiceDetail({
    required this.receiptCode,
    required this.buyerCustomerCode,
    required this.buyerTaxCode,
    required this.buyerName,
    required this.buyerAddress,
    required this.buyerFullName,
    required this.buyerPhoneNumber,
    required this.buyerEmail,
    required this.buyerBankName,
    required this.buyerBankAccountNumber,
    required this.invoiceNote,
    required this.internalNote,
    required this.discount,
    required this.code,
    required this.quantity,
    required this.totalAmount,
    required this.discountAmount,
    required this.finalAmount,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceDetailToJson(this);
}

@JsonSerializable()
class Item {
  final int ordinalNumber;
  final String code;
  final String name;
  final int quantity;
  final String property;
  final String unit;
  final double price;
  final double discountRate;
  final double discountAmount;
  final double amountWithoutDiscount;
  final double amount;
  final double taxAmount;
  final double amountAfterTax;
  final String tax;

  Item({
    required this.ordinalNumber,
    required this.code,
    required this.name,
    required this.quantity,
    required this.property,
    required this.unit,
    required this.price,
    required this.discountRate,
    required this.discountAmount,
    required this.amountWithoutDiscount,
    required this.amount,
    required this.taxAmount,
    required this.amountAfterTax,
    required this.tax,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class TaxType {
  final String tax;
  final double amountWithoutTax;
  final double taxAmount;

  TaxType({
    required this.tax,
    required this.amountWithoutTax,
    required this.taxAmount,
  });

  factory TaxType.fromJson(Map<String, dynamic> json) =>
      _$TaxTypeFromJson(json);
  Map<String, dynamic> toJson() => _$TaxTypeToJson(this);
}

@JsonSerializable()
class ResponsePartner {
  final String requestId;
  final String invoiceNumber;
  final String invoiceSymbol;
  final int invoiceType;
  final DateTime invoiceCreatedDate;
  final String taxAuthorityCode;
  final String lookupCode;
  final String releaseResponseStatus;
  final String releaseResponseDescription;

  ResponsePartner({
    required this.requestId,
    required this.invoiceNumber,
    required this.invoiceSymbol,
    required this.invoiceType,
    required this.invoiceCreatedDate,
    required this.taxAuthorityCode,
    required this.lookupCode,
    required this.releaseResponseStatus,
    required this.releaseResponseDescription,
  });

  factory ResponsePartner.fromJson(Map<String, dynamic> json) =>
      _$ResponsePartnerFromJson(json);
  Map<String, dynamic> toJson() => _$ResponsePartnerToJson(this);
}

//report
class InvoiceReport {
  int? totalInvoice;
  int? pending;
  int? sent;
  int? pendingApproval;
  int? completed;
  int? failed;

  InvoiceReport({
    this.totalInvoice,
    this.pending,
    this.sent,
    this.pendingApproval,
    this.completed,
    this.failed,
  });

  factory InvoiceReport.fromJson(Map<String, dynamic> json) {
    return InvoiceReport(
      totalInvoice: json['totalInvoice'],
      pending: json['pending'],
      sent: json['sent'],
      pendingApproval: json['pendingApproval'],
      completed: json['completed'],
      failed: json['failed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalInvoice': totalInvoice,
      'pending': pending,
      'sent': sent,
      'pendingApproval': pendingApproval,
      'completed': completed,
      'failed': failed,
    };
  }
}

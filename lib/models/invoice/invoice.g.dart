// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      id: json['id'] as String,
      invoiceCode: json['invoiceCode'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      lookupCode: json['lookupCode'] as String?,
      type: (json['type'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      paymentMethod: json['paymentMethod'] as String,
      currencyUnit: json['currencyUnit'] as String,
      currencyExchangeRate: (json['currencyExchangeRate'] as num).toDouble(),
      totalTaxAmount: (json['totalTaxAmount'] as num).toDouble(),
      totalAmountAfterTax: (json['totalAmountAfterTax'] as num).toDouble(),
      totalSaleAmount: (json['totalSaleAmount'] as num).toDouble(),
      totalDiscountAmount: (json['totalDiscountAmount'] as num).toDouble(),
      totalAmountWithoutTax: (json['totalAmountWithoutTax'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      billCode: json['billCode'] as String,
      templateId: json['templateId'] as String,
      partnerId: json['partnerId'] as String,
      storeId: json['storeId'] as String,
      invoiceDetail:
          InvoiceDetail.fromJson(json['invoiceDetail'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxTypes: (json['taxTypes'] as List<dynamic>)
          .map((e) => TaxType.fromJson(e as Map<String, dynamic>))
          .toList(),
      responsePartNer: ResponsePartner.fromJson(
          json['responsePartNer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'invoiceCode': instance.invoiceCode,
      'createdDate': instance.createdDate.toIso8601String(),
      'lookupCode': instance.lookupCode,
      'type': instance.type,
      'status': instance.status,
      'paymentMethod': instance.paymentMethod,
      'currencyUnit': instance.currencyUnit,
      'currencyExchangeRate': instance.currencyExchangeRate,
      'totalTaxAmount': instance.totalTaxAmount,
      'totalAmountAfterTax': instance.totalAmountAfterTax,
      'totalSaleAmount': instance.totalSaleAmount,
      'totalDiscountAmount': instance.totalDiscountAmount,
      'totalAmountWithoutTax': instance.totalAmountWithoutTax,
      'totalAmount': instance.totalAmount,
      'billCode': instance.billCode,
      'templateId': instance.templateId,
      'partnerId': instance.partnerId,
      'storeId': instance.storeId,
      'invoiceDetail': instance.invoiceDetail,
      'items': instance.items,
      'taxTypes': instance.taxTypes,
      'responsePartNer': instance.responsePartNer,
    };

InvoiceDetail _$InvoiceDetailFromJson(Map<String, dynamic> json) =>
    InvoiceDetail(
      receiptCode: json['receiptCode'] as String,
      buyerCustomerCode: json['buyerCustomerCode'] as String,
      buyerTaxCode: json['buyerTaxCode'] as String,
      buyerName: json['buyerName'] as String,
      buyerAddress: json['buyerAddress'] as String,
      buyerFullName: json['buyerFullName'] as String,
      buyerPhoneNumber: json['buyerPhoneNumber'] as String,
      buyerEmail: json['buyerEmail'] as String,
      buyerBankName: json['buyerBankName'] as String,
      buyerBankAccountNumber: json['buyerBankAccountNumber'] as String,
      invoiceNote: json['invoiceNote'] as String,
      internalNote: json['internalNote'] as String,
      discount: json['discount'] as bool,
      code: json['code'] as String,
      quantity: (json['quantity'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      finalAmount: (json['finalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceDetailToJson(InvoiceDetail instance) =>
    <String, dynamic>{
      'receiptCode': instance.receiptCode,
      'buyerCustomerCode': instance.buyerCustomerCode,
      'buyerTaxCode': instance.buyerTaxCode,
      'buyerName': instance.buyerName,
      'buyerAddress': instance.buyerAddress,
      'buyerFullName': instance.buyerFullName,
      'buyerPhoneNumber': instance.buyerPhoneNumber,
      'buyerEmail': instance.buyerEmail,
      'buyerBankName': instance.buyerBankName,
      'buyerBankAccountNumber': instance.buyerBankAccountNumber,
      'invoiceNote': instance.invoiceNote,
      'internalNote': instance.internalNote,
      'discount': instance.discount,
      'code': instance.code,
      'quantity': instance.quantity,
      'totalAmount': instance.totalAmount,
      'discountAmount': instance.discountAmount,
      'finalAmount': instance.finalAmount,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      ordinalNumber: (json['ordinalNumber'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      property: json['property'] as String,
      unit: json['unit'] as String,
      price: (json['price'] as num).toDouble(),
      discountRate: (json['discountRate'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      amountWithoutDiscount: (json['amountWithoutDiscount'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      amountAfterTax: (json['amountAfterTax'] as num).toDouble(),
      tax: json['tax'] as String,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'ordinalNumber': instance.ordinalNumber,
      'code': instance.code,
      'name': instance.name,
      'quantity': instance.quantity,
      'property': instance.property,
      'unit': instance.unit,
      'price': instance.price,
      'discountRate': instance.discountRate,
      'discountAmount': instance.discountAmount,
      'amountWithoutDiscount': instance.amountWithoutDiscount,
      'amount': instance.amount,
      'taxAmount': instance.taxAmount,
      'amountAfterTax': instance.amountAfterTax,
      'tax': instance.tax,
    };

TaxType _$TaxTypeFromJson(Map<String, dynamic> json) => TaxType(
      tax: json['tax'] as String,
      amountWithoutTax: (json['amountWithoutTax'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$TaxTypeToJson(TaxType instance) => <String, dynamic>{
      'tax': instance.tax,
      'amountWithoutTax': instance.amountWithoutTax,
      'taxAmount': instance.taxAmount,
    };

ResponsePartner _$ResponsePartnerFromJson(Map<String, dynamic> json) =>
    ResponsePartner(
      requestId: json['requestId'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      invoiceSymbol: json['invoiceSymbol'] as String,
      invoiceType: (json['invoiceType'] as num).toInt(),
      invoiceCreatedDate: DateTime.parse(json['invoiceCreatedDate'] as String),
      taxAuthorityCode: json['taxAuthorityCode'] as String,
      lookupCode: json['lookupCode'] as String,
      releaseResponseStatus: json['releaseResponseStatus'] as String,
      releaseResponseDescription: json['releaseResponseDescription'] as String,
    );

Map<String, dynamic> _$ResponsePartnerToJson(ResponsePartner instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'invoiceNumber': instance.invoiceNumber,
      'invoiceSymbol': instance.invoiceSymbol,
      'invoiceType': instance.invoiceType,
      'invoiceCreatedDate': instance.invoiceCreatedDate.toIso8601String(),
      'taxAuthorityCode': instance.taxAuthorityCode,
      'lookupCode': instance.lookupCode,
      'releaseResponseStatus': instance.releaseResponseStatus,
      'releaseResponseDescription': instance.releaseResponseDescription,
    };

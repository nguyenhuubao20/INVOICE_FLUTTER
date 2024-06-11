import 'package:json_annotation/json_annotation.dart';

import '../models/invoice/invoice.dart';

part 'invoice_response.g.dart';

@JsonSerializable()
class InvoiceResponse {
  final int size;
  final int page;
  final int total;
  final int totalPages;
  final List<Invoice> items;

  InvoiceResponse({
    required this.size,
    required this.page,
    required this.total,
    required this.totalPages,
    required this.items,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceResponseToJson(this);
}
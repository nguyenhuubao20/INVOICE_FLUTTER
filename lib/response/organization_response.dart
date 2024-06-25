import 'package:invoice/models/organization.dart';

class OrganizationResponse {
  final int? size;
  final int? page;
  final int? total;
  final int? totalPages;
  final List<Organization>? items;

  OrganizationResponse({
    this.size,
    this.page,
    this.total,
    this.totalPages,
    this.items,
  });

  factory OrganizationResponse.fromJson(Map<String, dynamic> json) {
    return OrganizationResponse(
      size: json['size'],
      page: json['page'],
      total: json['total'],
      totalPages: json['totalPages'],
      items: (json['items'] as List<dynamic>)
          .map((e) => Organization.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'page': page,
      'total': total,
      'totalPages': totalPages,
      'items': items,
    };
  }
}

import 'package:invoice/models/invoice.dart';

import '../models/invoice_history_partner.dart';
import '../utils/request.dart';
import '../utils/share_pref.dart';

class InvoiceAPI {
  static int size = 5;
  int page = 1;

  List<Invoice> invoiceList = [];

  Future<InvoiceResponse?> getInvoicesBySystemAdmin(int currentPage) async {
    try {
      var params = {
        'page': currentPage,
        'size': size,
      };
      final res = await request.get('invoices', queryParameters: params);
      if (res.statusCode == 200) {
        return InvoiceResponse.fromJson(res.data);
      } else {
        throw Exception('Failed to load invoices: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get invoices: $e');
      return null;
    }
  }

  Future<InvoiceResponse?> getInvoicesByOrganizationAdmin(
      int currentPage, String? createDate, int? status, String? name) async {
    try {
      if (status == -1) {
        status = null;
      }

      final id = await getOrganizationId();
      var params = {
        'id': id,
        'createdDate': createDate,
        'status': status,
        'name': name,
        'page': currentPage,
        'size': size,
      };

      final res = await request.get('organizations/${id}/invoices',
          queryParameters: params);

      if (res.statusCode == 200) {
        return InvoiceResponse.fromJson(res.data);
      } else {
        throw Exception('Failed to load invoices: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get invoices: $e');
      return null;
    }
  }

  Future<InvoiceResponse?> getInvoicesByBrandAdmin(
      int currentPage, String? createDate, int? status, String? name) async {
    try {
      if (status == -1) {
        status = null;
      }
      final brandId = await getBrandId();
      var params = {
        'id': brandId,
        'createdDate': createDate,
        'status': status,
        'name': name,
        'page': currentPage,
        'size': size,
      };
      final res = await request.get('brands/${brandId}/invoices',
          queryParameters: params);
      if (res.statusCode == 200) {
        return InvoiceResponse.fromJson(res.data);
      } else {
        throw Exception('Failed to load invoices: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get invoices: $e');
      return null;
    }
  }

  Future<InvoiceResponse?> getInvoiceListByStoreId(
    int currentPage,
    String? storeId,
    String? createDate,
    int? status,
    String? name,
  ) async {
    try {
      if (status == -1) {
        status = null;
      }
      var params = {
        'id': storeId,
        'date': createDate,
        'status': status,
        'name': name,
        'page': currentPage,
        'size': size,
      };
      final res = await request.get('stores/${storeId}/invoices',
          queryParameters: params);
      if (res.statusCode == 200) {
        return InvoiceResponse.fromJson(res.data);
      } else {
        throw Exception('Failed to load invoices: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get invoices: $e');
      return null;
    }
  }

  Future<InvoiceResponse?> getInvoiceListByOrganization(
    int currentPage,
    String? organizationId,
    String? createDate,
    int? status,
    String? name,
  ) async {
    try {
      if (status == -1) {
        status = null;
      }
      var params = {
        'id': organizationId,
        'date': createDate,
        'status': status,
        'name': name,
        'page': currentPage,
        'size': size,
      };
      final res = await request.get('organizations/${organizationId}/invoices',
          queryParameters: params);
      if (res.statusCode == 200) {
        return InvoiceResponse.fromJson(res.data);
      } else {
        throw Exception('Failed to load invoices: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get invoices: $e');
      return null;
    }
  }

  Future<Invoice?> getInvoiceDetail(String invoiceId) async {
    try {
      final res = await request.get('invoices/$invoiceId');
      if (res.statusCode == 200) {
        Map<String, dynamic> json = res.data;
        Invoice invoice = Invoice.fromJson(json);
        return invoice;
      } else {
        throw Exception('Failed to load invoice detail: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get invoice detail: $e');
      return null;
    }
  }

  Future<Invoice?> approvalInvoice(String invoiceId) async {
    try {
      var params = {
        'status': 2,
      };
      final res = await request.patch('invoices/$invoiceId/update-status',
          queryParameters: params);
      if (res.statusCode == 200) {
        Map<String, dynamic> json = res.data;
        Invoice invoice = Invoice.fromJson(json);
        return invoice;
      } else {
        throw Exception('Failed to update invoice detail: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during update invoice detail: $e');
      return null;
    }
  }

  Future<InvoiceHistoryPartner?>? getInvoiceHistoryPartner(
      String invoiceId) async {
    var params = {
      'id': invoiceId,
    };
    try {
      final res = await request.get(
          'invoices/${invoiceId}/partner-invoice-history',
          queryParameters: params);
      if (res.statusCode == 200) {
        Map<String, dynamic> json = res.data;
        InvoiceHistoryPartner invoiceHistoryPartner =
            InvoiceHistoryPartner.fromJson(json);
        return invoiceHistoryPartner;
      } else {
        throw Exception('Failed to load invoice detail: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get invoice detail: $e');
      return null;
    }
  }

  // Future<List<Invoice>> getInvoiceListByStoreId(String? idStore) async {
  //   try {
  //     var params = {
  //       'page': page,
  //       'size': size,
  //     };
  //     final res = await request.get('invoices/$idStore/stores',
  //         queryParameters: params);
  //     if (res.statusCode == 200) {
  //       List<dynamic> jsonList = res.data['items'];
  //       List<Invoice> invoices =
  //           jsonList.map((json) => Invoice.fromJson(json)).toList();
  //       return invoices;
  //     } else {
  //       throw Exception('Failed to load invoices: ${res.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error during get invoices: $e');
  //     return <Invoice>[];
  //   }
  // }
}

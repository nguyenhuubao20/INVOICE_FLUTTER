import 'package:invoice/models/invoice.dart';

import '../utils/request.dart';

class InvoiceAPI {
  static int page = 1;
  static int size = 10;

  Future<List<Invoice>> getInvoices() async {
    try {
      var params = {
        'page': page,
        'size': size,
      };
      final res = await request.get('invoices', queryParameters: params);
      if (res.statusCode == 200) {
        List<dynamic> jsonList = res.data['items'];
        List<Invoice> invoices =
            jsonList.map((json) => Invoice.fromJson(json)).toList();
        return invoices;
      } else {
        throw Exception('Failed to load invoices: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get invoices: $e');
      return [];
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

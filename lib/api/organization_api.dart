import 'package:intl/intl.dart';
import 'package:invoice/models/invoice.dart';
import 'package:invoice/models/organization.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/share_pref.dart';

import '../models/store.dart';

class OrganizationAPI {
  static int page = 1;
  static int size = 10;
  List<Store> stores = [];
  List<Organization> organization = [];
  late Map<String, dynamic> invoiceReports;

  Future<List<Store>> getStoreByOrganizationId() async {
    try {
      String? organizationId = await getOrganizationId();
      var params = {
        'id': organizationId,
        'page': page,
        'size': size,
      };
      final res = await request.get('organizations/$organizationId/stores',
          queryParameters: params);
      if (res.statusCode == 200) {
        List<dynamic> jsonList = res.data['items'];
        List<Store> storesList =
            jsonList.map((json) => Store.fromJson(json)).toList();
        stores = storesList;
        return storesList;
      } else {
        throw Exception('Failed to load stores: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get stores: $e');
      return [];
    }
  }

  Future<InvoiceReport?> getNumberInvoicesStatus(DateTime date) async {
    try {
      String? organizationId = await getOrganizationId();
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      String dateString = dateFormat.format(date);

      var params = {
        'id': organizationId,
        'date': dateString,
      };

      final res = await request.get(
        'organizations/$organizationId/invoice-report',
        queryParameters: params,
      );

      if (res.statusCode == 200) {
        // Parse the JSON data to an InvoiceReport object
        InvoiceReport invoiceReport = InvoiceReport.fromJson(res.data);
        return invoiceReport;
      } else {
        throw Exception('Failed to load invoice report: ${res.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error during getting invoice report: $e');
      return null;
    }
  }
}

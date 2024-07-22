import 'package:intl/intl.dart';
import 'package:invoice/models/brand.dart';
import 'package:invoice/models/invoice_dashboard.dart';
import 'package:invoice/models/organization.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/share_pref.dart';
import 'package:invoice/utils/string_constrant.dart';

import '../models/store.dart';

class BrandAPI {
  static int page = 1;
  static int size = 10;
  List<Organization> organization = [];
  List<Brand> brandList = [];

  Future<List<Organization>> getStoreByBrandId() async {
    try {
      String? brandId = await getBrandId();
      var params = {
        'id': brandId,
        'name': '',
        'address': '',
        'representative': '',
        'taxCode': '',
        'page': page,
        'size': size,
      };
      final res = await request.get('brands/$brandId/organizations',
          queryParameters: params);
      if (res.statusCode == 200) {
        List<dynamic> jsonList = res.data['items'];
        List<Organization> organization =
            jsonList.map((json) => Organization.fromJson(json)).toList();
        return organization;
      } else {
        throw Exception('Failed to load organizations: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get organizations: $e');
      return [];
    }
  }

  Future<Store?> getStoreById(String? storeId) async {
    try {
      if (storeId == null) {
        throw Exception('Store ID cannot be null');
      }

      final res = await request.get('stores/$storeId');
      if (res.statusCode == 200) {
        final json = res.data;
        Store store = Store.fromJson(json);
        return store;
      } else {
        throw Exception('Failed to load store: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get store: $e');
      return null;
    }
  }

  Future<List<Organization>> getOrganizationListByBrandId(
      {String? name,
      String? address,
      String? representative,
      String? taxCode}) async {
    try {
      String? brandId = await getBrandId();
      var params = {
        'id': brandId,
        'page': page,
        'size': size,
      };

      if (name != null) {
        params['name'] = name;
      }

      if (address != null) {
        params['address'] = address;
      }

      if (representative != null) {
        params['representative'] = representative;
      }

      if (taxCode != null) {
        params['taxCode'] = taxCode;
      }

      final res = await request.get('brands/$brandId/organizations',
          queryParameters: params);

      if (res.statusCode == 200) {
        List<dynamic> jsonList = res.data['items'];
        List<Organization> organizationList =
            jsonList.map((json) => Organization.fromJson(json)).toList();
        return organizationList;
      } else {
        throw Exception('Failed to load stores: ${res.statusCode}');
      }
    } catch (e) {
      print('Error during get stores: $e');
      return [];
    }
  }

  Future<List<InvoicePaymentReport>> getBrandReportRevenue(
    DateTime? fromDate,
    DateTime? toDate,
    String? organizationId,
  ) async {
    try {
      String? brandId = await getBrandId();
      var params = {
        'id': brandId,
      };

      if (organizationId != null) {
        params['organizationId'] = organizationId;
      }

      if (fromDate != null) {
        params['fromDate'] = DateFormat('yyyy-MM-dd').format(fromDate);
      }

      if (toDate != null) {
        params['toDate'] = DateFormat('yyyy-MM-dd').format(toDate);
      }

      final res = await request.get(
        'brands/$brandId/invoice-payment-report-in-date',
        queryParameters: params,
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> data = res.data;
        List<dynamic> jsonList = data['items'];

        return jsonList
            .map((json) => InvoicePaymentReport.fromJson(json))
            .toList();
      } else {
        throw Exception('Error loading invoice payment report');
      }
    } catch (e) {
      throw Exception('Error loading invoice payment report: ${e.toString()}');
    }
  }

  Future<List<InvoiceReport>> getBrandReportInvoices(
    DateTime? fromDate,
    DateTime? toDate,
    String? organizationId,
  ) async {
    try {
      String? brandId = await getBrandId();
      var params = {
        'id': brandId,
      };

      if (organizationId != null) {
        params['organizationId'] = organizationId;
      }

      if (fromDate != null) {
        params['fromDate'] = DateFormat('yyyy-MM-dd').format(fromDate);
      }

      if (toDate != null) {
        params['toDate'] = DateFormat('yyyy-MM-dd').format(toDate);
      }

      final res = await request.get(
        'brands/$brandId/invoice-report-in-date',
        queryParameters: params,
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> data = res.data;
        List<dynamic> jsonList = data['items'];
        List<InvoiceReport> reports =
            jsonList.map((item) => InvoiceReport.fromJson(item)).toList();
        return reports;
      } else {
        throw Exception(Message.errorLoadInvoicePayment);
      }
    } catch (e) {
      throw Exception(Message.errorLoadInvoicePaymentContent + e.toString());
    }
  }
}

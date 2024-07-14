import 'package:invoice/models/brand.dart';
import 'package:invoice/models/organization.dart';
import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/share_pref.dart';

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
}

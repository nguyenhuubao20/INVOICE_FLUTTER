import 'package:invoice/utils/request.dart';
import 'package:invoice/utils/share_pref.dart';

import '../models/store.dart';

class OrganizationAPI {
  static int page = 1;
  static int size = 10;
  List<Store> stores = [];

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
}

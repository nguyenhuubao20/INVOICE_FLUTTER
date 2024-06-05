import 'package:invoice/models/account.dart';

import '../utils/request.dart';
import '../utils/share_pref.dart';

class AccountAPI {
  static int page = 1;
  static int size = 10;

  Future<Account?> checkUserIsLogged() async {
    String token = await getToken() ?? '';
    String userId = await getUserId() ?? '';
    if (token.isEmpty || userId.isEmpty) {
      return null;
    }
    final isExpireToken = await expireToken();
    if (isExpireToken) {
      return null;
    }
    try {
      var params = {
        'id': userId,
        'token': token,
      };
      final res =
          await request.get('accounts/${userId}/jwt', queryParameters: params);
      if (res.statusCode == 200) {
        var json = res.data;
        Account account = Account.fromJson(json);
        return account;
      } else {
        print('Failed to sign in. Status code: ${res.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  Future<Account?> signIn(String userName, String password) async {
    try {
      final res = await request.post('auth/login', data: {
        "username": userName,
        "password": password,
      });
      var json = res.data;
      Account account = Account.fromJson(json);
      return account;
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  Future<Account?> getAccountInfo(String? userId) async {
    try {
      final res = await request.get('accounts/$userId');
      var json = res.data;
      Account account = Account.fromJson(json);
      return account;
    } catch (e) {
      print('Error during get account info: $e');
      return null;
    }
  }

  Future<Account?> getBrandIdByUserId(
      String? userId, String? username, int? role) async {
    try {
      var params = {
        'username': username,
        'role': role,
        'page': page,
        'size': size,
      };
      final res =
          await request.get('brands/$userId/users', queryParameters: params);
      var json = res.data;
      Account account = Account.fromJson(json);
      return account;
    } catch (e) {
      print('Error during get brand id: $e');
      return null;
    }
  }
}

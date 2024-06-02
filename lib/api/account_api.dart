import 'package:invoice/models/account.dart';

import '../utils/request.dart';
import '../utils/share_pref.dart';

class AccountAPI {
  static int page = 1;
  static int size = 10;

  Future<bool> checkUserIsLogged() async {
    String token = await getToken() ?? '';
    String userId = await getUserId() ?? '';
    final isExpireToken = await expireToken();
    if (isExpireToken) return false;
    try {
      var params = {
        'id': userId,
        'token': token,
      };

      final res = await request.get('accounts/jwt', queryParameters: params);
      if (res.statusCode == 200) {
        return true;
      } else {
        print('Failed to sign in. Status code: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during sign in: $e');
      return false;
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
      setUserId(account.id);
      return account;
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  Future<User?> getBrandIdByUserId(
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
      User user = User.fromJson(json);
      setStoreId(user.storeId);
      return user;
    } catch (e) {
      print('Error during get brand id: $e');
      return null;
    }
  }
}

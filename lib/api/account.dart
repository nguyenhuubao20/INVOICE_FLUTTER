import 'package:invoice/models/account.dart';

import '../utils/request.dart';
import '../utils/share_pref.dart';

class AccountAPI {
  Future<bool> isUserLoggedIn() async {
    final isExpireToken = await expireToken();
    final token = await getToken();
    if (isExpireToken) return false;
    if (token != null) requestObj.setToken = token;
    return token != null;
  }

  Future<Account?> signIn(String userName, String password) async {
    try {
      final res = await request.post('auth/login', data: {
        "username": userName,
        "password": password,
      });
      var json = res.data;
      Account user = Account.fromJson(json);
      return user;
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  // Future<num?> checkUser(String phone) async {
  //   try {
  //     final res = await requestPointify.get(
  //       'memberships/check-member',
  //       queryParameters: {'apiKey': apiKey, 'phone': phone},
  //     );
  //     var json = res.data;

  //     if (json is num) {
  //       return num.parse(json.toString());
  //     } else {
  //       print('Invalid response from API: $json');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error during user check: $e');
  //     return null;
  //   }
  // }

  // Future<Account?> signUp(String phone, String pinCode,
  //     String fullName, int gender, String email, String referalPhone) async {
  //   final res =
  //       await requestPointify.post('memberships/signup', queryParameters: {
  //     'apiKey': apiKey
  //   }, data: {
  //     "phone": phone,
  //     "pinCode": pinCode,
  //     "fullName": fullName,
  //     "gender": gender,
  //     "email": email,
  //     "referalPhone": referalPhone
  //   });
  //   var json = res.data;
  //   MemberShipRespone memberInfo = MemberShipRespone.fromJson(json);
  //   return memberInfo;
  // }

  // Future<MemberShipRespone?> resetPassword(String phone, String pinCode) async {
  //   final res =
  //       await requestPointify.patch('memberships/reset-pass', queryParameters: {
  //     'apiKey': apiKey
  //   }, data: {
  //     "phone": phone,
  //     "pinCode": pinCode,
  //   });
  //   var json = res.data;
  //   MemberShipRespone memberInfo = MemberShipRespone.fromJson(json);
  //   return memberInfo;
  // }

  // // Future<UserDetails> getUserById(String id) async {
  // //   final res = await request.get('users/$id');
  // //   var json = res.data;
  // //   UserDetails userInfo = UserDetails.fromJson(json);
  // //   return userInfo;
  // // }

  // Future<String> getUserQRCode(String id) async {
  //   final res = await request.post('users/$id/generate-qr');
  //   var json = res.data;
  //   return json;
  // }

  // Future<dynamic> updateUser(String id, UserUpdate update) async {
  //   final res = await request.patch('users/$id', data: update.toJson());
  //   var json = res.data;
  //   return json;
  // }
}

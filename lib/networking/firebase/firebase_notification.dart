import 'package:firebase_messaging/firebase_messaging.dart';

class FireBaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      announcement: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    String? token = await _firebaseMessaging.getToken();
    print("FirebaseMessaging token: $token");
  }

  

}

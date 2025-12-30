import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kindomcall/core/constants/constants.dart';

import 'app.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // NotificationServices notificationServices = NotificationServices();
  // String token = await notificationServices.getDeviceToken();
  // print('🔑 Device Token: $token');
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.authBox);
  await Hive.openBox(AppConstants.appSettingsBox);

  runApp(const ProviderScope(child: MyApp()));
}

import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:save_food/firebase_options.dart';
import 'package:save_food/providers/food_provider.dart';
import 'package:save_food/utils/stripe_key.dart';
import '/constants/constants.dart';
import '/providers/user_provider.dart';
import '/screens/login_screen.dart';
import '/theme/theme_data.dart';
import '/utils/size_config.dart';

Future<bool> hasBiometrics() async {
  final localAuth = LocalAuthentication();
  const secureStorage = FlutterSecureStorage();
  return await secureStorage.read(key: SecureStorageConstants.emailKey) !=
          null &&
      await localAuth.canCheckBiometrics;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey = StripeKey.stripePublishableKey;
  // await Stripe.instance.applySettings();
  final canCheckBioMetric = await hasBiometrics();
  runApp(
    MyApp(canCheckBioMetric),
  );
}

class MyApp extends StatelessWidget {
  final bool canCheckBioMetric;

  MyApp(this.canCheckBioMetric, {Key? key}) : super(key: key);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  configureMessaging() async {
    final messagingInstance = FirebaseMessaging.instance;
    final permission = await messagingInstance.requestPermission();

    // messagingInstance.
    FirebaseMessaging.onMessage.forEach(
      (event) {
        const androidNotification = AndroidNotificationDetails(
          "channel id",
          "channel name",
          importance: Importance.high,
          priority: Priority.high,
        );

        const notificationDetails =
            NotificationDetails(android: androidNotification);

        flutterLocalNotificationsPlugin.show(
          Random().nextInt(100000),
          event.notification?.title ?? "title",
          event.notification?.body ?? "body",
          notificationDetails,
        );
        // event.
        // print("object");
        // print(event.notification?.title ?? "title");
        // print(event.notification?.body ?? "messageBody");
        // print(event.notification?.android?.imageUrl ?? "imageUrl");
      },
    );
  }

  configureNotification() {
    const androidSettings =
        AndroidInitializationSettings(ImageConstants.notificationIcon);
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    configureNotification();
    configureMessaging();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FoodProvider(),
        ),
       
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          SizeConfig().init(constraints);
          return MaterialApp(
            title: 'Save Food',
            debugShowCheckedModeBanner: false,
            theme: lightTheme(context),
            home: LoginScreen(canCheckBioMetric)
          );
        },
      ),
    );
  }
}

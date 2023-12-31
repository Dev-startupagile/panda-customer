import 'dart:async';
import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as ac;
import 'package:amplify_flutter/amplify_flutter.dart' as af;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:panda/amplifyconfiguration.dart';
import 'package:panda/provider/auth_provider.dart';
import 'package:panda/provider/auto_complete_provider.dart';
import 'package:panda/provider/contactus_provider.dart';
import 'package:panda/provider/estimate_provider.dart';
import 'package:panda/provider/nearby_provider.dart';
import 'package:panda/provider/notification_provider.dart';
import 'package:panda/provider/profile_provider.dart';
import 'package:panda/provider/rating_provider.dart';
import 'package:panda/provider/service_provider.dart';
import 'package:panda/provider/service_request_provider.dart';
import 'package:panda/provider/uploader_provider.dart';
import 'package:panda/provider/user_detail_provider.dart';
import 'package:panda/route/route_generator.dart';
import 'package:panda/screens/auth/auth.dart';
import 'package:panda/screens/home/home_page.dart';
import 'package:panda/screens/onboarding/on_bording.dart';
import 'package:panda/util/api.dart';
import 'package:panda/util/constants.dart';
import 'package:panda/util/ui_constant.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'commonComponents/loading.dart';
import 'function/auth.dart';
import 'function/shared_prefs.dart';

import 'package:intl/date_symbol_data_local.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final sharedPrefs = SharedPrefs();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    if (notification.title == estimateN) {
      sharedPrefs.badgeIncrementer();
    }
    if (notification.title == counterOfferN) {
      sharedPrefs.counterOfferSetter(notification.body!);
    }
    if (notification.title == reScheduleN) {
      sharedPrefs.requestOfferSetter(notification.body!);
    }
    if (notification.title == pendingN) {
      sharedPrefs.pendingBadgeIncrementer();
    }
    if (notification.title == ratingN) {
      sharedPrefs.ratingSetter(notification.body!);
    }
    if (notification.title == acceptedN ||
        notification.title == onmywayN ||
        notification.title == arrivedN ||
        notification.title == serviceunderwayN) {
      sharedPrefs.acceptedBadgeIncrementer();
    }
    if (notification.title == canceledN) {
      sharedPrefs.canceledBadgeIncrementer();
    }
    if (notification.title == completedN) {
      sharedPrefs.completedBadgeIncrementer();
    }
    if (notification.title == completedN ||
        notification.title == canceledN ||
        notification.title == acceptedN ||
        notification.title == pendingN ||
        notification.title == estimateN ||
        notification.title == onmywayN ||
        notification.title == arrivedN ||
        notification.title == serviceunderwayN) {
      List<String> message =
          formatNotificationMessage(notification.title!, notification.body!);
      return flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          message[0],
          message[1],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/launch_image',
            ),
          ));
    }
  }
}

List<String> formatNotificationMessage(String title, String body) {
  if (title == acceptedN) {
    Map<String, dynamic> data = json.decode(body);
    return [
      "Technician have accepted your request",
      "${data["technicianName"]} has accepted your request."
    ];
  }
  if (title == onmywayN) {
    Map<String, dynamic> data = json.decode(body);
    return [
      "Technician on the way",
      "Hold on tight, ${data["technicianName"]} is on the way!"
    ];
  }
  if (title == arrivedN) {
    Map<String, dynamic> data = json.decode(body);
    return ["Technician has arrived", "${data["technicianName"]} has arrived"];
  }
  if (title == estimateN) {
    // Map<String, dynamic> data = json.decode(body);
    return [
      "Technician has sent estimation",
      "Check out the estimation, technician has sent one for the service!"
    ];
  }
  if (title == reScheduleN) {
    Map<String, dynamic> data = json.decode(body);
    return [
      "Service rescheduled",
      "${data["technicianName"]} has rescheduled the service."
    ];
  }
  return [title, body];
}

void _configureAmplify() async {
  await af.Amplify.addPlugin(ac.AmplifyAuthCognito());
  try {
    await af.Amplify.configure(
        amplifyconfig); // 'amplifyconfig' is the configuration you get from the Amplify CLI
  } catch (e) {
    print("An error occurred setting up Amplify: $e");
  }
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  StripePayment.setOptions(
    StripeOptions(
      publishableKey:
          pUBLISHABLEKEY, // Replace with your Stripe publishable key
      merchantId: mERCHANTID, // Replace with your Merchant ID
      androidPayMode:
          'test', // Change to 'production' when running in production
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Future.delayed(const Duration(seconds: 1));
  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.grey, systemStatusBarContrastEnforced: true));

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  _configureAmplify();
  await initializeDateFormatting();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AutoCompleteProvider()),
        ChangeNotifierProvider(create: (_) => UserDetailByEmailProvider()),
        ChangeNotifierProvider(create: (_) => NearByProvider()),
        ChangeNotifierProvider(create: (_) => UploaderProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => ContactUsProvider()),
        ChangeNotifierProvider(create: (_) => ServiceRequestProvider()),
        ChangeNotifierProvider(create: (_) => EstimateProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuth = false;
  bool isLoading = true;
  bool isFirstTime = false;

  final authfunc = AuthFunc();

  void checkUserStatus() async {
    isAuth = await authfunc.checkIsAuthenticated();
    isFirstTime = await authfunc.isFirstTimeLogedIn();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    checkUserStatus();
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        if (notification.title == estimateN) {
          context.read<NotificationProvider>().badgeIncrementer();
        }
        if (notification.title == counterOfferN) {
          context
              .read<NotificationProvider>()
              .counterOfferSetter(notification.body!);
        }
        if (notification.title == reScheduleN) {
          context
              .read<NotificationProvider>()
              .requestOfferSetter(notification.body!);
        }

        if (notification.title == pendingN) {
          context.read<NotificationProvider>().pendingBadgeIncrementer();
        }
        if (notification.title == ratingN) {
          context.read<RatingProvider>().ratingSetter(notification.body!);
        }
        if (notification.title == acceptedN ||
            notification.title == onmywayN ||
            notification.title == arrivedN ||
            notification.title == serviceunderwayN) {
          context.read<NotificationProvider>().acceptedBadgeIncrementer();
        }
        if (notification.title == canceledN) {
          context.read<NotificationProvider>().canceledBadgeIncrementer();
        }
        if (notification.title == completedN) {
          context.read<NotificationProvider>().completedBadgeIncrementer();
        }
        if (notification.title == completedN ||
            notification.title == canceledN ||
            notification.title == acceptedN ||
            notification.title == pendingN ||
            notification.title == estimateN ||
            notification.title == onmywayN ||
            notification.title == arrivedN ||
            notification.title == serviceunderwayN) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/launch_image',
                ),
              ));
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panda Customer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: KBGColor),
      onGenerateRoute: RouteGenerator.generateRoute,
      home: isLoading
          ? const Loading()
          : (isAuth)
              ? HomePage()
              : (!isAuth && isFirstTime)
                  ? const Auth()
                  : const OnboardingSlider(),
    );
  }
}

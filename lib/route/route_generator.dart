import 'package:flutter/material.dart';
import 'package:panda/screens/home/estimate/estimate_page.dart';
import 'package:panda/screens/home/home_page.dart';
import 'package:panda/screens/home/profile/profileComponents/contact_us.dart';
import 'package:panda/screens/home/profile/profileComponents/edit_profile.dart';
import 'package:panda/screens/home/profile/profileComponents/faq.dart';
import 'package:panda/screens/home/profile/profileComponents/help.dart';
import 'package:panda/screens/home/profile/profileComponents/privacy_and_policy.dart';
import 'package:panda/screens/home/profile/profileComponents/settings.dart';
import 'package:panda/screens/home/profile/profileComponents/term_of_services.dart';
import '../screens/auth/auth.dart';
import '../screens/auth/authComponent/forgot_password.dart';
import '../screens/home/profile/profileComponents/add_payment.dart';
import '../screens/home/profile/profileComponents/add_vehicle.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
            builder: (_) => HomePage(
                  isFromNoNearByTech: false,
                ));

      case '/from_nearby':
        return MaterialPageRoute(
            builder: (_) => HomePage(
                  isFromNoNearByTech: true,
                ));
      case '/login':
        return MaterialPageRoute(builder: (_) => const Auth());
      case '/term_of_services':
        return MaterialPageRoute(builder: (_) => const TermOfService());
      case '/privacy_policy':
        return MaterialPageRoute(builder: (_) => const PrivacyPolicy());
      case '/help':
        return MaterialPageRoute(builder: (_) => const Help());
      case '/add_vehicle':
        return MaterialPageRoute(builder: (_) => AddVehicle());
      case '/faq':
        return MaterialPageRoute(builder: (_) => const Faq());
      case "/forget":
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case "/edit_profile":
        return MaterialPageRoute(builder: (_) => const EditProfile());
      case "/add_payment":
        return MaterialPageRoute(builder: (_) => const AddPaymentMethod());
      case "/contact_us":
        return MaterialPageRoute(builder: (_) => ContactUs());
      case "/estimate":
        return MaterialPageRoute(builder: (_) => const EstimatePage());
      case "/settings":
        return MaterialPageRoute(builder: (_) => const Settings());

      default:
        return MaterialPageRoute(builder: (_) => const Auth());
    }
  }
}

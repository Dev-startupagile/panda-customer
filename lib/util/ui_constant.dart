import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui';

class AppColors {
  AppColors._();

  static const Color cardBgColor = Color(0xff363636);
  static const Color colorB58D67 = Colors.green; // Color(0xffB58D67);
  static const Color colorE5D1B2 = Colors.greenAccent;
  static const Color colorF9EED2 = Colors.greenAccent;
  static const Color colorFFFFFD = Colors.greenAccent;
}

/// Colors
const KPColor = Color(0xFF4B778D);
const KBorderColor = Color(0xFFA0AEC0);
const KPDarkColor = Colors.blue;
const KBGColor = Colors.white;
const kPrimaryColor = Color(0xff33BC84);
const kPrimaryColorSecondary = Color(0xff33BC84);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
const kDefaultPadding = 20.0;
const KTextColor = Color(0xFF4B778D);
const KTextColorSecondary = Color(0xFF3B3B3B);
const KInactiveMenuColor = Color(0xFF4D565C);
const KHintColor = Color(0xFF70777C);
const KDisableButtonColor = Color(0xFFCFD6DF);
const KAppBarColor = Color(0xFF272727);
const KTitleColor = Color(0xFF272727);
const KContainerBGColor = Color(0xFFEAEFF2);
const KContainerBorderColor = Color(0xFFA0AEC0);

/// TextStyle
const KLogoTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 52.0,
    fontWeight: FontWeight.w900,
    fontFamily: 'Roboto');

var KLatoRegularTextStyle = GoogleFonts.lato(
  fontSize: 16,
  letterSpacing: 0.25,
  color: Colors.grey,
);

var KLatoTextStyle = GoogleFonts.lato(
  fontSize: 16,
  letterSpacing: 0.25,
  color: Colors.black,
);

var KAuthTextStyle = GoogleFonts.lato(
  fontSize: 16,
  letterSpacing: 1.25,
  color: Colors.white,
);

var KNormalTextStyle = GoogleFonts.lato(
  fontSize: 16,
  letterSpacing: 0.25,
  color: Colors.grey,
);

const KWhiteTextStyle =
    TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Lato');

var KNativeTextStyle = GoogleFonts.lato(
  fontSize: 16,
  letterSpacing: 1.25,
  color: kPrimaryColorSecondary,
);

var KErrorTextStyle = GoogleFonts.lato(
  fontSize: 16,
  letterSpacing: 1.25,
  color: kErrorColor,
);

const KAppNameSplashTextStyle = TextStyle(
    color: KTextColor,
    fontSize: 16.0,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w400,
    fontFamily: 'Lato');

const KOnBoardTitleTextStyle = TextStyle(
    color: KTextColorSecondary,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Lato');

const KOnBoardBodyTextStyle = TextStyle(
    color: KTextColorSecondary,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'Lato');

const KOnBoardGetStartedTextStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Lato');

const KDangerTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.0,
    // fontWeight: FontWeight.w700,
    fontFamily: 'Lato');

const KLoginInactiveMenuTextStyle = TextStyle(
    color: KInactiveMenuColor,
    fontSize: 16.0,
    // fontWeight: FontWeight.w700,
    fontFamily: 'Lato');

const KLoginActiveMenuTextStyle = TextStyle(
    color: KPColor,
    fontSize: 16.0,
    // fontWeight: FontWeight.w900,
    fontFamily: 'Lato');

var KHintTextStyle = GoogleFonts.lato(
  fontSize: 16,
  letterSpacing: 0.25,
  color: Colors.grey,
);

const KInputTextTextStyle = TextStyle(
    color: KPColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Lato');

const KProfilePicAppBarTextStyle = TextStyle(
    color: KAppBarColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Lato');

const KAppTitleTextStyle = TextStyle(
    color: KTitleColor,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Lato');

const KOtpTextStyle = TextStyle(
    color: KTitleColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Lato');

const KOtpDangerTextStyle = TextStyle(
    color: kErrorColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Lato');

const KAppEditTextStyle = TextStyle(
    color: kPrimaryColor,
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Lato');

const AdditemTextStyle = TextStyle(
    color: kPrimaryColor,
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Lato');

const KAppBodyTextStyle = TextStyle(
    color: KTitleColor,
    fontSize: 14.0,
    // fontWeight: FontWeight.w400,
    fontFamily: 'Lato');

const KScheduleCardTextStyle = TextStyle(
    color: KPColor,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Lato');

const KScheduleCardTextTwoStyle = TextStyle(
    color: KTitleColor,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'Lato');

const String KOnBoardingTitle = 'Consectetur Adipiscing';
const String KOnBoardingBody =
    'Consectetur adipiscing elit, Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea';
const String KTermsAndConditionsOne =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. At consectetur lorem donec massa sapien faucibus. Est placerat in egestas erat. Aliquet nibh praesent tristique magna. Ornare lectus sit amet est. Elit ut aliquam purus sit. Nulla at volutpat diam ut venenatis tellus. Lobortis feugiat vivamus at augue. Cursus sit amet dictum sit amet justo donec. Faucibus pulvinar elementum integer enim neque volutpat. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

const String KPrivacyPolicy =
    "Quisque sagittis purus sit amet. Mi sit amet mauris commodo quis imperdiet. Ornare quam viverra orci sagittis eu volutpat. Hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit ullamcorper. Magna fermentum iaculis eu non diam. Fames ac turpis egestas maecenas pharetra convallis posuere morbi. Neque aliquam vestibulum morbi blandit. Eget mauris pharetra et ultrices neque ornare aenean euismod. Mauris rhoncus aenean vel elit scelerisque mauris. Eu consequat ac felis donec et odio pellentesque. Lorem dolor sed viverra ipsum nunc. Vulputate enim nulla aliquet porttitor lacus luctus. Sed lectus vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt. Quis risus sed vulputate odio. Dignissim sodales ut eu sem integer vitae. Proin sagittis nisl rhoncus mattis rhoncus urna neque viverra. Velit aliquet sagittis id consectetur. Nunc eget lorem dolor sed viverra ipsum. Bibendum ut tristique et egestas.";

const String KHelp =
    "Quisque sagittis purus sit amet. Mi sit amet mauris commodo quis imperdiet. Ornare quam viverra orci sagittis eu volutpat. Hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit ullamcorper. Magna fermentum iaculis eu non diam. Fames ac turpis egestas maecenas pharetra convallis posuere morbi. Neque aliquam vestibulum morbi blandit. Eget mauris pharetra et ultrices neque ornare aenean euismod. Mauris rhoncus aenean vel elit scelerisque mauris. Eu consequat ac felis donec et odio pellentesque. Lorem dolor sed viverra ipsum nunc. Vulputate enim nulla aliquet porttitor lacus luctus. Sed lectus vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt. Quis risus sed vulputate odio. Dignissim sodales ut eu sem integer vitae. Proin sagittis nisl rhoncus mattis rhoncus urna neque viverra. Velit aliquet sagittis id consectetur. Nunc eget lorem dolor sed viverra ipsum. Bibendum ut tristique et egestas.";

const String KFaq =
    "Quisque sagittis purus sit amet. Mi sit amet mauris commodo quis imperdiet. Ornare quam viverra orci sagittis eu volutpat. Hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit ullamcorper. Magna fermentum iaculis eu non diam. Fames ac turpis egestas maecenas pharetra convallis posuere morbi. Neque aliquam vestibulum morbi blandit. Eget mauris pharetra et ultrices neque ornare aenean euismod. Mauris rhoncus aenean vel elit scelerisque mauris. Eu consequat ac felis donec et odio pellentesque. Lorem dolor sed viverra ipsum nunc. Vulputate enim nulla aliquet porttitor lacus luctus. Sed lectus vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt. Quis risus sed vulputate odio. Dignissim sodales ut eu sem integer vitae. Proin sagittis nisl rhoncus mattis rhoncus urna neque viverra. Velit aliquet sagittis id consectetur. Nunc eget lorem dolor sed viverra ipsum. Bibendum ut tristique et egestas.";

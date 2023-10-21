import 'package:url_launcher/url_launcher.dart';

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

void launchEmail(){
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'project@t1factory.com',
    query: encodeQueryParameters(<String, String>{
      'subject': "type your report here",
    }),
  );
  launchUrl(emailLaunchUri);
}

void launchSms(phoneNumber){
  final Uri smsLaunchUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    queryParameters: <String, String>{
      'body': Uri.encodeComponent(''),
    },
  );
  launchUrl(smsLaunchUri);
}
void launchPhone(phoneNumber){
  final Uri smsLaunchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,

  );
  launchUrl(smsLaunchUri);
}
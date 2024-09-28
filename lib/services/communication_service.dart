import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunicationService {
  Logger logger = Logger();

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      logger.e('Failed to launch phone call to $phoneNumber');
    }
  }

  Future<void> sendWhatsAppMessage(String message, String phoneNumber) async {
    phoneNumber = phoneNumber.replaceAll(RegExp(r"[^\d]"), "");

    final Uri whatsappUrl = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    logger.e('whatsappUrl: $whatsappUrl');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      logger.e('Trying to launch in browser as a fallback');
      await launchUrl(Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}"));
    }
  }

    Future<void> sendAnSMS(String message, List<String> recipients) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: recipients.join(','),
      queryParameters: {
        'body': message,
      },
    );

    logger.d('SMS URI: $smsUri');

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      logger.e('Could not launch SMS');
      throw 'Could not launch SMS';
    }
  }
}

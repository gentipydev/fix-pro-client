import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class CommunicationService {
  Logger logger = Logger();

  static const platform = MethodChannel('com.example.app/phonecall');

  Future<void> makePhoneCall(String phoneNumber, [bool enableVideo = false]) async {
    if (phoneNumber.isEmpty) {
      logger.e("Phone number is empty");
      return;
    }
    final String scheme = enableVideo ? 'facetime' : 'tel';
    try {
      final bool result = await platform.invokeMethod('makePhoneCall', {
        'phoneNumber': phoneNumber,
        'scheme': scheme,
      });
      if (!result) {
        logger.e('Could not launch $scheme:$phoneNumber');
      }
    } on PlatformException catch (e) {
      logger.e("Failed to make phone call: '${e.message}'.");
    }
  }

  Future<void> sendWhatsAppMessage(String message, String phoneNumber) async {
    // Ensure that the phone number is in the full international format without any special characters like "+"
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

  Future<void> sendSmsMessage(String message, List<String> recipients) async {
    if (recipients.isEmpty || message.isEmpty) {
      logger.e("Recipients or message is empty");
      return;
    }

    try {
      String result = "Hello";
      // String result = await sendSMS(
      //   message: message,
      //   recipients: recipients,
      //   sendDirect: true,
      // );
      logger.d("SMS sent: $result");
    } catch (e) {
      logger.e("Failed to send SMS: $e");
    }
  }
}

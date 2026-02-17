import 'package:flutter/cupertino.dart';
import 'package:phone_number/phone_number.dart';

final PhoneNumberUtil _phoneUtil = PhoneNumberUtil();

String normalizePhone(final String phone) {
  final number = phone.replaceAll(RegExp(r'[^0-9+]'), '');
  return number.startsWith('+')
      ? number.substring(1)
      : number;
} 


Future<String> formatPhoneForDisplay(final String phone) async {
  try {
    final parsed = await _phoneUtil.parse('+$phone');

    return parsed.e164; // +64223585912
  } on Exception catch (number) {
    debugPrint('Error formatting phone number: $number');
    return phone; // fallback if invalid
  }
}

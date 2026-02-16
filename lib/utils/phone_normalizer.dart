String normalizePhone(final String phone) {
  final number = phone.replaceAll(RegExp(r'[^0-9+]'), '');
  return number.startsWith('+')
      ? number.substring(1)
      : number;
} 

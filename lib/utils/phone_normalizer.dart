String normalizePhone(final String phone) => phone.replaceAll(RegExp(r'[^0-9+]'), '');

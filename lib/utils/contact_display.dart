import 'package:paylent/models/contact_info.dart';

String displayName({
  required final Contact? contact,
  required final String currentUserId,
}) => contact?.id == currentUserId ? 'You' : contact?.name ?? 'Unknown';

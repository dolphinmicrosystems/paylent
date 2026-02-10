import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylent/models/user.dart';

final currentUserProvider = Provider<AppUser>((final ref) => const AppUser(
    id: 'me_001',
    name: 'Pawan Arora',
    email: 'you@paylent.app',
    avatarUrl: 'https://i.pravatar.cc/150?img=64',
  ));

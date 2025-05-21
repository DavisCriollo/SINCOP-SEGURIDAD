// 1. Crea una clase para tus parámetros
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../src/models/session_response.dart';

class SessionParams {
  const SessionParams(this.user, this.turno);

  final Session user;
  final bool turno;
}

final userProvider = StateProvider<SessionParams?>((ref) => null);

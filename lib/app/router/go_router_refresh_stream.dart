import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapta um Stream (aqui, `onAuthStateChange`) para o `Listenable` que o
/// go_router espera em `refreshListenable`, disparando redirects quando o
/// usuário loga/desloga.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

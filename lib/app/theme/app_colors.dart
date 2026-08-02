import 'package:flutter/material.dart';

/// Paleta provisória — neutra com um único accent, no espírito
/// Apple/Stripe/Linear. Ajustar quando a identidade visual da marca
/// for definida (Fase 0 tardia / Fase 6).
abstract final class AppColors {
  static const accent = Color(0xFF2563EB);
  static const accentDark = Color(0xFF3B82F6);

  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFD97706);
  static const danger = Color(0xFFDC2626);

  static const surfaceLight = Color(0xFFFFFFFF);
  static const backgroundLight = Color(0xFFF7F7F8);
  static const surfaceDark = Color(0xFF1C1C1E);
  static const backgroundDark = Color(0xFF000000);
}

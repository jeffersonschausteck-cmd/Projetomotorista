import 'package:url_launcher/url_launcher.dart';

/// Normaliza um telefone brasileiro pro formato que o wa.me espera
/// (código do país + DDD + número, só dígitos). Números que já vêm com
/// mais de 11 dígitos são tratados como já tendo código de país e não são
/// alterados.
String normalizeBrazilianPhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length == 10 || digits.length == 11) return '55$digits';
  return digits;
}

Uri buildWhatsAppUri({required String phone, String? message}) {
  final normalized = normalizeBrazilianPhone(phone);
  return Uri.https(
    'wa.me',
    '/$normalized',
    message != null && message.isNotEmpty ? {'text': message} : null,
  );
}

/// Abre o WhatsApp (app ou web) com a conversa já preenchida. Não depende de
/// nenhuma credencial ou API do WhatsApp Business — é só um link `wa.me`.
Future<bool> openWhatsAppChat({required String phone, String? message}) {
  final uri = buildWhatsAppUri(phone: phone, message: message);
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

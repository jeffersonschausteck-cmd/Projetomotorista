/// Configuração de ambiente lida em tempo de build via `--dart-define-from-file`.
/// Nunca hardcode chaves aqui — veja `dart_define.example.json` na raiz do projeto.
class Env {
  const Env._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static void assertConfigured() {
    if (supabaseUrl.isEmpty || supabasePublishableKey.isEmpty) {
      throw StateError(
        'SUPABASE_URL/SUPABASE_PUBLISHABLE_KEY não configurados. '
        'Rode com --dart-define-from-file=dart_define.json '
        '(veja dart_define.example.json).',
      );
    }
  }
}

// Checagem manual de integração contra um Supabase real (não roda no CI nem
// em `flutter test` — fica fora de test/ de propósito, porque depende de
// rede e de um projeto provisionado). Usa o mesmo código de produção
// (AuthRepositoryImpl) para validar signUp/signIn/trigger/RLS de ponta a
// ponta contra o backend.
//
// Pré-requisito: exista um usuário de teste com e-mail confirmado em
// teste.motorando@exemplo.com / SenhaForte123! (ou ajuste as constantes
// abaixo para outro usuário do seu projeto).
//
// Rodar com:
//   flutter test tool/e2e_smoke_check.dart --dart-define-from-file=dart_define.json

import 'package:driver_platform/core/error/result.dart';
import 'package:driver_platform/features/auth/data/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _url = String.fromEnvironment('SUPABASE_URL');
const _key = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
const _testEmail = 'teste.motorando@exemplo.com';
const _testPassword = 'SenhaForte123!';

void main() {
  late SupabaseClient client;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    // authFlowType: implicit evita a asserção de storage assíncrono do PKCE,
    // que só existe porque este harness usa SupabaseClient puro. O app real
    // usa Supabase.initialize() (supabase_flutter), que já provê esse storage.
    client = SupabaseClient(
      _url,
      _key,
      authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
    );
    repository = AuthRepositoryImpl(client);
  });

  test('signInWithPassword autentica o usuário de teste real', () async {
    final result = await repository.signInWithPassword(
      email: _testEmail,
      password: _testPassword,
    );

    expect(result, isA<Success<void>>());
    expect(repository.currentUser, isNotNull);
    expect(repository.currentUser!.email, _testEmail);
  });

  test('signOut limpa a sessão', () async {
    await repository.signOut();
    expect(repository.currentUser, isNull);
  });

  test('signInWithPassword falha com senha errada', () async {
    final result = await repository.signInWithPassword(
      email: _testEmail,
      password: 'senha-errada',
    );

    expect(result, isA<Error<void>>());
  });

  test('signUpWithPassword cria o usuário (trigger cria profiles à parte)', () async {
    final email = 'e2e-${DateTime.now().microsecondsSinceEpoch}@exemplo.com';
    final result = await repository.signUpWithPassword(
      email: email,
      password: _testPassword,
      fullName: 'Usuário E2E',
    );

    result.when(
      success: (_) {},
      failure: (f) => fail('${f.runtimeType}: ${f.message}'),
    );
  });
}

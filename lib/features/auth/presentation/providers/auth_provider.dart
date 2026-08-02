import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../../core/error/failure.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(supabaseClientProvider));

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

@riverpod
class AuthController extends _$AuthController {
  @override
  Failure? build() => null;

  Future<bool> signIn({required String email, required String password}) =>
      _run(
        () => ref
            .read(authRepositoryProvider)
            .signInWithPassword(email: email, password: password),
      );

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) => _run(
    () => ref
        .read(authRepositoryProvider)
        .signUpWithPassword(email: email, password: password, fullName: fullName),
  );

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  Future<bool> _run(Future<dynamic> Function() action) async {
    state = null;
    final result = await action();
    return result.when(
      success: (_) {
        state = null;
        return true;
      },
      failure: (f) {
        state = f;
        return false;
      },
    );
  }
}

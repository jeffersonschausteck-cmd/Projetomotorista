import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../../core/error/result.dart';

abstract interface class AuthRepository {
  Stream<User?> authStateChanges();

  User? get currentUser;

  Future<Result<void>> signInWithPassword({
    required String email,
    required String password,
  });

  Future<Result<void>> signUpWithPassword({
    required String email,
    required String password,
    required String fullName,
  });

  Future<Result<void>> signOut();
}

/// Erros de domínio — a camada `domain` nunca lança exceções de terceiros
/// (PostgrestException, AuthException etc). A camada `data` sempre converte
/// para um destes tipos antes de propagar.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Falha de conexão. Tente novamente.']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Registro não encontrado.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}

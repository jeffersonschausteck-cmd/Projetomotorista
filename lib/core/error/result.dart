import 'failure.dart';

/// Retorno padrão de repositories e usecases: sucesso com valor, ou falha
/// tipada. Evita exceções cruzando a fronteira `data` -> `domain` -> `presentation`.
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) => switch (this) {
    Success<T>(:final value) => success(value),
    Error<T>(failure: final f) => failure(f),
  };
}

class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}

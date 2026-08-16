import 'package:big_call_app/core/failure.dart';

/// Résultat d'une opération pouvant échouer, sans recourir aux exceptions.
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

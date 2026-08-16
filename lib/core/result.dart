import 'package:big_call_app/core/failure.dart';

/// Résultat d'une opération pouvant échouer, sans recourir aux exceptions.
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

/// `T` est fantôme : il n'apparaît dans aucun champ, il n'existe que pour
/// qu'un `Err<T>` s'unifie avec `Result<T>`. Conséquence : il est déduit du
/// contexte, jamais des arguments. Les signatures de ports (`Future<Result<T>>`)
/// le fournissent naturellement ; en dehors de ce cas, annoncer le type
/// explicitement — `final Result<int> r = Err(...)` — sinon Dart infère
/// `Err<dynamic>`, qui ne s'assigne pas à un `Result<int>`.
final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

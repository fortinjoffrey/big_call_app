import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/core/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Ok porte une valeur', () {
    const Result<int> result = Ok(42);
    final value = switch (result) {
      Ok(:final value) => value,
      Err() => -1,
    };
    expect(value, 42);
  });

  test('Err porte une Failure', () {
    const Result<int> result = Err(Failure.permissionDenied());
    final failure = switch (result) {
      Ok() => null,
      Err(:final failure) => failure,
    };
    expect(failure, const Failure.permissionDenied());
  });
}

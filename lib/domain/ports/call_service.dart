import 'package:big_call_app/core/result.dart';

abstract interface class CallService {
  Future<Result<void>> call(String number);
}

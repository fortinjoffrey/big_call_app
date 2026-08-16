import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.permissionDenied() = PermissionDeniedFailure;

  const factory Failure.unavailable() = UnavailableFailure;

  const factory Failure.unknown(String message) = UnknownFailure;
}

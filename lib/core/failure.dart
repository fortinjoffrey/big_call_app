import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  /// L'utilisateur a refusé une permission système.
  const factory Failure.permissionDenied() = PermissionDeniedFailure;

  /// La fonctionnalité n'existe pas sur cette plateforme ou cet appareil.
  const factory Failure.unavailable() = UnavailableFailure;

  const factory Failure.unknown(String message) = UnknownFailure;
}

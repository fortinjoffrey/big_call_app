import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacts_state.freezed.dart';

@freezed
sealed class ContactsState with _$ContactsState {
  const factory ContactsState.loading() = ContactsLoading;

  const factory ContactsState.ready({
    required List<PhoneContact> favorites,
    required List<PhoneContact> others,

    /// Faux sur iOS : la section « Favoris » est alors masquée entièrement.
    required bool showFavoritesSection,
    Failure? callError,
  }) = ContactsReady;

  const factory ContactsState.permissionDenied() = ContactsPermissionDenied;

  const factory ContactsState.error(Failure failure) = ContactsError;
}

import 'package:big_call_app/domain/entities/phone_contact.dart';

/// Contacts qui portent au moins un numéro d'urgence, dans l'ordre où ils
/// apparaissent dans [contacts].
List<PhoneContact> emergencyAmong(List<PhoneContact> contacts) =>
    contacts.where((c) => c.hasEmergencyNumber).toList();

/// Complément de [emergencyAmong] : les contacts qui n'ont aucun numéro
/// d'urgence, dans l'ordre où ils apparaissent dans [contacts].
List<PhoneContact> withoutEmergency(List<PhoneContact> contacts) =>
    contacts.where((c) => !c.hasEmergencyNumber).toList();

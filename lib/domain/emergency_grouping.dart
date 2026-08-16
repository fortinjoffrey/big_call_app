import 'package:big_call_app/domain/entities/phone_contact.dart';

List<PhoneContact> emergencyAmong(List<PhoneContact> contacts) =>
    contacts.where((c) => c.hasEmergencyNumber).toList();

List<PhoneContact> withoutEmergency(List<PhoneContact> contacts) =>
    contacts.where((c) => !c.hasEmergencyNumber).toList();

import 'package:flutter_contacts/flutter_contacts.dart';

Future<List<Contact>> getContacts() async {
  return await FlutterContacts.getContacts(withPhoto: true, withAccounts: true, withProperties:true);
}

Future<void> updateContact(Contact contact) async {
  await FlutterContacts.openExternalEdit(contact.id);
}

Future<void> deleteContact(Contact contact) async {
  await FlutterContacts.deleteContact(contact);
}

Future<void> insertContact() async {
  await FlutterContacts.openExternalInsert();
  await FlutterContacts.openExternalPick();
}

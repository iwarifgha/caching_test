import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/local.dart';
import 'package:supabase_test/supabase.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';
import 'contact_model.dart';

class DataService{

  DataService(){
    _contactsStreamController =  StreamController<List<Contact>>.broadcast(
        onListen:() {
          _mySink.add(contactCache);
        }
    );
  }

  /*myChannel = supabase.channel('my_channel').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(
          schema: 'public',
          table: contactsTable,
          event: '*'
        ),
            (payload, [ref]) async {
          print(payload);
            }).subscribe();*/


  late final StreamController<List<Contact>> _contactsStreamController;
  StreamSink<List<Contact>> get _mySink => _contactsStreamController.sink;
  final supabase = MySupabase.supabase;
  final sqlite = MyLocalStorage.instance;
  List<Contact> contactCache = [];
  final id = const Uuid();


  ///insert a contact --tested
  Future<Contact> createContact(String name, String phoneNumber) async {
    try {
      final db = await sqlite.getDatabase;
      bool hasInternet = await InternetConnection().hasInternetAccess;
      if (hasInternet) {
        final response = await supabase.from(contactsTable).
        insert([{
          createdAtField: DateTime.now().toString(),
          idField: id.v4(),
          nameField: name,
          phoneField: phoneNumber}]).
        select() as List<dynamic>;

        //convert response to Contact model and insert it into local database.
        final insertedData = response.map((e) => Contact.fromDatabase(e)).toList();
        final contact = insertedData.first;
        await db.insert(contactsTable, {
          createdAtField: contact.createdAt,
          idField: contact.id,
          nameField: contact.name,
          phoneField: contact.phone,
          isSyncedField: 1
        });

        //add the new contact to the local cache and add it to the Stream
        contactCache.add(contact);
         _mySink.add(contactCache);
        return contact;
      }
      else {
        //throw Exception('No internet');
        final conId = await db.insert(contactsTable, {
          createdAtField: DateTime.now().toString(),
          idField: id.v4(),
          nameField: name,
          phoneField: phoneNumber
        });
        final contact = await _getAContactWithLocalId(conId);
        contactCache.add(contact);
        _mySink.add(contactCache);
        return contact;

      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<Contact> _getAContactWithLocalId(int id) async {
    final db = await sqlite.getDatabase;
    final result = await db.query(
        contactsTable,
        limit: 1,
        where: 'sql_id = ?',
        whereArgs: [id]);
    print(result);
    final data = Contact.fromDatabase(result.first);
    return data;
  }


  ///read a contact from the local database
  Future<Contact> getContactFromLocalStorage(String id) async {
    final db = await sqlite.getDatabase;
    final result = await db.query(
        contactsTable,
        limit: 1,
        where: '$idField = ?',
        whereArgs: [id]);
    print(result);
    final data = Contact.fromDatabase(result.first);
    return data;
  }

  ///read all contacts from local database
  Future<List<Contact>> getAllContactsFromLocalStorage() async {
    final db = await sqlite.getDatabase;
    final result = await db.query(contactsTable);
    final contacts = result.map((e) => Contact.fromDatabase(e)).toList();
    contactCache = contacts;
    _mySink.add(contactCache);
    return contacts;
  }


  ///The Contacts Stream from local storage
  Stream<List<Contact>> get contactsStream => _contactsStreamController.stream;

  ///The Contacts Stream from supabase
  Stream<List<Contact>>  get contactsStream2 =>
      supabase.from(contactsTable).
      stream(primaryKey: [idField]).
      order('created_at', ascending: true).
      map((event) => event.map((e) => Contact.fromDatabase(e)).toList());





  ///This method is called to Synchronize actions taken when offline
  Future<void> syncContacts() async {
    final db = await sqlite.getDatabase;

    //check for un-synchronized contacts and sync them
    final unSynced = await db.query(
        contactsTable,
        where: '$isSyncedField = ?',
        whereArgs: [0]);
    if (unSynced.isNotEmpty) {
      final unSyncedContacts = unSynced.map((eachContact) => Contact.fromDatabase(eachContact)).toList();
       for(var element in unSyncedContacts){
         await supabase.from(contactsTable).
         insert([
            element.copyWith(isSynced: true).toMap()
         ]);

         db.update(contactsTable, {
           isSyncedField: 1
         },
             where: '$idField=?',
             whereArgs:[element.id]);
       }
       print('contacts were synced');
    }

    //check for updated contacts and syncs them
    final updatedContacts = await db.query(
        contactsTable,
        where: '$wasUpdatedField=?',
        whereArgs: [1]
    );
    if(updatedContacts.isNotEmpty){
      final convertedContact = updatedContacts.map((e) => Contact.fromDatabase(e));
      for(var contact in convertedContact){
        await supabase.from(contactsTable).
        update({
          nameField: contact.name,
          phoneField: contact.phone
        }).eq(idField, contact.id);
      }
      print('contacts were updated');
    }

    //checks for the deleted contacts and deletes them from supabase
    final contactsOnServer = await getAllContacts();
    final contactsOnLocal = await  getAllContactsFromLocalStorage();
    final newList = contactsOnServer.where((element) => !contactsOnLocal.contains(element));

    if (newList.isNotEmpty) {
      for(var contact in newList){
        await supabase.
        from(contactsTable).
        delete().
        eq(idField, contact.id);
      }
      print('Contacts were deleted');
    }
   }






  ///Update a contact
  Future<void> updateContact({
    required String contactId,
    required String name,
    required String phone
     }) async {
    final db = await sqlite.getDatabase;
    bool hasInternet = await InternetConnection().hasInternetAccess;
    if (hasInternet) {
      final contact = await getAContactFromSupabase(id: contactId);
      //update on local storage
      await db.update(contactsTable, {
        nameField: name,
        phoneField: phone
      },
          where: '$idField = ?',
          whereArgs: [contact.id]);

      //update on Supabase
      await supabase.
      from(contactsTable).
      update({
        nameField: name,
        phoneField: phone,
      }).
      eq(idField, contact.id).
      select();
    }
    else {
      final contact = await getContactFromLocalStorage(contactId);
      db.update(contactsTable, {
        nameField: name,
        phoneField: phone,
        wasUpdatedField: 1
      },
          where: '$idField = ?',
          whereArgs: [contact.id]);
    }
  }


  ///Delete a contact from database
  Future<void> deleteContact({
    required String id
  }) async {
    bool hasInternet = await InternetConnection().hasInternetAccess;
    final contacts = await getAllContactsFromLocalStorage();
    final db = await sqlite.getDatabase;
    if (hasInternet) {
      await supabase.
      from(contactsTable).
      delete().
      eq(idField, id);

      await db.delete(
          contactsTable,
          where: '$idField=?',
          whereArgs: [id]
      );
      _mySink.add(contacts);
    }
    else {
      await db.delete(contactsTable, where: '$idField=?', whereArgs: [id]);
      _mySink.add(contacts);
      //throw Exception('connect to internet');
    }
   }



  ///Read a contact from supabase
  Future<Contact> getAContactFromSupabase({
    required String id
  }) async {
    final response = await supabase.
    from(contactsTable).
    select('*').
    eq(idField, id).
    limit(1).single();
    final data = Contact.fromDatabase(response);
    return data;
  }


  ///Read all data from supabase --tested
  Future<List<Contact>> getAllContacts() async {
    final list = <Contact>[];
    final response = await supabase.
    from(contactsTable).
    select('*');

    for (var element in response) {
      list.add(
          Contact.fromDatabase(
              element as Map<String, dynamic>
          ));
    }
    return list;
  }




}
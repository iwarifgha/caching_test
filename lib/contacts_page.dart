import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_test/locator.dart';
import 'package:supabase_test/service.dart';
import 'package:supabase_test/utils/createContactDialog.dart';
import 'package:supabase_test/utils/showDialog.dart';
import 'package:supabase_test/widgets/contact_tile_list.dart';

import 'contact_model.dart';


class AllContactsPage extends StatefulWidget {
    const AllContactsPage({Key? key,
      //required this.data
    }) : super(key: key);

   // final  List<Contact> data;

  @override
  State<AllContactsPage> createState() => _AllContactsPageState();
}

class _AllContactsPageState extends State<AllContactsPage> {

  //Variables ---------------
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final provider = locator<DataService>();
  late StreamSubscription<InternetStatus> sub;
  ValueNotifier<bool> isConnected = ValueNotifier(false);
   //-------------------------


  @override
  void initState() {
    sub = InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          isConnected.value = true;
          provider.syncContacts();
          print('connected');
          break;
        case InternetStatus.disconnected:
          isConnected.value = false;
          print('not connected');
          break;
      }
    });
    cacheContacts();
    super.initState();
  }



  cacheContacts() async {
     await provider.getAllContactsFromLocalStorage();
   }





  @override
  Widget build(BuildContext context) {

      return  Scaffold(
        body: ValueListenableBuilder(
            valueListenable: isConnected,
            builder: (_, value, __ ) {
              return StreamBuilder(
                  stream: value ? provider.contactsStream2 : provider.contactsStream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState){
                      case ConnectionState.waiting:
                        case ConnectionState.active:
                          if(snapshot.hasData){
                            final contactList = snapshot.data!;
                            if (contactList.isNotEmpty) {
                              return ListView.builder(
                                itemCount: contactList.length,
                                itemBuilder: (context, index){
                                  final contact = contactList[index];
                                  return  ContactTileList(
                                    context: context,
                                    contact: contact,
                                    onDetailsTapped: () {  },
                                    onDeleteTapped: (String id) {
                                      provider.deleteContact(id: id);
                                      setState(() {});
                                    },
                                    onEditTapped: () {
                                      _displayTextInputDialog(
                                        context: context,
                                        contact: contact,
                                        nameController: nameController,
                                        phoneController: phoneController,
                                        onSave: (Contact contact) {
                                          provider.updateContact(
                                              contactId: contact.id,
                                              name: nameController.text,
                                              phone: phoneController.text
                                          );
                                        },
                              
                                      );
                                    },
                                  );
                                }
                              );
                            }
                            else {
                              return const Center(
                                  child: Text('No contacts'));
                            }
                          }
                          else {
                            return const Center(
                                child:CircularProgressIndicator());
                          }
                          default:
                            return const Center(
                                child: CircularProgressIndicator());
                }

            }
          );
        }
      ),
        floatingActionButton: FloatingActionButton(
            onPressed: ( ) {
              try {
                createContactDialog(
                    context: context,
                    nameController: nameController,
                    phoneController: phoneController,
                    onSave: ( ) async {
                      await provider.createContact(nameController.text, phoneController.text);
                    }
                );
               } on Exception catch (e) {
                 showGenericDialog(context: context, title: 'Error', message: e.toString());
              }

            },
            child: const Icon(Icons.add),
        ),
    );
  }


  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  Future<void> _displayTextInputDialog( {
    required BuildContext context,
    required Contact contact,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required void Function(Contact contact) onSave
   // required VoidCallback onSave
}) async {
    nameController.text = contact.name;
    phoneController.text = contact.phone;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                    hintText: "name"),
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                    hintText: "phone"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              onPressed: (){
                onSave(contact);
                Navigator.pop(context);
              },
              child: const Text('OK')
            ),
          ],
        );
      },);
  }

}



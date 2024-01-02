import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../contact_model.dart';

enum MenuButton {editContact, deleteContact, showDetails}

class ContactTileList extends StatelessWidget {
  const ContactTileList({super.key,
    required this.contact,
    required this.onEditTapped,
    required this.onDeleteTapped,
    required this.onDetailsTapped,
    required this.context
  });
  
  final Contact contact;
  final BuildContext context;
  //final void Function(Contact contact) onEditTapped;
  final void Function(String id) onDeleteTapped;
  final VoidCallback onDetailsTapped;
  final VoidCallback onEditTapped;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact.name,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    letterSpacing: 3
                ),
              ),
              Text(contact.phone,
                style: const TextStyle(
                    fontSize: 25
                ),
              ),
            ],
          ),
          PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case MenuButton.editContact:
                    return onEditTapped();
                  case MenuButton.deleteContact:
                    return onDeleteTapped(contact.id);
                  case MenuButton.showDetails:
                    return;
                  default:
                    return;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                      value: MenuButton.editContact,
                      child: Text('Edit contact')
                  ),
                  PopupMenuItem(
                      value: MenuButton.showDetails,
                      child: Text('View details')
                  ),
                  PopupMenuItem(
                      value:  MenuButton.deleteContact,
                      child: Text('Delete contact')
                  )
                ];
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}

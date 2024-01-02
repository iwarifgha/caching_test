import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_test/contact_model.dart';





Future<String?> createContactDialog({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController phoneController,
  required VoidCallback onSave,
}){
  return showDialog<String>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Add contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: TextField(
                        controller: nameController,
                      )
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                      )
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              }
              ,child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave();

                if(phoneController.text.isEmpty || nameController.text.isEmpty){
                  return;
                }
                phoneController.clear();
                nameController.clear();
                Navigator.of(context).pop();
              } ,
              child: const Text('Save'),
            )],

        );
      }
  );
}
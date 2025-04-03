import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

Future<bool> checkAndRequestPermissions(BuildContext context) async {
  PermissionStatus phonePermission = await Permission.phone.status;
  PermissionStatus contactsPermission = await Permission.contacts.status;

  if (!phonePermission.isGranted) {
    if (await Permission.phone.request().isGranted) {
    } else {
      if (context.mounted) {
        showErrorAndCloseApp(context, 'Phone permission is required.');
      }
      return false;
    }
  }

  if (!contactsPermission.isGranted) {
    if (await Permission.contacts.request().isGranted) {
    } else {
      if (context.mounted) {
        showErrorAndCloseApp(context, 'Contacts permission is required.');
      }
      return false;
    }
  }

  return true;
}

void showErrorAndCloseApp(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Permission Denied'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Close App'),
            onPressed: () {
              Navigator.of(context).pop();
              exit(0);
            },
          ),
        ],
      );
    },
  );
}

import 'package:apptitude_ace_network/Theme/Constants.dart';
import 'package:apptitude_ace_network/Widgets/Messages.dart';
import 'package:flutter/material.dart';

Future<void> showConfirm(
    {required BuildContext context,
    required String confirmation,
    required String testId}) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return AlertDialog(
      title: Text(
        'Are you sure',
        style: style,
      ),
      content: Text(
        confirmation,
        style: style,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: style,
          ),
        ),
        TextButton(
          onPressed: () async {
            await test.doc(testId).delete();
            showSuccess(context, "Test Deleted");
            Navigator.of(context).pop();
          },
          child: Text(
            'Delete',
            style: style,
          ),
        ),
      ],
    );
  }));
}

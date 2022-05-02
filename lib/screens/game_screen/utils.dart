import 'package:flutter/material.dart';

Future<bool> confirmQuit(context) async {
  bool exit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Quit game?'),
          content: Text('Are you sure you want to quit the game?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ) ??
      false;
  return exit;
}

Future<void> confirmQuitAndQuit(context) async {
  bool exit = await confirmQuit(context);
  if (exit) {
    Navigator.pop(context);
  }
}

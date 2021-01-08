import 'package:flutter/material.dart';

class PlayerField extends StatelessWidget {
  const PlayerField({
    Key key,
    this.playerName,
    this.delete,
  }) : super(key: key);

  final String playerName;
  final VoidCallback delete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context).pop();
                      this.delete();
                    },
                    child: const Text('Fjern spiller'),
                  ),
                ],
              );
            });
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            playerName,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}

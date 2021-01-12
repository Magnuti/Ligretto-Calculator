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
      onLongPress: () => _showRemovePlayerDialog(context),
      onTap: () => _showRemovePlayerDialog(context),
      child: Card(
        margin: EdgeInsets.only(
          top: 12.0,
          left: 8.0,
          right: 8.0,
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 12.0),
          child: Text(
            playerName,
            style: TextStyle(fontSize: 22.0),
          ),
        ),
      ),
    );
  }

  void _showRemovePlayerDialog(BuildContext context) {
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
  }
}

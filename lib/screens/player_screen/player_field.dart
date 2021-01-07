import 'package:flutter/material.dart';

class PlayerField extends StatelessWidget {
  const PlayerField({
    Key key,
    this.playerName,
  }) : super(key: key);

  final String playerName;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          playerName,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

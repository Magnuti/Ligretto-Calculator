import 'package:flutter/material.dart';
import 'package:ligretto_calculator/screens/player_screen/new_player_dialog.dart';
import 'package:ligretto_calculator/screens/player_screen/player_field.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<String> _players = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: _listBody()),
              RaisedButton(
                onPressed: () => null,
                child: Text("Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listBody() {
    List<Widget> elements = [];
    for (String player in _players) {
      elements.add(PlayerField(playerName: player));
    }
    elements.add(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        child: RaisedButton.icon(
          onPressed: () => showDialog(
            context: context,
            child: NewPlayerDialog(
              submit: (String value) {
                setState(() {
                  _players.add(value);
                });
                Navigator.of(context).pop();
              },
              cancel: () => Navigator.of(context).pop(),
            ),
          ),
          icon: Icon(Icons.add),
          label: Text('Legg til spiller'),
        ),
      ),
    );
    return ListView(children: elements);
  }
}

import 'package:flutter/material.dart';
import 'package:ligretto_calculator/screens/game_screen/game_screen.dart';
import 'package:ligretto_calculator/screens/player_screen/new_player_dialog.dart';
import 'package:ligretto_calculator/screens/player_screen/player_field.dart';
import 'package:ligretto_calculator/res/colors.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<String> _players = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _showNew..() must be called inside WidgetBi..() funtion as it must finish building.
      // Maybe because Scaffold is not build yet?
      _showNewNameDialog(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: _listBody()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 24.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(
                          players: _players,
                          scores: Map.fromIterable(_players,
                              key: (e) => e, value: (e) => 0),
                          round: 1,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Start",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
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
      elements.add(PlayerField(
          playerName: player,
          delete: () {
            setState(() {
              _players.remove(player);
            });
          }));
    }
    elements.add(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        child: ElevatedButton.icon(
          onPressed: () => _showNewNameDialog(false),
          icon: Icon(Icons.add),
          label: Text('Add players'),
          style: ElevatedButton.styleFrom(backgroundColor: darkBlue),
        ),
      ),
    );
    return ListView(children: elements);
  }

  Future<void> _showNewNameDialog(bool firstTime) async {
    showDialog(
      context: context,
      barrierDismissible: !firstTime,
      builder: (context) {
        return NewPlayerDialog(
          playersSoFar: _players,
          submit: (String value) {
            setState(() {
              _players.add(value);
            });
            Navigator.of(context).pop();
          },
          cancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}

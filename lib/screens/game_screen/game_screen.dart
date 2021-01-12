import 'package:flutter/material.dart';
import 'package:ligretto_calculator/screens/game_screen/next_round_overlay.dart';
import 'package:ligretto_calculator/screens/game_screen/points_input.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    Key key,
    @required this.players,
  }) : super(key: key);

  final List<String> players;
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Map<String, int> _scores = {};
  Map<String, int> _decrementPoints = {};
  Map<String, int> _incrementPoints = {};
  List<String> _sortedNames = [];
  int _round = 1;

  @override
  void initState() {
    super.initState();
    _scores = Map.fromIterable(widget.players, key: (e) => e, value: (e) => 0);
    _decrementPoints =
        Map.fromIterable(widget.players, key: (e) => e, value: (e) => 0);
    _incrementPoints =
        Map.fromIterable(widget.players, key: (e) => e, value: (e) => 0);
    // _sortedNames = _calculateSortedPlayers();
    // No need to calculate any ranking now as all are 0
    _sortedNames = _scores.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _confirmQuit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Runde $_round'),
          centerTitle: true,
          leading: IconButton(
            onPressed: _confirmQuit,
            icon: Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: () => null,
              icon: Icon(Icons.help_outline),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _topText('Minuspoeng'),
                  _topText('Plusspoeng'),
                  _topText('Totalt'),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _sortedNames.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              _sortedNames[index],
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              PointsInput(
                                points: _decrementPoints[_sortedNames[index]],
                                decrement: () {
                                  setState(() {
                                    _decrementPoints[_sortedNames[index]] -= 2;
                                    _scores[_sortedNames[index]] -= 2;
                                  });
                                },
                                increment: () {
                                  setState(() {
                                    _decrementPoints[_sortedNames[index]] += 2;
                                    _scores[_sortedNames[index]] += 2;
                                  });
                                },
                                canBePositive: false,
                              ),
                              PointsInput(
                                points: _incrementPoints[_sortedNames[index]],
                                decrement: () {
                                  setState(() {
                                    _incrementPoints[_sortedNames[index]] -= 1;
                                    _scores[_sortedNames[index]] -= 1;
                                  });
                                },
                                increment: () {
                                  setState(() {
                                    _incrementPoints[_sortedNames[index]] += 1;
                                    _scores[_sortedNames[index]] += 1;
                                  });
                                },
                                canBeNegative: false,
                              ),
                              Center(
                                child: Container(
                                  // So that the points row elements stay still when the size changes
                                  width: 44,
                                  child: Text(
                                    '${_scores[_sortedNames[index]]}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
                onPressed: () {
                  setState(() {
                    for (String player in widget.players) {
                      _decrementPoints[player] = 0;
                      _incrementPoints[player] = 0;
                    }
                    _sortedNames = _calculateSortedPlayers();
                    _round++;
                  });
                  Navigator.of(context).push(NextRoundOverlay());
                },
                child: Text(
                  'Neste runde',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmQuit() async {
    bool exit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Advarsel'),
            content: Text('Er du sikker på at du vil avslutte spillet?'),
            actions: [
              TextButton(
                child: Text('Nei'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Ja'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
    if (exit) {
      Navigator.pop(context);
    }
  }

  List<String> _calculateSortedPlayers() {
    return _scores.keys.toList()
      ..sort((k1, k2) => _scores[k2].compareTo(_scores[k1]));
  }

  Text _topText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[600]),
    );
  }
}

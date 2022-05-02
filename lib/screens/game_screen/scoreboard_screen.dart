import 'package:flutter/material.dart';
import 'package:ligretto_calculator/res/custom_icons.dart';
import 'package:ligretto_calculator/screens/game_screen/game_screen.dart';
import 'package:ligretto_calculator/screens/game_screen/utils.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({
    Key? key,
    required this.players,
    required this.round,
    required this.scores,
  }) : super(key: key);

  final List<String> players;
  final Map<String, int> scores;
  final int round;

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  late List<String> _sortedNames;
  @override
  void initState() {
    super.initState();

    // Sort the players in descending order
    _sortedNames = widget.scores.keys.toList()
      ..sort((k1, k2) => widget.scores[k2]!.compareTo(widget.scores[k1]!));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => confirmQuit(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Finished round ${widget.round}'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => confirmQuitAndQuit(context),
            icon: Icon(Icons.close),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _sortedNames.length,
                itemBuilder: (context, index) {
                  final String player = _sortedNames[index];
                  final int playerScore = widget.scores[player]!;
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      bottom: 16.0,
                      left: 8.0,
                      right: 24.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          child: index == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Icon(CustomIcons.crown),
                                )
                              : Container(),
                        ),
                        Expanded(
                          child: Text(
                            player,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Text(
                          playerScore.toString(),
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => Divider(
                  thickness: 1.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(
                        players: widget.players,
                        scores: widget.scores,
                        round: widget.round + 1,
                      ),
                    ),
                  ),
                },
                child: Text(
                  'Next round',
                  style: TextStyle(fontSize: 16.0),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

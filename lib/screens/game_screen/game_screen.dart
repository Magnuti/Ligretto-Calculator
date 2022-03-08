import 'package:flutter/material.dart';
import 'package:ligretto_calculator/screens/game_screen/next_round_overlay.dart';
import 'package:ligretto_calculator/screens/game_screen/points_input.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    Key? key,
    required this.players,
  }) : super(key: key);

  final List<String> players;
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final AnimationController _roundInController;
  late final AnimationController _roundOutController;

  late final Animation<Offset> _roundInOffsetAnimation;
  late final Animation<Offset> _roundOutOffsetAnimation;

  Map<String, int> _scores = {};
  Map<String, int> _cardsInLigretto = {};
  Map<String, int> _cardsInCenter = {};
  List<String> _sortedNames = [];
  int _round = 1;
  bool _isFillingInMinusPoints = true;

  @override
  void initState() {
    super.initState();
    _roundInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _roundOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _roundInOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 5.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _roundInController,
      curve: Curves.easeOut,
    ));

    _roundOutOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -5.0),
    ).animate(CurvedAnimation(
      parent: _roundOutController,
      curve: Curves.easeIn, // TODO check in vs. out
    ));

    _scores = Map.fromIterable(widget.players, key: (e) => e, value: (e) => 0);
    _cardsInLigretto =
        Map.fromIterable(widget.players, key: (e) => e, value: (e) => 0);
    _cardsInCenter =
        Map.fromIterable(widget.players, key: (e) => e, value: (e) => 0);
    // _sortedNames = _calculateSortedPlayers();
    // No need to calculate any ranking now as all are 0
    _sortedNames = _scores.keys.toList();
  }

  @override
  void dispose() {
    super.dispose();
    _roundInController.dispose();
    _roundOutController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _confirmQuit().then((value) => value as bool),
      child: Scaffold(
        appBar: AppBar(
          title: Stack(
            children: [
              SlideTransition(
                position: _roundInOffsetAnimation,
                child: Text('Round $_round'),
              ),
              SlideTransition(
                position: _roundOutOffsetAnimation,
                child: Text('Round $_round'),
              ),
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: _confirmQuit,
            icon: Icon(Icons.close),
          ),
          // actions: [
          //   IconButton(
          //     onPressed: () => null,
          //     icon: Icon(Icons.help_outline),
          //   ),
          // ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                // TODO add bold text to 'Ligretto' and 'center'
                _isFillingInMinusPoints
                    ? 'How many cards in the Ligretto'
                    : 'How many cards in the center',
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _sortedNames.length,
                itemBuilder: (context, index) {
                  final String player = _sortedNames[index];
                  final int playerScore = _scores[player]!;
                  final int playerCardsInCenter = _cardsInCenter[player]!;
                  final int playerCardsInLigretto = _cardsInLigretto[player]!;

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
                              player,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Row(
                            children: [
                              // Cards in Ligretto points
                              AnimatedDefaultTextStyle(
                                child: Text(
                                    '- ${_cardsInLigretto[player]! * 2} points'),
                                style: TextStyle(
                                    fontSize:
                                        _isFillingInMinusPoints ? 0.0 : 18.0,
                                    color: Colors.black),
                                duration: Duration(milliseconds: 400),
                              ),
                              // Plus and minus point button
                              Expanded(
                                child: AnimatedAlign(
                                  alignment: _isFillingInMinusPoints
                                      ? Alignment.centerLeft
                                      : Alignment.center,
                                  duration: Duration(milliseconds: 400),
                                  child: PointsInput(
                                    cards: _isFillingInMinusPoints
                                        ? playerCardsInLigretto
                                        : playerCardsInCenter,
                                    decrement: () {
                                      if (_isFillingInMinusPoints) {
                                        setState(() {
                                          _cardsInLigretto[player] =
                                              playerCardsInLigretto - 1;
                                          _scores[player] = playerScore + 2;
                                        });
                                      } else {
                                        setState(() {
                                          _cardsInCenter[player] =
                                              playerCardsInCenter - 1;
                                          _scores[player] = playerScore - 1;
                                        });
                                      }
                                    },
                                    increment: () {
                                      if (_isFillingInMinusPoints) {
                                        setState(() {
                                          _cardsInLigretto[player] =
                                              playerCardsInLigretto + 1;
                                          _scores[player] = playerScore - 2;
                                        });
                                      } else {
                                        setState(() {
                                          _cardsInCenter[player] =
                                              playerCardsInCenter + 1;
                                          _scores[player] = playerScore + 1;
                                        });
                                      }
                                    },
                                    negativePoints: _isFillingInMinusPoints,
                                  ),
                                ),
                              ),
                              // Total points
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 54.0,
                                      child: Center(
                                        child: Text(
                                          '${_scores[_sortedNames[index]]}',
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Total points',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isFillingInMinusPoints
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isFillingInMinusPoints = true;
                              });
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_isFillingInMinusPoints) {
                          setState(() {
                            _isFillingInMinusPoints = false;
                          });
                        } else {
                          await Navigator.of(context).push(NextRoundOverlay());
                          await _roundOutController.forward();
                          setState(() {
                            for (String player in widget.players) {
                              _cardsInLigretto[player] = 0;
                              _cardsInCenter[player] = 0;
                            }
                            _sortedNames = _calculateSortedPlayers();
                            _round++;
                            _isFillingInMinusPoints = true;
                          });
                          await _roundInController.forward();
                          _roundOutController.reset();
                          _roundInController.reset();
                        }
                      },
                      child: Text(
                        // TODO change button, maybe a FloatingActionButton
                        _isFillingInMinusPoints ? 'Continue' : 'Next round',
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
          ],
        ),
      ),
    );
  }

  Future<void> _confirmQuit() async {
    bool exit = await showDialog(
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
    if (exit) {
      Navigator.pop(context);
    }
  }

  List<String> _calculateSortedPlayers() {
    return _scores.keys.toList()
      ..sort((k1, k2) => _scores[k2]!.compareTo(_scores[k1]!));
  }
}

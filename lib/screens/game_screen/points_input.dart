import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For vibration

import 'package:holding_gesture/holding_gesture.dart';

class PointsInput extends StatefulWidget {
  const PointsInput({
    Key? key,
    required this.cards,
    required this.decrement,
    required this.increment,
    required this.negativePoints,
  }) : super(key: key);

  final int cards;
  final VoidCallback decrement;
  final VoidCallback increment;
  final bool negativePoints;

  @override
  _PointsInputState createState() => _PointsInputState();
}

class _PointsInputState extends State<PointsInput> {
  double _iconSize = 28.0;
  Duration _holdTickTime = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 54.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HoldDetector(
                holdTimeout: _holdTickTime,
                onHold: widget.cards > 0
                    ? () {
                        widget.decrement();
                        HapticFeedback.lightImpact();
                      }
                    : () {}, // Cannot take in null
                child: IconButton(
                  onPressed: widget.cards > 0 ? () => widget.decrement() : null,
                  icon: Icon(Icons.remove_circle),
                  iconSize: _iconSize,
                ),
              ),
              Container(
                width: 70.0, // Works for 3 digits (e.g. -12)
                child: Center(
                  child: Text(
                    widget.cards == 1
                        ? '${widget.cards} card '
                        : '${widget.cards} cards',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              HoldDetector(
                holdTimeout: _holdTickTime,
                onHold: () {
                  widget.increment();
                  HapticFeedback.lightImpact();
                },
                child: IconButton(
                  onPressed: () => widget.increment(),
                  icon: Icon(Icons.add_circle),
                  iconSize: _iconSize,
                ),
              ),
            ],
          ),
        ),
        widget.negativePoints
            ? Text('- ${widget.cards * 2} points')
            : Text('+ ${widget.cards} points'),
      ],
    );
  }
}

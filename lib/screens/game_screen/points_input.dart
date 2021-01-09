import 'package:flutter/material.dart';

class PointsInput extends StatefulWidget {
  const PointsInput({
    Key key,
    @required this.points,
    @required this.decrement,
    @required this.increment,
    this.canBeNegative = true,
    this.canBePositive = true,
  }) : super(key: key);

  final int points;
  final VoidCallback decrement;
  final VoidCallback increment;
  final bool canBeNegative;
  final bool canBePositive;

  @override
  _PointsInputState createState() => _PointsInputState();
}

class _PointsInputState extends State<PointsInput> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.points.toString());
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: widget.canBeNegative || widget.points > 0
              ? () => widget.decrement()
              : null,
          icon: Icon(Icons.remove_circle),
        ),
        Container(
          width: 20.0, // Works for 3 digits (e.g. -12)
          child: Center(
            child: Text(widget.points.toString()),
          ),
        ),
        IconButton(
          onPressed: widget.canBePositive || widget.points < 0
              ? () => widget.increment()
              : null,
          icon: Icon(Icons.add_circle),
        ),
      ],
    );
  }
}

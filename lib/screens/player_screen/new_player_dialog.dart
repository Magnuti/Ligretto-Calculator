import 'package:flutter/material.dart';

class NewPlayerDialog extends StatefulWidget {
  const NewPlayerDialog({
    Key? key,
    required this.playersSoFar,
    required this.submit,
    required this.cancel,
  }) : super(key: key);

  final List<String> playersSoFar;
  final Function(String) submit;
  final VoidCallback cancel;

  @override
  _NewPlayerDialogState createState() => _NewPlayerDialogState();
}

class _NewPlayerDialogState extends State<NewPlayerDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: _hintText(widget.playersSoFar.length + 1),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill out a name';
            } else if (widget.playersSoFar.contains(value.trim())) {
              return '${value.trim()} is already in the game';
            }
            return null;
          },
        ),
      ),
      actions: [
        widget.playersSoFar.length == 0
            ? Container()
            : TextButton(
                child: const Text('Cancel'),
                onPressed: () => widget.cancel(),
              ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.submit(_controller.text.trim());
            }
          },
        )
      ],
    );
  }

  String _hintText(int playerNumber) {
    switch (playerNumber) {
      case 1:
        return 'Name of the first player';
      case 2:
        return 'Name of the 2nd player';
      case 3:
        return 'Name of the 3rd player';
      default:
        return 'Name of the ${playerNumber}th player';
    }
  }
}

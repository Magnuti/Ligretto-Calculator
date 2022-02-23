import 'package:flutter/material.dart';

class NewPlayerDialog extends StatefulWidget {
  const NewPlayerDialog({
    Key? key,
    required this.firstTime,
    required this.submit,
    required this.cancel,
  }) : super(key: key);

  final bool firstTime;
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
              hintText: widget.firstTime
                  ? 'Name of the first player'
                  : 'Player name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill out a name';
            }
            return null;
          },
        ),
      ),
      actions: [
        widget.firstTime
            ? Container()
            : TextButton(
                child: const Text('Cancel'),
                onPressed: () => widget.cancel(),
              ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.submit(_controller.text);
            }
          },
        )
      ],
    );
  }
}

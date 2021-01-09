import 'package:flutter/material.dart';

class NewPlayerDialog extends StatefulWidget {
  const NewPlayerDialog({
    Key key,
    @required this.firstTime,
    @required this.submit,
    @required this.cancel,
  }) : super(key: key);

  final bool firstTime;
  final Function(String) submit;
  final VoidCallback cancel;

  @override
  _NewPlayerDialogState createState() => _NewPlayerDialogState();
}

class _NewPlayerDialogState extends State<NewPlayerDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller;

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
              border: UnderlineInputBorder(), hintText: 'Navn på spiller'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Vennligst fyll ut et navn';
            }
            return null;
          },
        ),
      ),
      actions: [
        widget.firstTime
            ? Container()
            : FlatButton(
                child: const Text('Avbryt'),
                onPressed: () => widget.cancel(),
              ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              widget.submit(_controller.text);
            }
          },
        )
      ],
    );
  }
}

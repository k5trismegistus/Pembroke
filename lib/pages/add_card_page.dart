import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pembroke/repositories/card_repository.dart';
import 'package:pembroke/models/card.dart' as models;

class AddCardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
  }
}

class _AddCardPageState extends State<AddCardPage> {
  String _inputtingText = '';
  final CardRepository cardRepository = new CardRepository();

  void onSaveCard() {
    new models.Card(
      text: _inputtingText,
      language: 'en_US',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "テキストボックス",
            hintText: "まぁ何か入力してみてよ！",
          ),
          onChanged: (text) {
            setState(() {
              this._inputtingText = text;
            });
          }
        ),
        RaisedButton(
          color: Colors.cyan.shade600,
          onPressed: onSaveCard,
          child: new Text(
            'Save',
            style: const TextStyle(color: Colors.white),
          ),
        )
      ]
    );
  }
}


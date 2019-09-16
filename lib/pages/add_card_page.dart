import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pembroke/constants/constants.dart';
import 'package:pembroke/pages/card_list_page.dart';
import 'package:pembroke/repositories/card_repository.dart';
import 'package:pembroke/models/card.dart' as models;

class AddCardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  String _inputtingText = '';
  // マジックナンバー
  Language _language = LANGUAGES[0];
  final CardRepository cardRepository = new CardRepository();

  void onSaveCard() async {
    final card = new models.Card(
      text: _inputtingText,
      language: _language.code,
    );

    await cardRepository.insertCard(card);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardListPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('SpeechRecognition'),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 6),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Input text here",
                  hintText: "Text",
                ),
                onChanged: (text) {
                  setState(() {
                    this._inputtingText = text;
                  });
                }
              ),
            ),
            Padding(
              padding:EdgeInsets.only(right:8),
              child: DropdownButton<Language>(
                value: _language,
                onChanged: (Language newValue) {
                  setState(() {
                    _language = newValue;
                  });
                },
                items: LANGUAGES
                  .map<DropdownMenuItem<Language>>((Language value) {
                    return DropdownMenuItem<Language>(
                      value: value,
                      child: Text(value.name),
                    );
                  })
                  .toList(),
              )
            ),
            Padding(
              padding: EdgeInsets.only(right:8),
              child: Align(
                alignment: Alignment.topRight,
                child: RaisedButton(
                  color: Colors.cyan.shade600,
                  onPressed: onSaveCard,
                  child: new Text(
                    'Save',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              )
            ),
          ]
        ),
      )
    );
  }
}


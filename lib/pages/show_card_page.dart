import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pembroke/models/card.dart' as models;
import 'package:pembroke/utils/voice_recognizer.dart';

class ShowCardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ShowCardPageState();
}

class _ShowCardPageState extends State<ShowCardPage> {
  models.Card currentCard;
  String answer = '';
  bool isAnsering = false;
  VoiceRecognizer voice_recognizer = VoiceRecognizerStore.get_instance();

  void onStartAnswering() async {
    await voice_recognizer.startListening(currentCard.lang());
    setState(() {
      answer = '';
      isAnsering = true;
    });
  }

  void onCancelAnswering() async {
    await voice_recognizer.cancelListening();
    setState(() {
      isAnsering = false;
    });
  }

  void onCompleteAnswering() async {
    var res = await voice_recognizer.finishListening();
    setState(() {
      isAnsering = false;
      answer = res;
    });
  }

  void onPressButton() {
    if (isAnsering) {
      onCompleteAnswering();
    } else {
      onStartAnswering();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('SpeechRecognition'),
        actions: [],
      ),
      body: Column(
        children: <Widget>[
          Text(currentCard.text),
          Text(answer),
          RaisedButton(
            color: Colors.cyan.shade600,
            onPressed: onPressButton,
            child: new Text(
              isAnsering ? 'Finish' : 'Start',
              style: const TextStyle(color: Colors.white),
            ),
          )
        ]
      ),
    );
  }
}
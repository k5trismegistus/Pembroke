import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pembroke/models/card.dart' as models;
import 'package:pembroke/utils/text_to_speech.dart';
import 'package:pembroke/utils/voice_recognizer.dart';

class ShowCardPage extends StatefulWidget {
  final models.Card currentCard;

  ShowCardPage({Key key, @required this.currentCard}) : super(key: key);


  @override
  State<StatefulWidget> createState() => new _ShowCardPageState();
}

class _ShowCardPageState extends State<ShowCardPage> {
  String answer = '';
  bool isAnsering = false;
  VoiceRecognizer voiceRecognizer = VoiceRecognizerStore.getInstance();

  void onStartAnswering() async {
    await voiceRecognizer.startListening(widget.currentCard.lang());
    setState(() {
      answer = '';
      isAnsering = true;
    });
  }

  void onCancelAnswering() async {
    await voiceRecognizer.cancelListening();
    setState(() {
      isAnsering = false;
    });
  }

  void onCompleteAnswering() async {
    var res = await voiceRecognizer.finishListening();
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

  void onPressPlayButton() {
    var _textToSpeech = TextToSpeechStore.getInstance();
    _textToSpeech.speak(widget.currentCard.text, widget.currentCard.lang());
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
          Text(widget.currentCard.text),
          Text(answer),
          RaisedButton(
            color: Colors.cyan.shade600,
            onPressed: onPressPlayButton,
            child: new Text(
              'Play',
              style: const TextStyle(color: Colors.white),
            ),
          ),
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
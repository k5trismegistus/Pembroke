import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pembroke/models/card.dart' as models;
import 'package:pembroke/repositories/card_repository.dart';
import 'package:pembroke/utils/text_to_speech.dart';
import 'package:pembroke/utils/voice_recognizer.dart';

class ShowCardWidget extends StatefulWidget {
  final models.Card currentCard;

  ShowCardWidget({Key key, @required this.currentCard}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ShowCardWidgetState();
}

class _ShowCardWidgetState extends State<ShowCardWidget> {
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

  void onPressPlayButton() async {
    var _textToSpeech = TextToSpeechStore.getInstance();

    print(widget.currentCard.lang().code);
    if (!(await _textToSpeech.checkIsLanguageAvailable(widget.currentCard.lang()))) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Language not available"),
            content: Text("This language is not installed"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
      return;
    }
    _textToSpeech.speak(widget.currentCard.text, widget.currentCard.lang());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
      );
  }
}

class ShowCardPage extends StatefulWidget {
  final models.Card currentCard;
  final List<int> cardIds;

  ShowCardPage({Key key, @required this.currentCard, @required this.cardIds}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ShowCardPageState();
}

class _ShowCardPageState extends State<ShowCardPage> {
  final CardRepository cardRepository = new CardRepository();

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: widget.cardIds.indexOf(widget.currentCard.id));

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('SpeechRecognition'),
          actions: [],
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: (widget.cardIds.length + 1),
          itemBuilder: (BuildContext context, int index) {
            if (index == widget.cardIds.length) {
              return Center(child: Text('Finished'));
            }

            var cardFuture = cardRepository.getCardById(widget.cardIds[index]);

            return FutureBuilder(
              future: cardFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ShowCardWidget(currentCard: snapshot.data);
              }
            );
          },
        )
      );
  }
}
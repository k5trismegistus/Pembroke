import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pembroke/repositories/card_repository.dart';
import 'package:pembroke/models/card.dart' as models;
import 'package:pembroke/pages/show_card_page.dart';

class CardListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  List<models.Card> cards;
  final CardRepository cardRepository = new CardRepository();
  List<models.Card> _cardList = [];

  @override
  void initState() {
    super.initState();
    loadCards(0);
  }

  Future loadCards(offset) async {
    cards = await cardRepository.listCard(offset: offset);
    setState(() {
      _cardList.addAll(cards);
    });
  }

  Widget _buildCard(BuildContext context, models.Card card) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 33,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new ShowCardPage(currentCard: card)),
          );
        },
        child: Column(
          children: <Widget>[
            Container(
              height: 52,
              padding: const EdgeInsets.only(left: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Align(
                  alignment: const FractionalOffset(0, 0.5),
                  child: Text(
                    card.text,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ]),
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return new NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification value) {
          if (value.metrics.extentAfter == 0.0) {
            this.loadCards(_cardList.length);
          }
        },
        child: ListView.builder(
          itemCount: _cardList.length,
          itemBuilder: (BuildContext context, int index) => _buildCard(context, _cardList[index],)
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('SpeechRecognition'),
        actions: [],
      ),
      body: _buildList(context)
    );
  }
}


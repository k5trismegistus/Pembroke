import 'package:pembroke/constants/constants.dart';

class Card {
  final int id;
  final String text;
  final String language; // Language code

  Card({this.id, this.text, this.language});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'language': language,
    };
  }

  Language lang() {
    return LANGUAGES.where((l) => l.code == language).toList()[0];
  }

  static Card fromMap(Map<String, dynamic> map) {
    return Card(id: map['id'], text: map['text'], language: map['language']);
  }
}
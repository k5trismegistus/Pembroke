class Card {
  final int id;
  final String text;
  final String language;

  Card({this.id, this.text, this.language});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'language': language,
    };
  }
}
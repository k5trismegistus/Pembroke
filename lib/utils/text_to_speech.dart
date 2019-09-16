import 'package:flutter_tts/flutter_tts.dart';
import 'package:pembroke/constants/constants.dart';

class TextToSpeechStore {
  static bool initialized = false;
  static TextToSpeech _textToSpeech;

  static void initialize() {
    _textToSpeech = new TextToSpeech();
    initialized = true;
  }

  static TextToSpeech getInstance() {
    if (!initialized) {
      initialize();
    }
    return _textToSpeech;
  }
}

class TextToSpeech {
  FlutterTts _flutterTts;

  TextToSpeech() {
    _flutterTts = new FlutterTts();
  }

  Future checkIsLanguageAvailable(Language lang) async {
    return await _flutterTts.isLanguageAvailable(lang.code);
  }

  Future speak(String text, Language lang) async{
    await _flutterTts.setLanguage(lang.code);
    await _flutterTts.speak(text);
  }
}
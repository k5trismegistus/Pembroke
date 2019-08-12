import 'package:speech_recognition/speech_recognition.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:pembroke/constants/constants.dart';

class VoiceRecognizerStore {
  static bool initialized = false;
  static VoiceRecognizer _voice_recognizer;

  static void initialize() {
    _voice_recognizer = new VoiceRecognizer();
    initialized = true;
  }

  static VoiceRecognizer get_instance () {
    if (!initialized) {
      initialize();
    }
    return _voice_recognizer;
  }
}

class VoiceRecognizer {
  bool _voice_regcognition_permitted = false;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  SpeechRecognition _speech;

  Future<bool> requirePermission() async {
    if (!await SimplePermissions.checkPermission(Permission.RecordAudio)) {
      var res = await SimplePermissions.requestPermission(Permission.RecordAudio);
      return res == PermissionStatus.authorized;
    } else {
      return true;
    }
  }

    // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() async {
    _speech = new SpeechRecognition();
    // _speech.setAvailabilityHandler(onSpeechAvailability);
    // _speech.setCurrentLocaleHandler(onCurrentLocale);
    // _speech.setRecognitionStartedHandler(onRecognitionStarted);
    // _speech.setRecognitionResultHandler(onRecognitionResult);
    // _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    // _speech.setErrorHandler(errorHandler);

    _voice_regcognition_permitted = await requirePermission();;
    _speechRecognitionAvailable = await _speech.activate();
  }

  void startListening(Language lang) async {
    var langCode = lang.code;

    _isListening = true;
    await _speech.listen(locale: langCode)
  }

  void cancelListening() async {
    _isListening = false;
    await _speech.cancel();
  }

  Future<String> finishListening() async {
    var result = await _speech.stop();
    return result;
  }
}
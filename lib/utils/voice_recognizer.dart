import 'package:speech_recognition/speech_recognition.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:pembroke/constants/constants.dart';

class VoiceRecognizerStore {
  static bool initialized = false;
  static VoiceRecognizer _voiceRecognizer;

  static void initialize() {
    _voiceRecognizer = new VoiceRecognizer();
    initialized = true;
  }

  static VoiceRecognizer getInstance () {
    if (!initialized) {
      initialize();
    }
    return _voiceRecognizer;
  }
}

class VoiceRecognizer {
  bool _voiceRecognitionPermitted = false;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String _lastRecognizedText = '';

  SpeechRecognition _speech;

  VoiceRecognizer() {
    activateSpeechRecognizer();
  }

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
    _speech.setRecognitionStartedHandler(() {
      _lastRecognizedText = '';
      _isListening = true;
    });
    _speech.setRecognitionResultHandler((String recognizedText) {
      _lastRecognizedText = recognizedText;
    });
    _speech.setRecognitionCompleteHandler(() {
      _isListening = false;
    });
    // _speech.setErrorHandler(errorHandler);

    _voiceRecognitionPermitted = await requirePermission();;
    _speechRecognitionAvailable = await _speech.activate();
  }

  void startListening(Language lang) async {
    var langCode = lang.code;
    await _speech.listen(locale: langCode);
  }

  void cancelListening() async {
    _isListening = false;
    await _speech.cancel();
  }

  Future<String> finishListening() async {
    await _speech.stop();
    print(_lastRecognizedText);
    return _lastRecognizedText;
  }
}
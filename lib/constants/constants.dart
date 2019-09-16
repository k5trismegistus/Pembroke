const LANGUAGES = const [
  const Language('English (US)', 'en-US'),
  const Language('English (UK)', 'en-UK'),
  const Language('日本語', 'ja-JP'),
  const Language('Francais', 'fr-FR'),
  const Language('Pусский', 'ru-RU'),
  const Language('Italiano', 'it-IT'),
  const Language('Español', 'es-ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}
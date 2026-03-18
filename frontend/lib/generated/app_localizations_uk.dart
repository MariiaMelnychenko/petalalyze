// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Petalalyze';

  @override
  String get home => 'Головна';

  @override
  String get homeTitle =>
      'Відскануйте свій букет та дізнайтесь, які квіти в ньому ❀';

  @override
  String get catalog => 'Каталог';

  @override
  String get flowers => 'Квіти';

  @override
  String get detections => 'Історія';

  @override
  String get history => 'Історія розпізнавань';

  @override
  String get settings => 'Налаштування';

  @override
  String get errorGeneric => 'Щось пішло не так. Спробуйте ще раз.';

  @override
  String get errorNetwork => 'Помилка мережі. Перевірте з\'єднання.';

  @override
  String get errorNotFound => 'Не знайдено';

  @override
  String get retry => 'Повторити';

  @override
  String get loading => 'Завантаження...';

  @override
  String get search => 'Пошук...';

  @override
  String get howItWorks => 'Як це працює';

  @override
  String get photo => 'Фото';

  @override
  String get import => 'Імпорт';

  @override
  String get historySection => 'Історія';

  @override
  String get step1Title => 'Скануй букет';

  @override
  String get step1Text => 'Зробіть фото букета або завантажте з галереї.';

  @override
  String get step2Title => 'AI розпізнає квіти';

  @override
  String get step2Text =>
      'Модель аналізує фото та визначає всі квіти у букеті.';

  @override
  String get step3Title => 'Дізнайтесь більше';

  @override
  String get step3Text =>
      'Отримайте назви квітів, впевненість моделі та інформацію про них.';

  @override
  String get noDetectionsYet =>
      'Ще не було розпізнавань. Зробіть фото букета, щоб почати!';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru')
  ];

  /// No description provided for @salem.
  ///
  /// In ru, this message translates to:
  /// **'Salem!'**
  String get salem;

  /// No description provided for @helper_text.
  ///
  /// In ru, this message translates to:
  /// **'Твой помощник при ЕНТ!'**
  String get helper_text;

  /// No description provided for @register.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get register;

  /// No description provided for @login.
  ///
  /// In ru, this message translates to:
  /// **'Вход'**
  String get login;

  /// No description provided for @username.
  ///
  /// In ru, this message translates to:
  /// **'Имя пользователя'**
  String get username;

  /// No description provided for @email.
  ///
  /// In ru, this message translates to:
  /// **'Электронная почта'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждение пароля'**
  String get confirm_password;

  /// No description provided for @have_account.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт? Войти'**
  String get have_account;

  /// No description provided for @no_account.
  ///
  /// In ru, this message translates to:
  /// **'Нет аккаунта? Зарегистрироваться'**
  String get no_account;

  /// No description provided for @rus.
  ///
  /// In ru, this message translates to:
  /// **'РУС'**
  String get rus;

  /// No description provided for @kaz.
  ///
  /// In ru, this message translates to:
  /// **'ҚАЗ'**
  String get kaz;

  /// No description provided for @eng.
  ///
  /// In ru, this message translates to:
  /// **'ENG'**
  String get eng;

  /// No description provided for @err_empty.
  ///
  /// In ru, this message translates to:
  /// **'Поле не может быть пустым'**
  String get err_empty;

  /// No description provided for @err_username_short.
  ///
  /// In ru, this message translates to:
  /// **'Имя должно быть не короче 3 символов'**
  String get err_username_short;

  /// No description provided for @err_username_invalid.
  ///
  /// In ru, this message translates to:
  /// **'Только латинские буквы, цифры и _'**
  String get err_username_invalid;

  /// No description provided for @err_email_invalid.
  ///
  /// In ru, this message translates to:
  /// **'Введите корректный Email'**
  String get err_email_invalid;

  /// No description provided for @err_pass_short.
  ///
  /// In ru, this message translates to:
  /// **'Минимум 8 символов'**
  String get err_pass_short;

  /// No description provided for @err_pass_upper.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте заглавную букву'**
  String get err_pass_upper;

  /// No description provided for @err_pass_lower.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте строчную букву'**
  String get err_pass_lower;

  /// No description provided for @err_pass_digit.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте цифру'**
  String get err_pass_digit;

  /// No description provided for @err_pass_match.
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get err_pass_match;

  /// No description provided for @pass_strength.
  ///
  /// In ru, this message translates to:
  /// **'Надежность пароля:'**
  String get pass_strength;

  /// No description provided for @ent_ai_predictor.
  ///
  /// In ru, this message translates to:
  /// **'Entity'**
  String get ent_ai_predictor;

  /// No description provided for @probability.
  ///
  /// In ru, this message translates to:
  /// **'ВЕРОЯТНОСТЬ'**
  String get probability;

  /// No description provided for @real_time_calc.
  ///
  /// In ru, this message translates to:
  /// **'Расчет в реальном времени активен'**
  String get real_time_calc;

  /// No description provided for @ai_recommendation.
  ///
  /// In ru, this message translates to:
  /// **'AI Рекомендация'**
  String get ai_recommendation;

  /// No description provided for @prob_is.
  ///
  /// In ru, this message translates to:
  /// **'Ваша вероятность '**
  String get prob_is;

  /// No description provided for @prob_high.
  ///
  /// In ru, this message translates to:
  /// **'высокая'**
  String get prob_high;

  /// No description provided for @prob_avg.
  ///
  /// In ru, this message translates to:
  /// **'средняя'**
  String get prob_avg;

  /// No description provided for @prob_low.
  ///
  /// In ru, this message translates to:
  /// **'низкая'**
  String get prob_low;

  /// No description provided for @rec_high.
  ///
  /// In ru, this message translates to:
  /// **'. Усиление профильных предметов может поднять шансы до '**
  String get rec_high;

  /// No description provided for @rec_low.
  ///
  /// In ru, this message translates to:
  /// **'. Настоятельно рекомендуем подтянуть основные предметы, чтобы достичь '**
  String get rec_low;

  /// No description provided for @simulation.
  ///
  /// In ru, this message translates to:
  /// **'Баллы ЕНТ'**
  String get simulation;

  /// No description provided for @parameter_adjust.
  ///
  /// In ru, this message translates to:
  /// **'НАСТРОЙКА ПАРАМЕТРОВ'**
  String get parameter_adjust;

  /// No description provided for @subj_prof1.
  ///
  /// In ru, this message translates to:
  /// **'Профильный предмет 1'**
  String get subj_prof1;

  /// No description provided for @subj_prof2.
  ///
  /// In ru, this message translates to:
  /// **'Профильный предмет 2'**
  String get subj_prof2;

  /// No description provided for @subj_history.
  ///
  /// In ru, this message translates to:
  /// **'История Казахстана'**
  String get subj_history;

  /// No description provided for @subj_reading.
  ///
  /// In ru, this message translates to:
  /// **'Грамотность чтения'**
  String get subj_reading;

  /// No description provided for @subj_math_lit.
  ///
  /// In ru, this message translates to:
  /// **'Мат. грамотность'**
  String get subj_math_lit;

  /// No description provided for @threshold_failed.
  ///
  /// In ru, this message translates to:
  /// **'ПОРОГ НЕ ПРОЙДЕН'**
  String get threshold_failed;

  /// No description provided for @rec_threshold.
  ///
  /// In ru, this message translates to:
  /// **'Вы не набрали минимальный пороговый балл по одному из предметов. Поступление на грант невозможно.'**
  String get rec_threshold;

  /// No description provided for @total_score.
  ///
  /// In ru, this message translates to:
  /// **'ОБЩИЙ БАЛЛ'**
  String get total_score;

  /// No description provided for @growth.
  ///
  /// In ru, this message translates to:
  /// **'РОСТ'**
  String get growth;

  /// No description provided for @nav_insight.
  ///
  /// In ru, this message translates to:
  /// **'Анализ'**
  String get nav_insight;

  /// No description provided for @nav_predict.
  ///
  /// In ru, this message translates to:
  /// **'Прогноз'**
  String get nav_predict;

  /// No description provided for @nav_simulate.
  ///
  /// In ru, this message translates to:
  /// **'Баллы'**
  String get nav_simulate;

  /// No description provided for @nav_library.
  ///
  /// In ru, this message translates to:
  /// **'Библиотека'**
  String get nav_library;

  /// No description provided for @nav_profile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get nav_profile;

  /// No description provided for @subj_math.
  ///
  /// In ru, this message translates to:
  /// **'Математика'**
  String get subj_math;

  /// No description provided for @subj_physics.
  ///
  /// In ru, this message translates to:
  /// **'Физика'**
  String get subj_physics;

  /// No description provided for @subj_chemistry.
  ///
  /// In ru, this message translates to:
  /// **'Химия'**
  String get subj_chemistry;

  /// No description provided for @subj_biology.
  ///
  /// In ru, this message translates to:
  /// **'Биология'**
  String get subj_biology;

  /// No description provided for @subj_geography.
  ///
  /// In ru, this message translates to:
  /// **'География'**
  String get subj_geography;

  /// No description provided for @subj_informatics.
  ///
  /// In ru, this message translates to:
  /// **'Информатика'**
  String get subj_informatics;

  /// No description provided for @subj_world_history.
  ///
  /// In ru, this message translates to:
  /// **'Всемирная история'**
  String get subj_world_history;

  /// No description provided for @subj_foreign_lang.
  ///
  /// In ru, this message translates to:
  /// **'Иностранный язык'**
  String get subj_foreign_lang;

  /// No description provided for @subj_literature.
  ///
  /// In ru, this message translates to:
  /// **'Литература'**
  String get subj_literature;

  /// No description provided for @subj_language.
  ///
  /// In ru, this message translates to:
  /// **'Язык (Каз/Рус)'**
  String get subj_language;

  /// No description provided for @subj_law.
  ///
  /// In ru, this message translates to:
  /// **'Основы права'**
  String get subj_law;

  /// No description provided for @profile_subjects.
  ///
  /// In ru, this message translates to:
  /// **'Профильные предметы'**
  String get profile_subjects;

  /// No description provided for @change_combo.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get change_combo;

  /// No description provided for @profile.
  ///
  /// In ru, this message translates to:
  /// **'Мой Профиль'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта'**
  String get logout;

  /// No description provided for @your_combo.
  ///
  /// In ru, this message translates to:
  /// **'Ваша комбинация'**
  String get your_combo;

  /// No description provided for @select_combo.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать предметы'**
  String get select_combo;

  /// No description provided for @region.
  ///
  /// In ru, this message translates to:
  /// **'Регион'**
  String get region;

  /// No description provided for @select_region.
  ///
  /// In ru, this message translates to:
  /// **'Выберите регион'**
  String get select_region;

  /// No description provided for @school_type.
  ///
  /// In ru, this message translates to:
  /// **'Тип школы'**
  String get school_type;

  /// No description provided for @city.
  ///
  /// In ru, this message translates to:
  /// **'Городская'**
  String get city;

  /// No description provided for @rural.
  ///
  /// In ru, this message translates to:
  /// **'Сельская'**
  String get rural;

  /// No description provided for @quota.
  ///
  /// In ru, this message translates to:
  /// **'Социальная квота'**
  String get quota;

  /// No description provided for @yes.
  ///
  /// In ru, this message translates to:
  /// **'Есть'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get no;

  /// No description provided for @save_changes.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить изменения'**
  String get save_changes;

  /// No description provided for @search_hint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск университетов...'**
  String get search_hint;

  /// No description provided for @filters.
  ///
  /// In ru, this message translates to:
  /// **'Фильтры'**
  String get filters;

  /// No description provided for @apply_filters.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get apply_filters;

  /// No description provided for @reset_filters.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get reset_filters;

  /// No description provided for @universities.
  ///
  /// In ru, this message translates to:
  /// **'Университеты'**
  String get universities;

  /// No description provided for @not_found.
  ///
  /// In ru, this message translates to:
  /// **'По вашим фильтрам ничего не найдено'**
  String get not_found;

  /// No description provided for @grant_chance.
  ///
  /// In ru, this message translates to:
  /// **'Шанс на грант'**
  String get grant_chance;

  /// No description provided for @tuition_fee.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость обучения'**
  String get tuition_fee;

  /// No description provided for @city_filter.
  ///
  /// In ru, this message translates to:
  /// **'Город'**
  String get city_filter;

  /// No description provided for @score_threshold.
  ///
  /// In ru, this message translates to:
  /// **'Проходной балл'**
  String get score_threshold;

  /// No description provided for @all_cities.
  ///
  /// In ru, this message translates to:
  /// **'Все города'**
  String get all_cities;

  /// No description provided for @no_internet.
  ///
  /// In ru, this message translates to:
  /// **'Связь с ядром потеряна'**
  String get no_internet;

  /// No description provided for @check_connection.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте подключение к сети'**
  String get check_connection;

  /// No description provided for @try_again.
  ///
  /// In ru, this message translates to:
  /// **'Повторить попытку'**
  String get try_again;

  /// No description provided for @server_error.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сервера'**
  String get server_error;

  /// No description provided for @server_error_desc.
  ///
  /// In ru, this message translates to:
  /// **'Наши ИИ-алгоритмы временно недоступны'**
  String get server_error_desc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/welcome_screen.dart'; // Стартуем с экрана приветствия

void main() {
  runApp(const EntityApp());
}

class EntityApp extends StatefulWidget {
  const EntityApp({super.key});

  // Этот метод позволяет менять язык из любого места в приложении
  static void setLocale(BuildContext context, Locale newLocale) {
    _EntityAppState? state = context.findAncestorStateOfType<_EntityAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<EntityApp> createState() => _EntityAppState();
}

class _EntityAppState extends State<EntityApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entity',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('ru'),
        Locale('kk'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Важно: стартовым экраном теперь является WelcomeScreen
      home: const WelcomeScreen(),
    );
  }
}
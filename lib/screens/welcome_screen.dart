import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../globals.dart';
import '../utils/page_transitions.dart';
import '../widgets/animated_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    return ValueListenableBuilder<bool>(
      valueListenable: globalIsDarkMode,
      builder: (context, isDark, _) {
        final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final Color primaryCyan = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
        final Color primaryPurple = isDark ? const Color(0xFFAB55F7) : const Color(0xFF9333EA);
        final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

        final titleStyle = GoogleFonts.spaceGrotesk(color: textPrimary, fontWeight: FontWeight.bold);
        final bodyStyle = GoogleFonts.inter(color: textPrimary);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () => EntityApp.setLocale(context, Locale(currentLocale == 'ru' ? 'kk' : (currentLocale == 'kk' ? 'en' : 'ru'))),
                child: Text(currentLocale.toUpperCase(), style: TextStyle(color: primaryCyan, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: textSecondary),
                onPressed: () => globalIsDarkMode.value = !isDark,
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 130, height: 130,
                          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(color: primaryCyan.withValues(alpha: 0.25), blurRadius: 60, spreadRadius: 10),
                            BoxShadow(color: primaryPurple.withValues(alpha: 0.15), blurRadius: 60, spreadRadius: -10),
                          ]),
                        ),
                        Hero(
                          tag: 'entity_brand_logo', 
                          child: Image.asset('assets/images/entity_logo.png', width: 110, height: 110, fit: BoxFit.contain),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 56),
                  Text('Entity', textAlign: TextAlign.center, style: titleStyle.copyWith(fontSize: 48, letterSpacing: 3, height: 1.1)),
                  const SizedBox(height: 16),
                  Text(l10n.helper_text, textAlign: TextAlign.center, style: bodyStyle.copyWith(color: textSecondary, fontSize: 16, height: 1.6)),
                  const Spacer(flex: 2),

                  AnimatedEntityButton(
                    text: l10n.login,
                    colors: [primaryPurple, primaryCyan],
                    onPressed: () => Navigator.push(context, EntityPageRoute(page: const LoginScreen())),
                  ),
                  const SizedBox(height: 16),
                  AnimatedEntityButton(
                    text: l10n.register,
                    colors: [primaryCyan, primaryCyan],
                    isOutlined: true,
                    onPressed: () => Navigator.push(context, EntityPageRoute(page: const RegisterScreen())),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
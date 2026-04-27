import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../globals.dart';
import '../utils/page_transitions.dart';
import 'dashboard_screen.dart';
import 'simulate_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const SimulateScreen(), 
    const ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    return ValueListenableBuilder<bool>(
      valueListenable: globalIsDarkMode,
      builder: (context, isDark, _) {
        final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final Color cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final Color primaryCyan = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
        final Color primaryPurple = isDark ? const Color(0xFFAB55F7) : const Color(0xFF9333EA);
        final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final Color borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0);
        final titleStyle = GoogleFonts.spaceGrotesk(color: isDark ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold);

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0, right: 0),
                child: Image.asset('assets/images/entity_logo.png', fit: BoxFit.contain),
              ),
              title: Text('Entity', style: titleStyle.copyWith(fontSize: 20, letterSpacing: 0.5)),
              actions: [
                TextButton(
                  onPressed: () => EntityApp.setLocale(context, Locale(currentLocale == 'ru' ? 'kk' : (currentLocale == 'kk' ? 'en' : 'ru'))),
                  child: Text(currentLocale.toUpperCase(), style: TextStyle(color: primaryCyan, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: textSecondary, size: 22),
                  onPressed: () => globalIsDarkMode.value = !isDark, 
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  fillColor: Colors.transparent,
                  child: child,
                );
              },
              child: _pages[_currentIndex],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: primaryCyan,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [primaryCyan, primaryPurple], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(context, EntityPageRoute(page: const ChatScreen()));
              },
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: cardBgColor,
                border: isDark ? Border(top: BorderSide(color: borderColor, width: 1)) : null,
                boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))],
              ),
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  labelTextStyle: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return titleStyle.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: primaryCyan);
                    return GoogleFonts.inter(fontSize: 11, color: textSecondary);
                  }),
                ),
                child: NavigationBar(
                  height: 70,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  indicatorColor: primaryCyan.withValues(alpha: 0.15),
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) => setState(() => _currentIndex = index), 
                  destinations: [
                    NavigationDestination(icon: Icon(Icons.analytics_outlined, color: textSecondary), selectedIcon: Icon(Icons.analytics_rounded, color: primaryCyan), label: l10n.nav_predict),
                    NavigationDestination(icon: Icon(Icons.tune_rounded, color: textSecondary), selectedIcon: Icon(Icons.tune_rounded, color: primaryCyan), label: l10n.nav_simulate),
                    NavigationDestination(icon: Icon(Icons.person_outline_rounded, color: textSecondary), selectedIcon: Icon(Icons.person_rounded, color: primaryCyan), label: l10n.nav_profile),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
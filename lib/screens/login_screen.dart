import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../globals.dart';
import '../utils/page_transitions.dart';
import '../widgets/animated_button.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    return ValueListenableBuilder<bool>(
      valueListenable: globalIsDarkMode,
      builder: (context, isDark, _) {
        final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final Color inputBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
        final Color primaryCyan = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
        final Color primaryPurple = isDark ? const Color(0xFFAB55F7) : const Color(0xFF9333EA);
        final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final titleStyle = GoogleFonts.spaceGrotesk(color: textPrimary, fontWeight: FontWeight.bold);

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
                onPressed: () => Navigator.pushReplacement(context, EntityPageRoute(page: const WelcomeScreen())),
              ),
              actions: [
                TextButton(
                  onPressed: () => EntityApp.setLocale(context, Locale(currentLocale == 'ru' ? 'kk' : (currentLocale == 'kk' ? 'en' : 'ru'))),
                  child: Text(currentLocale.toUpperCase(), style: TextStyle(color: primaryCyan, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                IconButton(icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: textSecondary), onPressed: () => globalIsDarkMode.value = !isDark),
                const SizedBox(width: 16),
              ],
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(width: 110, height: 110, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: primaryCyan.withValues(alpha: 0.2), blurRadius: 50)])),
                            Hero(tag: 'entity_brand_logo', child: Image.asset('assets/images/entity_logo.png', width: 90, height: 90)),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text('Entity', style: titleStyle.copyWith(fontSize: 32, letterSpacing: 2)),
                        const SizedBox(height: 8),
                        Text(l10n.helper_text, textAlign: TextAlign.center, style: GoogleFonts.inter(color: textSecondary, fontSize: 14)),
                        const SizedBox(height: 48),

                        // --- ПОЛЯ С ИСПРАВЛЕННЫМ СЛИПАНИЕМ ---
                        _buildTextField(
                          controller: _emailController, label: l10n.email, icon: Icons.email_outlined, 
                          inputBgColor: inputBgColor, primaryCyan: primaryCyan, isDark: isDark, 
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.err_empty;
                            // СТРОГАЯ ВАЛИДАЦИЯ ПОЧТЫ ВОЗВРАЩЕНА
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return l10n.err_email_invalid;
                            return null;
                          }
                        ),
                        _buildTextField(
                          controller: _passwordController, label: l10n.password, icon: Icons.lock_outline_rounded, 
                          isPassword: true, isVisible: _isPasswordVisible, onVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible), 
                          inputBgColor: inputBgColor, primaryCyan: primaryCyan, isDark: isDark, 
                          validator: (v) => (v == null || v.isEmpty) ? l10n.err_empty : null
                        ),
                        const SizedBox(height: 16),

                        AnimatedEntityButton(
                          text: l10n.login,
                          colors: [primaryPurple, primaryCyan],
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushAndRemoveUntil(context, EntityPageRoute(page: const MainScreen()), (r) => false);
                            }
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(context, EntityPageRoute(page: const RegisterScreen())), 
                          child: Text(l10n.no_account, style: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold))
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- ИСПРАВЛЕННЫЙ БИЛДЕР: Не обрезает углы и делает отступ внутри ---
  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool isPassword = false, bool isVisible = false, VoidCallback? onVisibilityToggle, required Color inputBgColor, required Color primaryCyan, required bool isDark, required String? Function(String?) validator}) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none, // ВАЖНО: Больше не обрезает границы поля!
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0), // Отступ 16px живет прямо здесь
        child: TextFormField(
          controller: controller, obscureText: isPassword && !isVisible, style: GoogleFonts.inter(color: isDark ? Colors.white : const Color(0xFF0F172A)),
          decoration: InputDecoration(
            labelText: label, labelStyle: GoogleFonts.inter(color: const Color(0xFF64748B)), prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
            suffixIcon: isPassword ? IconButton(icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: const Color(0xFF64748B)), onPressed: onVisibilityToggle) : null,
            filled: true, fillColor: inputBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryCyan, width: 2)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1)), focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2)), errorStyle: GoogleFonts.inter(color: const Color(0xFFEF4444), fontWeight: FontWeight.w500),
          ),
          validator: validator,
        ),
      ),
    );
  }
}
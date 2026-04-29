import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../globals.dart';
import '../utils/page_transitions.dart';
import '../widgets/animated_button.dart';
import 'main_screen.dart';
import 'login_screen.dart';
import 'career_test_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  
  // НОВЫЕ ПЕРЕМЕННЫЕ ВМЕСТО СТАРОГО ИНДЕКСА
  String _localProf1 = 'Математика';
  String _localProf2 = 'Физика';

  void _showTestAlert(BuildContext context, AppLocalizations l10n, Color cardBgColor, Color primaryCyan, Color textPrimary, Color textSecondary) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.test_offer_title, style: GoogleFonts.spaceGrotesk(color: textPrimary, fontWeight: FontWeight.bold)),
        content: Text(l10n.test_offer_desc, style: GoogleFonts.inter(color: textSecondary)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(context, EntityPageRoute(page: const MainScreen()), (r) => false);
            },
            child: Text(l10n.postpone, style: TextStyle(color: textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryCyan, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(context, EntityPageRoute(page: const MainScreen()), (r) => false);
              Navigator.push(context, EntityPageRoute(page: const CareerTestScreen()));
            },
            child: Text(l10n.pass_now, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      )
    );
  }

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
              leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: textPrimary), onPressed: () => Navigator.pop(context)),
              actions: [
                TextButton(onPressed: () => EntityApp.setLocale(context, Locale(currentLocale == 'ru' ? 'kk' : (currentLocale == 'kk' ? 'en' : 'ru'))), child: Text(currentLocale.toUpperCase(), style: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold))),
                IconButton(icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: textSecondary), onPressed: () => globalIsDarkMode.value = !isDark),
                const SizedBox(width: 16),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: Hero(tag: 'entity_brand_logo', child: Image.asset('assets/images/entity_logo.png', width: 60, height: 60))),
                      const SizedBox(height: 16),
                      Text(l10n.register, textAlign: TextAlign.center, style: titleStyle.copyWith(fontSize: 32)),
                      const SizedBox(height: 32),
                      
                      _buildTextField(controller: _userController, label: l10n.username, icon: Icons.person_outline_rounded, inputBgColor: inputBgColor, primaryCyan: primaryCyan, isDark: isDark, validator: (v) { if (v == null || v.isEmpty) return l10n.err_empty; if (v.length < 3) return l10n.err_username_short; if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) return l10n.err_username_invalid; return null; }),
                      _buildTextField(controller: _emailController, label: l10n.email, icon: Icons.email_outlined, inputBgColor: inputBgColor, primaryCyan: primaryCyan, isDark: isDark, validator: (v) { if (v == null || v.isEmpty) return l10n.err_empty; if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return l10n.err_email_invalid; return null; }),
                      _buildTextField(controller: _passwordController, label: l10n.password, icon: Icons.lock_outline_rounded, isPassword: true, isVisible: _isPasswordVisible, onVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible), inputBgColor: inputBgColor, primaryCyan: primaryCyan, isDark: isDark, validator: (v) { if (v == null || v.isEmpty) return l10n.err_empty; if (v.length < 8) return l10n.err_pass_short; if (!RegExp(r'(?=.*[A-Z])').hasMatch(v)) return l10n.err_pass_upper; if (!RegExp(r'(?=.*[a-z])').hasMatch(v)) return l10n.err_pass_lower; if (!RegExp(r'(?=.*\d)').hasMatch(v)) return l10n.err_pass_digit; return null; }),
                      _buildTextField(controller: _confirmController, label: l10n.confirm_password, icon: Icons.lock_reset_rounded, isPassword: true, isVisible: _isConfirmPasswordVisible, onVisibilityToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible), inputBgColor: inputBgColor, primaryCyan: primaryCyan, isDark: isDark, validator: (v) { if (v == null || v.isEmpty) return l10n.err_empty; if (v != _passwordController.text) return l10n.err_pass_match; return null; }),
                      
                      const SizedBox(height: 8),
                      Text(l10n.select_combo, style: GoogleFonts.inter(color: textSecondary, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      
                      // ИСПОЛЬЗУЕМ НОВУЮ ЛОГИКУ ВЫБОРА ПРЕДМЕТОВ
                      GestureDetector(
                        onTap: () => showSmartComboPicker(context, inputBgColor, textPrimary, textSecondary, primaryCyan, (s1, s2) {
                          setState(() {
                            _localProf1 = s1;
                            _localProf2 = s2;
                          });
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: inputBgColor, borderRadius: BorderRadius.circular(16)),
                          child: Row(children: [Icon(Icons.school_outlined, color: textSecondary), const SizedBox(width: 12), Expanded(child: Text("$_localProf1 + $_localProf2", style: TextStyle(color: textPrimary))), Icon(Icons.arrow_drop_down_rounded, color: textSecondary)]),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      AnimatedEntityButton(text: l10n.register, colors: [primaryCyan, primaryPurple], onPressed: () { 
                        if (_formKey.currentState!.validate()) { 
                          // СОХРАНЯЕМ В НОВЫЕ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
                          globalProf1.value = _localProf1;
                          globalProf2.value = _localProf2;
                          _showTestAlert(context, l10n, inputBgColor, primaryCyan, textPrimary, textSecondary);
                        } 
                      }),
                      
                      const SizedBox(height: 24),
                      TextButton(onPressed: () => Navigator.pushReplacement(context, EntityPageRoute(page: const LoginScreen())), child: Text(l10n.have_account, style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool isPassword = false, bool isVisible = false, VoidCallback? onVisibilityToggle, required Color inputBgColor, required Color primaryCyan, required bool isDark, required String? Function(String?) validator}) {
    return AnimatedSize(duration: const Duration(milliseconds: 300), curve: Curves.fastOutSlowIn, alignment: Alignment.topCenter, clipBehavior: Clip.none, child: Container(margin: const EdgeInsets.only(bottom: 16.0), child: TextFormField(controller: controller, obscureText: isPassword && !isVisible, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)), decoration: InputDecoration(labelText: label, labelStyle: TextStyle(color: const Color(0xFF64748B)), prefixIcon: Icon(icon, color: const Color(0xFF64748B)), suffixIcon: isPassword ? IconButton(icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: const Color(0xFF64748B)), onPressed: onVisibilityToggle) : null, filled: true, fillColor: inputBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryCyan, width: 2)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1)), focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2)), errorStyle: GoogleFonts.inter(color: const Color(0xFFEF4444), fontWeight: FontWeight.w500)), validator: validator)));
  }
}
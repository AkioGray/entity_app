import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../globals.dart';
import '../data/profile_repository.dart';
import '../utils/page_transitions.dart';
import '../widgets/animated_button.dart';
import '../widgets/skeleton_loader.dart';
import 'welcome_screen.dart';
import 'career_test_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await ProfileRepository.fetchUserData();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _saveData() async {
    setState(() => _isSaving = true);
    await ProfileRepository.saveUserData();
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Данные успешно сохранены!'),
          backgroundColor: const Color(0xFF00E5FF),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: globalIsDarkMode,
      builder: (context, isDark, _) {
        final Color cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final Color primaryCyan = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
        final Color primaryPurple = isDark ? const Color(0xFFAB55F7) : const Color(0xFF9333EA);
        final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final Color borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0);
        final titleStyle = GoogleFonts.spaceGrotesk(color: textPrimary, fontWeight: FontWeight.bold);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _isLoading
                ? _buildSkeletonUI(isDark)
                : _buildProfileUI(l10n, cardBgColor, primaryCyan, primaryPurple, textPrimary, textSecondary, borderColor, titleStyle, isDark),
          ),
        );
      }
    );
  }

  Widget _buildProfileUI(AppLocalizations l10n, Color cardBgColor, Color primaryCyan, Color primaryPurple, Color textPrimary, Color textSecondary, Color borderColor, TextStyle titleStyle, bool isDark) {
    return Column(
      key: const ValueKey('profile_content'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        CircleAvatar(radius: 50, backgroundColor: primaryCyan.withValues(alpha: 0.1), child: Icon(Icons.person_rounded, size: 50, color: primaryCyan)),
        const SizedBox(height: 16),
        
        ValueListenableBuilder<String>(
          valueListenable: globalUserName,
          builder: (context, name, _) => Text(name, style: titleStyle.copyWith(fontSize: 24))
        ),
        ValueListenableBuilder<String>(
          valueListenable: globalUserEmail,
          builder: (context, email, _) => Text(email, style: GoogleFonts.inter(color: textSecondary, fontSize: 14))
        ),
        
        const SizedBox(height: 40),

        ValueListenableBuilder<bool>(
          valueListenable: globalIsTestPassed,
          builder: (context, isPassed, _) {
            if (isPassed) {
              return ValueListenableBuilder<String>(
                valueListenable: globalTestResult,
                builder: (context, result, _) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(color: primaryCyan.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryCyan.withValues(alpha: 0.3))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.psychology_rounded, color: primaryCyan, size: 20),
                        const SizedBox(width: 8),
                        Text("${l10n.career_result} $result", style: GoogleFonts.inter(color: primaryCyan, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: 250,
                  child: AnimatedEntityButton(
                    text: l10n.career_test,
                    colors: [primaryPurple, primaryPurple],
                    isOutlined: true,
                    onPressed: () => Navigator.push(context, EntityPageRoute(page: const CareerTestScreen())),
                  ),
                ),
              );
            }
          }
        ),

        Align(alignment: Alignment.centerLeft, child: Text(l10n.your_combo, style: titleStyle.copyWith(fontSize: 18))),
        const SizedBox(height: 16),
        
        ValueListenableBuilder<String>(
          valueListenable: globalProf1,
          builder: (context, p1, _) {
            return ValueListenableBuilder<String>(
              valueListenable: globalProf2,
              builder: (context, p2, _) {
                return _buildClickableCard(
                  icon: Icons.school_rounded, color: primaryPurple, title: l10n.profile_subjects, value: "$p1 + \n$p2",
                  cardBgColor: cardBgColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary,
                  onTap: () => showSmartComboPicker(context, cardBgColor, textPrimary, textSecondary, primaryCyan, (s1, s2) {
                    globalProf1.value = s1;
                    globalProf2.value = s2;
                  }),
                );
              }
            );
          }
        ),
        const SizedBox(height: 16),

        ValueListenableBuilder<String?>(
          valueListenable: globalRegion,
          builder: (context, region, _) {
            return _buildClickableCard(
              icon: Icons.location_on_rounded, color: primaryCyan, title: l10n.region, value: region ?? l10n.select_region,
              cardBgColor: cardBgColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary,
              onTap: () => showRegionPicker(context, cardBgColor, textPrimary, textSecondary, primaryCyan, (r) => globalRegion.value = r),
            );
          }
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: globalSchoolType,
                builder: (context, sType, _) {
                  return _buildToggleCard(
                    title: l10n.school_type, val1: l10n.city, val2: l10n.rural, isVal1: sType == 'city',
                    activeColor: primaryCyan, cardBgColor: cardBgColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary,
                    onToggle: () => globalSchoolType.value = sType == 'city' ? 'rural' : 'city',
                  );
                }
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: globalHasQuota,
                builder: (context, hasQuota, _) {
                  return _buildToggleCard(
                    title: l10n.quota, val1: l10n.no, val2: l10n.yes, isVal1: !hasQuota,
                    activeColor: primaryPurple, cardBgColor: cardBgColor, borderColor: borderColor, textPrimary: textPrimary, textSecondary: textSecondary,
                    onToggle: () => globalHasQuota.value = !hasQuota,
                  );
                }
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),

        _isSaving 
          ? const CircularProgressIndicator()
          : SizedBox(
              width: 250,
              child: AnimatedEntityButton(
                text: l10n.save_changes,
                colors: [primaryCyan, primaryPurple],
                onPressed: _saveData,
              ),
            ),
        const SizedBox(height: 16),

        SizedBox(
          width: 250,
          child: AnimatedEntityButton(
            text: l10n.logout,
            colors: [textSecondary, textSecondary],
            isOutlined: true,
            onPressed: () => Navigator.pushAndRemoveUntil(context, EntityPageRoute(page: const WelcomeScreen()), (r) => false),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonUI(bool isDark) {
    return Column(
      key: const ValueKey('skeleton_content'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        SkeletonLoader(width: 100, height: 100, borderRadius: 50, isDark: isDark),
        const SizedBox(height: 16),
        SkeletonLoader(width: 150, height: 24, isDark: isDark),
        const SizedBox(height: 8),
        SkeletonLoader(width: 200, height: 14, isDark: isDark),
        const SizedBox(height: 40),
        Align(alignment: Alignment.centerLeft, child: SkeletonLoader(width: 180, height: 20, isDark: isDark)),
        const SizedBox(height: 16),
        SkeletonLoader(width: double.infinity, height: 90, isDark: isDark),
        const SizedBox(height: 16),
        SkeletonLoader(width: double.infinity, height: 90, isDark: isDark),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: SkeletonLoader(width: double.infinity, height: 90, isDark: isDark)),
            const SizedBox(width: 16),
            Expanded(child: SkeletonLoader(width: double.infinity, height: 90, isDark: isDark)),
          ],
        )
      ],
    );
  }

  Widget _buildClickableCard({required IconData icon, required Color color, required String title, required String value, required Color cardBgColor, required Color borderColor, required Color textPrimary, required Color textSecondary, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)), const SizedBox(height: 4), Text(value, style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 15, fontWeight: FontWeight.bold))])),
            Icon(Icons.edit_rounded, color: textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard({required String title, required String val1, required String val2, required bool isVal1, required Color activeColor, required Color cardBgColor, required Color borderColor, required Color textPrimary, required Color textSecondary, required VoidCallback onToggle}) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Container(alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: isVal1 ? activeColor.withValues(alpha: 0.15) : Colors.transparent, borderRadius: BorderRadius.circular(8)), child: FittedBox(fit: BoxFit.scaleDown, child: Text(val1, style: GoogleFonts.inter(color: isVal1 ? activeColor : textSecondary, fontWeight: isVal1 ? FontWeight.bold : FontWeight.normal, fontSize: 13))))),
                Expanded(child: Container(alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: !isVal1 ? activeColor.withValues(alpha: 0.15) : Colors.transparent, borderRadius: BorderRadius.circular(8)), child: FittedBox(fit: BoxFit.scaleDown, child: Text(val2, style: GoogleFonts.inter(color: !isVal1 ? activeColor : textSecondary, fontWeight: !isVal1 ? FontWeight.bold : FontWeight.normal, fontSize: 13))))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../globals.dart';
import '../utils/debouncer.dart';
import '../data/simulation_repository.dart';
import '../models/profession.dart';
import '../models/grant_result.dart';
import '../widgets/animated_button.dart';

class SimulateScreen extends StatefulWidget {
  const SimulateScreen({super.key});

  @override
  State<SimulateScreen> createState() => _SimulateScreenState();
}

class _SimulateScreenState extends State<SimulateScreen> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  double _prof1 = 25;
  double _prof2 = 25;
  double _history = 10;
  double _reading = 5;
  double _math = 5;

  double _chance = 0.50;

  // Профессии для dropdown
  List<Profession> _professions = [];
  Profession? _selectedProfession;
  bool _loadingProfessions = true;

  // Результаты грантов
  List<GrantResult> _grantResults = [];
  String? _grantProfessionName;
  bool _checkingGrants = false;
  bool _grantsChecked = false;

  @override
  void initState() {
    super.initState();
    _updateChance();
    _loadProfessions();
  }

  void _updateChance() {
    final result = SimulationRepository.calculateChance(
      prof1: _prof1.toInt(),
      prof2: _prof2.toInt(),
      history: _history.toInt(),
      reading: _reading.toInt(),
      math: _math.toInt(),
    );
    setState(() => _chance = result);
  }

  void _onSliderChanged() {
    _debouncer.run(_updateChance);
  }

  Future<void> _loadProfessions() async {
    try {
      final lang = _currentLang();
      final list = await SimulationRepository.loadProfessions(lang: lang);
      if (mounted) setState(() { _professions = list; _loadingProfessions = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingProfessions = false);
    }
  }

  Future<void> _checkGrants() async {
    if (_selectedProfession == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Выберите профессию для проверки гранта'),
        backgroundColor: const Color(0xFFFBBF24),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }

    setState(() { _checkingGrants = true; _grantsChecked = false; });

    try {
      final totalScore = (_prof1 + _prof2 + _history + _reading + _math).toInt();
      final data = await SimulationRepository.checkGrants(
        entScore: totalScore,
        professionId: _selectedProfession!.id,
        lang: _currentLang(),
      );
      if (mounted) {
        setState(() {
          _grantResults = data.results;
          _grantProfessionName = data.professionName;
          _grantsChecked = true;
          _checkingGrants = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _checkingGrants = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(SimulationRepository.friendlyError(e)),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    }
  }

  String _currentLang() {
    if (!mounted) return 'ru';
    return Localizations.localeOf(context).languageCode;
  }

  Color _chanceColor(String chance) {
    return switch (chance.toUpperCase()) {
      'HIGH' => const Color(0xFF10B981),
      'MEDIUM' => const Color(0xFFFBBF24),
      'LOW' => const Color(0xFFEF4444),
      _ => const Color(0xFF94A3B8),
    };
  }

  String _chanceLabel(String chance) {
    return switch (chance.toUpperCase()) {
      'HIGH' => 'Высокий',
      'MEDIUM' => 'Средний',
      'LOW' => 'Низкий',
      _ => chance,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final int totalScore = (_prof1 + _prof2 + _history + _reading + _math).toInt();

    return ValueListenableBuilder<bool>(
      valueListenable: globalIsDarkMode,
      builder: (context, isDark, _) {
        final Color cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final Color primaryCyan = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
        final Color primaryPurple = isDark ? const Color(0xFFAB55F7) : const Color(0xFF9333EA);
        final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final Color borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0);
        final Color inputBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
        final titleStyle = GoogleFonts.spaceGrotesk(color: textPrimary, fontWeight: FontWeight.bold);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Круговой индикатор шанса
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                  boxShadow: [BoxShadow(color: primaryCyan.withValues(alpha: 0.1), blurRadius: 30, spreadRadius: 5)],
                ),
                child: Column(
                  children: [
                    Text(l10n.probability, style: GoogleFonts.inter(color: textSecondary, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: _chance),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, _) => CircularProgressIndicator(
                              value: value,
                              strokeWidth: 12,
                              backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                              color: primaryCyan,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: _chance),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) => Text(
                            '${(value * 100).toInt()}%',
                            style: titleStyle.copyWith(fontSize: 48, color: primaryCyan),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('$totalScore / 140', style: titleStyle.copyWith(fontSize: 20)),
                    Text(l10n.total_score, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              Text(l10n.parameter_adjust, style: titleStyle.copyWith(fontSize: 18)),
              const SizedBox(height: 16),

              // Слайдеры
              ValueListenableBuilder<String>(
                valueListenable: globalProf1,
                builder: (context, p1, _) {
                  return ValueListenableBuilder<String>(
                    valueListenable: globalProf2,
                    builder: (context, p2, _) {
                      return Column(
                        children: [
                          _buildSlider(p1, _prof1, 50, primaryCyan, cardBgColor, textPrimary, textSecondary, (val) {
                            setState(() => _prof1 = val);
                            _onSliderChanged();
                          }),
                          if (p1 != l10n.creative_exam)
                            _buildSlider(p2, _prof2, 50, primaryCyan, cardBgColor, textPrimary, textSecondary, (val) {
                              setState(() => _prof2 = val);
                              _onSliderChanged();
                            }),
                          _buildSlider(l10n.subj_history, _history, 20, primaryCyan, cardBgColor, textPrimary, textSecondary, (val) {
                            setState(() => _history = val);
                            _onSliderChanged();
                          }),
                          _buildSlider(l10n.subj_reading, _reading, 10, primaryCyan, cardBgColor, textPrimary, textSecondary, (val) {
                            setState(() => _reading = val);
                            _onSliderChanged();
                          }),
                          _buildSlider(l10n.subj_math_lit, _math, 10, primaryCyan, cardBgColor, textPrimary, textSecondary, (val) {
                            setState(() => _math = val);
                            _onSliderChanged();
                          }),
                        ],
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 32),

              // Блок проверки гранта
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryPurple.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.school_rounded, color: primaryPurple, size: 20),
                        const SizedBox(width: 8),
                        Text('Проверить шанс на грант', style: titleStyle.copyWith(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Dropdown профессий
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: inputBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: _loadingProfessions
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: primaryCyan))),
                            )
                          : DropdownButtonHideUnderline(
                              child: DropdownButton<Profession>(
                                value: _selectedProfession,
                                hint: Text('Выберите профессию', style: GoogleFonts.inter(color: textSecondary)),
                                isExpanded: true,
                                dropdownColor: cardBgColor,
                                icon: Icon(Icons.arrow_drop_down_rounded, color: textSecondary),
                                items: _professions.map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p.name, style: GoogleFonts.inter(color: textPrimary), overflow: TextOverflow.ellipsis),
                                )).toList(),
                                onChanged: (p) => setState(() {
                                  _selectedProfession = p;
                                  _grantsChecked = false;
                                  _grantResults = [];
                                }),
                              ),
                            ),
                    ),

                    const SizedBox(height: 16),
                    AnimatedEntityButton(
                      text: _checkingGrants ? 'Загрузка...' : 'Проверить грант',
                      colors: [primaryPurple, primaryCyan],
                      onPressed: _checkingGrants ? null : _checkGrants,
                    ),

                    // Результаты
                    if (_grantsChecked) ...[
                      const SizedBox(height: 20),
                      if (_grantProfessionName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(_grantProfessionName!, style: titleStyle.copyWith(fontSize: 14, color: primaryPurple)),
                        ),
                      if (_grantResults.isEmpty)
                        Text('Нет данных по грантам для данной профессии', style: GoogleFonts.inter(color: textSecondary, fontSize: 13))
                      else
                        ..._grantResults.map((r) => _buildGrantCard(r, cardBgColor, borderColor, textPrimary, textSecondary, titleStyle)),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrantCard(GrantResult r, Color cardBgColor, Color borderColor, Color textPrimary, Color textSecondary, TextStyle titleStyle) {
    final chanceColor = _chanceColor(r.chance);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: chanceColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chanceColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 12, top: 4),
            decoration: BoxDecoration(color: chanceColor, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.universityName, style: GoogleFonts.spaceGrotesk(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(r.city, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                if (r.minEntScore != null) ...[
                  const SizedBox(height: 4),
                  Text('Мин. балл: ${r.minEntScore} · Грантов: ${r.totalGrants ?? '—'}', style: GoogleFonts.inter(color: textSecondary, fontSize: 11)),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: chanceColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Text(_chanceLabel(r.chance), style: GoogleFonts.inter(color: chanceColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double maxVal, Color activeColor, Color cardBgColor, Color textPrimary, Color textSecondary, Function(double) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBgColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w500)),
              Text('${value.toInt()} / ${maxVal.toInt()}', style: GoogleFonts.spaceGrotesk(color: activeColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: activeColor,
              inactiveTrackColor: activeColor.withValues(alpha: 0.1),
              thumbColor: Colors.white,
              overlayColor: activeColor.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(value: value, min: 0, max: maxVal, divisions: maxVal.toInt(), onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

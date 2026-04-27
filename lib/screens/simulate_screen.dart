import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../globals.dart';
import '../utils/debouncer.dart';
import '../data/simulation_repository.dart';

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
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _onSliderChanged() {
    setState(() {
      _isCalculating = true;
    });
    _debouncer.run(() {
      _calculate();
    });
  }

  Future<void> _calculate() async {
    final result = await SimulationRepository.calculateChance(
      prof1: _prof1.toInt(),
      prof2: _prof2.toInt(),
      history: _history.toInt(),
      reading: _reading.toInt(),
      math: _math.toInt(),
    );
    if (mounted) {
      setState(() {
        _chance = result;
        _isCalculating = false;
      });
    }
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
        final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final Color borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0);
        final titleStyle = GoogleFonts.spaceGrotesk(color: textPrimary, fontWeight: FontWeight.bold);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: primaryCyan.withValues(alpha: 0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
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
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, _) {
                              return CircularProgressIndicator(
                                value: value,
                                strokeWidth: 12,
                                backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                color: primaryCyan,
                                strokeCap: StrokeCap.round,
                              );
                            }
                          ),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: _chance),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            return Text(
                              '${(value * 100).toInt()}%',
                              style: titleStyle.copyWith(fontSize: 48, color: primaryCyan),
                            );
                          }
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(l10n.total_score, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('$totalScore / 140', style: titleStyle.copyWith(fontSize: 20)),
                          ],
                        ),
                        if (_isCalculating)
                          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: primaryCyan))
                        else
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 24),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(l10n.parameter_adjust, style: titleStyle.copyWith(fontSize: 18)),
              const SizedBox(height: 16),
              ValueListenableBuilder<int>(
                valueListenable: globalComboIndex,
                builder: (context, comboIndex, _) {
                  final currentCombo = getEntCombos(l10n)[comboIndex];
                  return Column(
                    children: [
                      _buildSlider(currentCombo.subj1, _prof1, 50, primaryCyan, cardBgColor, textPrimary, textSecondary, (val) {
                        setState(() => _prof1 = val);
                        _onSliderChanged();
                      }),
                      _buildSlider(currentCombo.subj2, _prof2, 50, primaryCyan, cardBgColor, textPrimary, textSecondary, (val) {
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
                }
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildSlider(String label, double value, double maxVal, Color activeColor, Color cardBgColor, Color textPrimary, Color textSecondary, Function(double) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
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
            child: Slider(
              value: value,
              min: 0,
              max: maxVal,
              divisions: maxVal.toInt(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
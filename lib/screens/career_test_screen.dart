import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../globals.dart';
import '../data/career_test_repository.dart';
import '../widgets/skeleton_loader.dart';

class CareerTestScreen extends StatefulWidget {
  const CareerTestScreen({super.key});

  @override
  State<CareerTestScreen> createState() => _CareerTestScreenState();
}

class _CareerTestScreenState extends State<CareerTestScreen> {
  final PageController _pageController = PageController();

  List<CareerQuestion> _questions = [];
  bool _loading = true;
  String? _loadError;

  int _currentIndex = 0;
  final Map<int, int> _answers = {}; // questionId → rating 1–5

  bool _submitting = false;
  bool _done = false;
  String? _resultCode;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      final lang = mounted ? Localizations.localeOf(context).languageCode : 'ru';
      final list = await CareerTestRepository.loadQuestions(lang: lang);
      if (mounted) setState(() { _questions = list; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loadError = CareerTestRepository.friendlyError(e); _loading = false; });
    }
  }

  void _selectRating(int rating) {
    final q = _questions[_currentIndex];
    setState(() => _answers[q.id] = rating);

    // Автопереход через 300мс
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
        setState(() => _currentIndex++);
      } else {
        _submit();
      }
    });
  }

  void _goBack() {
    if (_currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
      setState(() => _currentIndex--);
    }
  }

  Future<void> _submit() async {
    // Заполняем пропущенные вопросы нейтральным рейтингом 3
    for (final q in _questions) {
      _answers.putIfAbsent(q.id, () => 3);
    }

    setState(() => _submitting = true);

    try {
      final code = await CareerTestRepository.submitAnswers(_answers);
      globalIsTestPassed.value = true;
      globalTestResult.value = code;
      if (mounted) setState(() { _resultCode = code; _done = true; _submitting = false; });
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(CareerTestRepository.friendlyError(e)),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: globalIsDarkMode,
      builder: (context, isDark, _) {
        final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
        final primaryCyan = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
        final primaryPurple = isDark ? const Color(0xFFAB55F7) : const Color(0xFF9333EA);
        final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: _loading
                ? _buildLoading(isDark, textSecondary)
                : _loadError != null
                    ? _buildError(textPrimary, textSecondary, primaryCyan)
                    : _done
                        ? _buildResult(bgColor, cardBg, primaryCyan, primaryPurple, textPrimary, textSecondary)
                        : _buildTest(bgColor, cardBg, primaryCyan, primaryPurple, textPrimary, textSecondary, isDark),
          ),
        );
      },
    );
  }

  // ── Загрузка ──────────────────────────────────────────────────────────────
  Widget _buildLoading(bool isDark, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          SkeletonLoader(width: double.infinity, height: 12, borderRadius: 6, isDark: isDark),
          const SizedBox(height: 40),
          SkeletonLoader(width: double.infinity, height: 80, isDark: isDark),
          const SizedBox(height: 32),
          ...List.generate(5, (_) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SkeletonLoader(width: double.infinity, height: 56, borderRadius: 16, isDark: isDark),
          )),
        ],
      ),
    );
  }

  // ── Ошибка ────────────────────────────────────────────────────────────────
  Widget _buildError(Color textPrimary, Color textSecondary, Color primaryCyan) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: textSecondary),
            const SizedBox(height: 16),
            Text(_loadError!, textAlign: TextAlign.center, style: GoogleFonts.inter(color: textPrimary, fontSize: 16)),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () { setState(() { _loading = true; _loadError = null; }); _loadQuestions(); },
              child: Text('Повторить', style: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Результат ─────────────────────────────────────────────────────────────
  Widget _buildResult(Color bgColor, Color cardBg, Color primaryCyan, Color primaryPurple, Color textPrimary, Color textSecondary) {
    final code = _resultCode ?? '';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [primaryCyan, primaryPurple]),
              ),
              child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 52),
            ),
            const SizedBox(height: 32),
            Text('Тест завершён!', style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Твой код Голланда', style: GoogleFonts.inter(color: textSecondary, fontSize: 14)),
            const SizedBox(height: 12),
            Text(code, style: GoogleFonts.spaceGrotesk(color: primaryCyan, fontSize: 56, fontWeight: FontWeight.bold, letterSpacing: 8)),
            const SizedBox(height: 12),
            Text(_codeDescription(code), textAlign: TextAlign.center, style: GoogleFonts.inter(color: textSecondary, fontSize: 14)),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryCyan,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('Готово', style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Сам тест ──────────────────────────────────────────────────────────────
  Widget _buildTest(Color bgColor, Color cardBg, Color primaryCyan, Color primaryPurple, Color textPrimary, Color textSecondary, bool isDark) {
    final progress = (_currentIndex + 1) / _questions.length;

    return Column(
      children: [
        // Шапка: закрыть + прогресс
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.close_rounded, color: textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${_currentIndex + 1} / ${_questions.length}',
                        style: GoogleFonts.spaceGrotesk(color: textSecondary, fontSize: 13)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        color: primaryCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Вопросы
        Expanded(
          child: _submitting
              ? Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: primaryCyan),
                    const SizedBox(height: 16),
                    Text('Обрабатываем результаты...', style: GoogleFonts.inter(color: textSecondary)),
                  ],
                ))
              : PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final q = _questions[index];
                    final selected = _answers[q.id];
                    return _buildQuestionPage(q, selected, primaryCyan, primaryPurple, textPrimary, textSecondary, cardBg, isDark);
                  },
                ),
        ),

        // Кнопка назад
        if (!_submitting)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              children: [
                if (_currentIndex > 0)
                  TextButton.icon(
                    onPressed: _goBack,
                    icon: Icon(Icons.arrow_back_rounded, color: textSecondary, size: 18),
                    label: Text('Назад', style: GoogleFonts.inter(color: textSecondary)),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionPage(CareerQuestion q, int? selected, Color primaryCyan, Color primaryPurple, Color textPrimary, Color textSecondary, Color cardBg, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          // Вопрос
          Expanded(
            child: Center(
              child: Text(
                q.text,
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 22, fontWeight: FontWeight.bold, height: 1.4),
              ),
            ),
          ),

          // Шкала 1–5
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Совсем нет', style: GoogleFonts.inter(color: textSecondary, fontSize: 11)),
                    Text('Очень да', style: GoogleFonts.inter(color: textSecondary, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (i) {
                    final rating = i + 1;
                    final isSelected = selected == rating;
                    return GestureDetector(
                      onTap: () => _selectRating(rating),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? (rating <= 2 ? const Color(0xFFEF4444) : rating == 3 ? const Color(0xFFFBBF24) : primaryCyan)
                              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$rating',
                            style: GoogleFonts.spaceGrotesk(
                              color: isSelected ? Colors.white : textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _codeDescription(String code) {
    final map = {
      'R': 'Реалистичный — любит работать руками, техникой',
      'I': 'Исследовательский — аналитика и наука',
      'A': 'Артистический — творчество и самовыражение',
      'S': 'Социальный — работа с людьми и помощь',
      'E': 'Предпринимательский — лидерство и бизнес',
      'C': 'Конвенциональный — порядок и структура',
    };
    if (code.isEmpty) return '';
    return code.split('').map((c) => map[c] ?? c).join('\n');
  }
}

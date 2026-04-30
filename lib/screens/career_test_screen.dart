import 'dart:math';
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
  static const _perPage = 3;

  final PageController _pageController = PageController();

  List<CareerQuestion> _questions = [];
  bool _loading = true;
  String? _loadError;

  int _currentPage = 0;
  final Map<int, int> _answers = {}; // questionId → rating 1–5

  bool _submitting = false;
  bool _done = false;
  String? _resultCode;

  int get _pageCount => (_questions.length / _perPage).ceil();
  bool get _isLastPage => _currentPage >= _pageCount - 1;

  List<CareerQuestion> _pageQuestions(int page) {
    final start = page * _perPage;
    final end = min(start + _perPage, _questions.length);
    return _questions.sublist(start, end);
  }

  bool _pageAnswered(int page) =>
      _pageQuestions(page).every((q) => _answers.containsKey(q.id));

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

  void _selectRating(int questionId, int rating) {
    setState(() => _answers[questionId] = rating);
  }

  void _nextPage() {
    if (_isLastPage) {
      _submit();
    } else {
      _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
      setState(() => _currentPage++);
    }
  }

  void _goBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
      setState(() => _currentPage--);
    }
  }

  Future<void> _submit() async {
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
        final bgColor      = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final cardBg       = isDark ? const Color(0xFF1E293B) : Colors.white;
        final primaryCyan  = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
        final primaryPurple = isDark ? const Color(0xFFAB55F7) : const Color(0xFF9333EA);
        final textPrimary  = isDark ? Colors.white : const Color(0xFF0F172A);
        final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: _loading
                ? _buildLoading(isDark)
                : _loadError != null
                    ? _buildError(textPrimary, textSecondary, primaryCyan)
                    : _done
                        ? _buildResult(primaryCyan, primaryPurple, textPrimary, textSecondary)
                        : _buildTest(bgColor, cardBg, primaryCyan, primaryPurple, textPrimary, textSecondary, isDark),
          ),
        );
      },
    );
  }

  // ── Загрузка ──────────────────────────────────────────────────────────────
  Widget _buildLoading(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const SizedBox(height: 60),
        SkeletonLoader(width: double.infinity, height: 10, borderRadius: 5, isDark: isDark),
        const SizedBox(height: 40),
        ...List.generate(3, (_) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SkeletonLoader(width: double.infinity, height: 130, borderRadius: 16, isDark: isDark),
        )),
      ]),
    );
  }

  // ── Ошибка ────────────────────────────────────────────────────────────────
  Widget _buildError(Color textPrimary, Color textSecondary, Color primaryCyan) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.wifi_off_rounded, size: 64, color: textSecondary),
          const SizedBox(height: 16),
          Text(_loadError!, textAlign: TextAlign.center, style: GoogleFonts.inter(color: textPrimary, fontSize: 16)),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () { setState(() { _loading = true; _loadError = null; }); _loadQuestions(); },
            child: Text('Повторить', style: TextStyle(color: primaryCyan, fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }

  // ── Результат ─────────────────────────────────────────────────────────────
  Widget _buildResult(Color primaryCyan, Color primaryPurple, Color textPrimary, Color textSecondary) {
    final code = _resultCode ?? '';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
          Text(_codeDescription(code), textAlign: TextAlign.center, style: GoogleFonts.inter(color: textSecondary, fontSize: 14, height: 1.6)),
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
        ]),
      ),
    );
  }

  // ── Тест ──────────────────────────────────────────────────────────────────
  Widget _buildTest(Color bgColor, Color cardBg, Color primaryCyan, Color primaryPurple, Color textPrimary, Color textSecondary, bool isDark) {
    final canProceed = _pageAnswered(_currentPage);

    return Column(
      children: [
        // Шапка
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.close_rounded, color: textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('Страница ${_currentPage + 1} из $_pageCount',
                    style: GoogleFonts.spaceGrotesk(color: textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _pageCount,
                    minHeight: 6,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    color: primaryCyan,
                  ),
                ),
              ]),
            ),
          ]),
        ),

        // PageView
        Expanded(
          child: _submitting
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircularProgressIndicator(color: primaryCyan),
                  const SizedBox(height: 16),
                  Text('Обрабатываем результаты...', style: GoogleFonts.inter(color: textSecondary)),
                ]))
              : PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pageCount,
                  itemBuilder: (context, pageIndex) {
                    final questions = _pageQuestions(pageIndex);
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      children: questions.asMap().entries.map((entry) {
                        final localIdx = entry.key;
                        final q = entry.value;
                        final globalNum = pageIndex * _perPage + localIdx + 1;
                        return _buildQuestionCard(q, globalNum, primaryCyan, textPrimary, textSecondary, cardBg, isDark);
                      }).toList(),
                    );
                  },
                ),
        ),

        // Навигация
        if (!_submitting)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Row(children: [
              if (_currentPage > 0)
                TextButton.icon(
                  onPressed: _goBack,
                  icon: Icon(Icons.arrow_back_rounded, color: textSecondary, size: 18),
                  label: Text('Назад', style: GoogleFonts.inter(color: textSecondary)),
                ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: canProceed ? primaryCyan : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: canProceed ? _nextPage : null,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    _isLastPage ? 'Завершить' : 'Далее',
                    style: GoogleFonts.spaceGrotesk(
                      color: canProceed ? Colors.white : textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!_isLastPage) ...[
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 18, color: canProceed ? Colors.white : textSecondary),
                  ],
                ]),
              ),
            ]),
          ),
      ],
    );
  }

  Widget _buildQuestionCard(CareerQuestion q, int num, Color primaryCyan, Color textPrimary, Color textSecondary, Color cardBg, bool isDark) {
    final selected = _answers[q.id];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected != null ? primaryCyan.withValues(alpha: 0.3) : (isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Вопрос $num', style: GoogleFonts.inter(color: textSecondary, fontSize: 11, letterSpacing: 1)),
        const SizedBox(height: 8),
        Text(q.text, style: GoogleFonts.inter(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w500, height: 1.4)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) {
            final rating = i + 1;
            final isSelected = selected == rating;
            Color dotColor;
            if (rating <= 2) dotColor = const Color(0xFFEF4444);
            else if (rating == 3) dotColor = const Color(0xFFFBBF24);
            else dotColor = primaryCyan;

            return GestureDetector(
              onTap: () => _selectRating(q.id, rating),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? dotColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? dotColor : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text('$rating', style: GoogleFonts.spaceGrotesk(
                    color: isSelected ? Colors.white : textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Совсем нет', style: GoogleFonts.inter(color: textSecondary, fontSize: 10)),
          Text('Очень да', style: GoogleFonts.inter(color: textSecondary, fontSize: 10)),
        ]),
      ]),
    );
  }

  String _codeDescription(String code) {
    final map = {
      'R': 'Реалистичный — работа с техникой и руками',
      'I': 'Исследовательский — аналитика и наука',
      'A': 'Артистический — творчество и самовыражение',
      'S': 'Социальный — помощь людям',
      'E': 'Предпринимательский — лидерство и бизнес',
      'C': 'Конвенциональный — порядок и структура',
    };
    return code.split('').map((c) => map[c] ?? c).join('\n');
  }
}

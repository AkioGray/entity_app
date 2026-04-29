import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../globals.dart';
import '../widgets/animated_button.dart';

class CareerTestScreen extends StatefulWidget {
  const CareerTestScreen({super.key});

  @override
  State<CareerTestScreen> createState() => _CareerTestScreenState();
}

class _CareerTestScreenState extends State<CareerTestScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      "q": "Что тебе нравится больше?",
      "options": ["Решать сложные задачи", "Общаться с людьми", "Создавать дизайн"]
    },
    {
      "q": "Твой идеальный рабочий день?",
      "options": ["В офисе за компьютером", "В движении и разъездах", "В лаборатории/на заводе"]
    },
    {
      "q": "С чем ты хочешь работать?",
      "options": ["С кодом и данными", "С бизнес-процессами", "С биологией и химией"]
    }
  ];

  void _nextQuestion(int choiceIndex) {
    if (_currentIndex < _questions.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentIndex++);
    } else {
      globalIsTestPassed.value = true;
      globalTestResult.value = "IT и Инженерия";
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: globalIsDarkMode,
      builder: (context, isDark, _) {
        final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final Color cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(icon: Icon(Icons.close_rounded, color: textPrimary), onPressed: () => Navigator.pop(context)),
            title: Text('Вопрос ${_currentIndex + 1}/${_questions.length}', style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 18)),
            centerTitle: true,
          ),
          body: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_questions[index]["q"], textAlign: TextAlign.center, style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 48),
                    ...List.generate(_questions[index]["options"].length, (optIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: AnimatedEntityButton(
                          text: _questions[index]["options"][optIndex],
                          colors: [cardBgColor, cardBgColor],
                          isOutlined: true,
                          onPressed: () => _nextQuestion(optIndex),
                        ),
                      );
                    })
                  ],
                ),
              );
            },
          ),
        );
      }
    );
  }
}
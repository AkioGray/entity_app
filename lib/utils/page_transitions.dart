import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class EntityPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  EntityPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled, // Глубокий зум-эффект
              fillColor: Colors.transparent, // Не перекрывает наш темный фон
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
        );
}
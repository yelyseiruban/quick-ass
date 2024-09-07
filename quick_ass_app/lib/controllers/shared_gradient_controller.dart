import 'package:flutter/material.dart';

class SharedGradientController extends ChangeNotifier {
  late AnimationController _controller;
  late Animation<double> _animation;

  AnimationController get controller => _controller;

  SharedGradientController({required TickerProvider vsync}) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  Animation<double> get animation => _animation;
}


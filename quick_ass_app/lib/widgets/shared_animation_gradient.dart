import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_ass_app/controllers/shared_gradient_controller.dart';

class SharedAnimatedGradient extends StatelessWidget {
  final Widget child;

  const SharedAnimatedGradient({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SharedGradientController>(context);

    return AnimateGradient(
      key: const ValueKey('gradient'),
      primaryBeginGeometry: const AlignmentDirectional(0, 1),
      primaryEndGeometry: const AlignmentDirectional(0, 2),
      secondaryBeginGeometry: const AlignmentDirectional(2, 0),
      secondaryEndGeometry: const AlignmentDirectional(0, -0.8),
      textDirectionForGeometry: TextDirection.rtl,
      primaryColors: const [
        Colors.pink,
        Colors.pinkAccent,
        Colors.white,
      ],
      secondaryColors: const [
        Colors.white,
        Colors.blueAccent,
        Colors.blue,
      ],
      controller: controller.controller,
      child: child,
    );
  }
}


class AnimateGradient extends StatefulWidget {
  const AnimateGradient({
    Key? key,
    required this.primaryColors,
    required this.secondaryColors,
    this.child,
    this.primaryBegin = Alignment.topLeft,
    this.primaryEnd = Alignment.topRight,
    this.secondaryBegin = Alignment.bottomLeft,
    this.secondaryEnd = Alignment.bottomRight,
    this.primaryBeginGeometry,
    this.primaryEndGeometry,
    this.secondaryBeginGeometry,
    this.secondaryEndGeometry,
    this.textDirectionForGeometry = TextDirection.ltr,
    this.controller,
    this.duration = const Duration(seconds: 4),
    this.animateAlignments = true,
    this.reverse = true,
  })  : assert(primaryColors.length >= 2),
        assert(primaryColors.length == secondaryColors.length),
        super(key: key);

  final AnimationController? controller;
  final Duration duration;
  final List<Color> primaryColors;
  final List<Color> secondaryColors;
  final Alignment primaryBegin;
  final Alignment primaryEnd;
  final Alignment secondaryBegin;
  final Alignment secondaryEnd;
  final AlignmentGeometry? primaryBeginGeometry;
  final AlignmentGeometry? primaryEndGeometry;
  final AlignmentGeometry? secondaryBeginGeometry;
  final AlignmentGeometry? secondaryEndGeometry;
  final TextDirection textDirectionForGeometry;
  final bool animateAlignments;
  final bool reverse;
  final Widget? child;

  @override
  State<AnimateGradient> createState() => _AnimateGradientState();
}

class _AnimateGradientState extends State<AnimateGradient> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  late List<ColorTween> _colorTween;
  late AlignmentTween begin;
  late AlignmentTween end;
  List<Color> primaryColors = [];
  List<Color> secondaryColors = [];

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void didUpdateWidget(_) {
    _initialize();
    super.didUpdateWidget(_);
  }

  void _initialize() {
    primaryColors = widget.primaryColors;
    secondaryColors = widget.secondaryColors;
    _colorTween = _getColorTweens();
    if (widget.animateAlignments) _setAlignmentTweens();
    _setAnimations();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.animateAlignments ? begin.evaluate(_animation) : widget.primaryBegin,
              end: widget.animateAlignments ? end.evaluate(_animation) : widget.primaryEnd,
              colors: _evaluateColors(_animation),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }

  List<ColorTween> _getColorTweens() {
    if (widget.primaryColors.length != widget.secondaryColors.length) {
      throw Exception('primaryColors.length != secondaryColors.length');
    }

    final List<ColorTween> colorTweens = [];
    for (int i = 0; i < primaryColors.length; i++) {
      colorTweens.add(ColorTween(begin: primaryColors[i], end: secondaryColors[i]));
    }
    return colorTweens;
  }

  List<Color> _evaluateColors(Animation<double> animation) {
    final List<Color> colors = [];
    for (int i = 0; i < _colorTween.length; i++) {
      colors.add(_colorTween[i].evaluate(animation)!);
    }
    return colors;
  }

  void _setAlignmentTweens() {
    final primaryBeginGeometry = widget.primaryBeginGeometry?.resolve(widget.textDirectionForGeometry);
    final primaryEndGeometry = widget.primaryEndGeometry?.resolve(widget.textDirectionForGeometry);
    final secondaryBeginGeometry = widget.secondaryBeginGeometry?.resolve(widget.textDirectionForGeometry);
    final secondaryEndGeometry = widget.secondaryEndGeometry?.resolve(widget.textDirectionForGeometry);

    begin = AlignmentTween(
      begin: primaryBeginGeometry ?? widget.primaryBegin,
      end: primaryEndGeometry ?? widget.primaryEnd,
    );
    end = AlignmentTween(
      begin: secondaryBeginGeometry ?? widget.secondaryBegin,
      end: secondaryEndGeometry ?? widget.secondaryEnd,
    );
  }

  void _setAnimations() {
    _controller = widget.controller ??
        AnimationController(
          vsync: this,
          duration: widget.duration,
        )..repeat(reverse: widget.reverse);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularIconButton extends StatelessWidget {
  final String iconAsset;
  final double size;
  final Function? onPressed;

  const CircularIconButton({
    super.key,
    required this.iconAsset,
    this.size = 56,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: RawMaterialButton(
        onPressed: onPressed != null ? onPressed!() : () {},
        shape: const CircleBorder(),
        fillColor: Colors.white.withOpacity(0.16),
        child: SvgPicture.asset(iconAsset)
      ),
    );
  }
}
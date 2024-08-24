import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  const OutlinedText({
    super.key,
    required this.data,
    required this.fontSize,
    this.textColor = Colors.white,
    this.outlineColor = Colors.black,
    this.rotate = false,
  });

  final String data;
  final double fontSize;
  final Color textColor;
  final Color outlineColor;
  final bool rotate;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotate ? 2 : 0,
      child: Text(
        data,
        style: TextStyle(
          inherit: true,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
          shadows: [
            Shadow(offset: const Offset(1, 0), color: outlineColor),
            Shadow(offset: const Offset(0.8, 0.8), color: outlineColor),
            Shadow(offset: const Offset(0, 1), color: outlineColor),
            Shadow(offset: const Offset(-0.8, 0.8), color: outlineColor),
            Shadow(offset: const Offset(-1, 0), color: outlineColor),
            Shadow(offset: const Offset(-0.8, -0.8), color: outlineColor),
            Shadow(offset: const Offset(0, -1), color: outlineColor),
            Shadow(offset: const Offset(0.8, -0.8), color: outlineColor),
          ],
        ),
      ),
    );
  }
}

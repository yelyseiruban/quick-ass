import 'package:flutter/material.dart';

class ItalicText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const ItalicText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> children = [];

    text.splitMapJoin(
      RegExp(r'<i>(.*?)<\/i>'),
      onMatch: (m) {
        children.add(
          TextSpan(
            text: m.group(1),
            style: style.copyWith(
              fontStyle: FontStyle.italic
            )
          ),
        );
        return '';
      },
      onNonMatch: (n) {
        children.add(TextSpan(text: n));
        return '';
      },
    );

    return Text.rich(
      textAlign: TextAlign.center,
      style: style,
      TextSpan(children: children),
    );
  }
}
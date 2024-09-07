import 'package:flutter/material.dart';

class WordChip extends StatelessWidget {
  final String word;

  const WordChip({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(top: 2, bottom: 3, left: 8, right: 8),
      child: Text(
        word,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
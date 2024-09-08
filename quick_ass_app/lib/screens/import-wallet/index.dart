import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ass_app/constants/page_style.dart';
import 'package:quick_ass_app/routes/constants.dart';
import 'package:quick_ass_app/themes/index.dart';
import 'package:quick_ass_app/widgets/buttons/circular_icon_button.dart';
import 'package:quick_ass_app/widgets/buttons/primary_button.dart';
import 'package:quick_ass_app/widgets/italic_text.dart';
import 'package:quick_ass_app/widgets/shared_animation_gradient.dart';

import 'package:quick_ass_app/constants/icons_uri.dart';
import 'package:quick_ass_app/widgets/word_chip.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});

  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> words = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.endsWith(' ')) {
      setState(() {
        words.add(value.trim());
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          context.goNamed(onboarding);
        }
      },
      child: Scaffold(
          body: SharedAnimatedGradient(
        child: SafeArea(
          child: Container(
            padding: pagePadding,
            child: Column(
              children: [
                SvgPicture.asset(rabbitSvg),
                const SizedBox(height: 24,),
                ItalicText(
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(letterSpacing: AppTheme.letterSpacing(-0.5, 46)),
                    text: 'import w<i>a</i>llet'),
                const SizedBox(height: 8,),
                Text(
                  'join the future of fast and fun transactions',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      letterSpacing: AppTheme.letterSpacing(-0.5, 14),
                      height: 1.05),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ...words.map((word) => WordChip(word: word)),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(minWidth: 50),
                                    child: TextField(
                                      controller: _controller,
                                      focusNode: _focusNode,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.labelMedium,
                                      cursorColor: Colors.white.withOpacity(0.32),
                                      decoration: const InputDecoration(
                                        filled: false,
                                        border: InputBorder.none,
                                      ),
                                      onChanged: _onChanged,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircularIconButton(
                      iconAsset: closedEyeSvg,
                      onPressed: () {
                        log('you clicke on eye');
                      },
                    ),
                    const SizedBox(width: 8,),
                    Expanded(
                      child: PrimaryButton(
                        text: 'import wallet',
                        onPressed: () {

                        }
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ass_app/constants/icons_uri.dart';
import 'package:quick_ass_app/constants/page_style.dart';
import 'package:quick_ass_app/routes/constants.dart';
import 'package:quick_ass_app/themes/index.dart';
import 'package:quick_ass_app/widgets/buttons/primary_button.dart';
import 'package:quick_ass_app/widgets/italic_text.dart';
import 'package:quick_ass_app/widgets/shared_animation_gradient.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            context.goNamed(importWallet);
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
                    const Spacer(),
                    ItalicText(
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          letterSpacing: AppTheme.letterSpacing(-0.5, 46)),
                      text: 'shake ph<i>o</i>ne to find others and send ETH quickly'
                    ),
                    const Spacer(),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'join the future of fast and fun transactions',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          letterSpacing: AppTheme.letterSpacing(-0.5, 14),
                          height: 1.05),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    PrimaryButton(
                      text: 'connect wallet',
                      onPressed: () {
                        context.goNamed(importWallet);
                      }
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

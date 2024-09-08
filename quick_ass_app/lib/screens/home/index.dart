import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ass_app/constants/icons_uri.dart';
import 'package:quick_ass_app/constants/page_style.dart';
import 'package:quick_ass_app/routes/constants.dart';
import 'package:quick_ass_app/widgets/buttons/circular_icon_button.dart';
import 'package:quick_ass_app/widgets/shared_animation_gradient.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            context.goNamed(onboarding);
          }
        },
        child: Scaffold(
          body: SharedAnimatedGradient(
            child: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: pagePadding,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          CircularIconButton(iconAsset: shakeSvg, size: 104,),
                          Text('shake your phone to find people nearby', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),)
                        ],
                      ),
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
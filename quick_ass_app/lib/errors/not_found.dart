import 'package:flutter/material.dart';
import 'package:quick_ass_app/constants/colors.dart';
import 'package:quick_ass_app/constants/image_uri.dart';
import 'package:quick_ass_app/widgets/buttons/primary_button.dart';

class NotFound extends StatelessWidget {
  const NotFound({
    super.key,
    this.title = "Plug title here",
    this.subtitle =
    "the subtitle of not found page,)",
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 200,
                maxHeight: 250,
                minWidth: 250,
                maxWidth: 300,
              ),
              child: Image.asset(
                notFoundImage,
                fit: BoxFit.fill,
                width: double.infinity,
                alignment: Alignment.topCenter,
              ),
            ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 30),
            Text(
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            PrimaryButton(
              text: "Go back",
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

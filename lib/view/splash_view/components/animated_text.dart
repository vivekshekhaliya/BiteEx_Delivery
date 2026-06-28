import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

class AnimatedWordsText extends StatefulWidget {
  final VoidCallback? onFinished;

  const AnimatedWordsText({super.key, this.onFinished});

  @override
  State<AnimatedWordsText> createState() => _AnimatedWordsTextState();
}

class _AnimatedWordsTextState extends State<AnimatedWordsText> {
  bool showSecondLine = false;

  @override
  void initState() {
    super.initState();

    /// ⏱ First line complete → show second line
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showSecondLine = true;
        });
      }
    });

    /// ⏱ Full animation complete → trigger callback
    Future.delayed(const Duration(seconds: 4), () {
      widget.onFinished?.call();
    });
  }


  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.4,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ✅ First Line
          OffsetText(
            text: 'Welcome to the BiteEx family',
            duration: const Duration(milliseconds: 120),
            type: AnimationType.letter,
            slideType: SlideAnimationType.topBottom,
            textStyle: textStyle,
            textAlignment: TextAlignment.center,
          ),

          const SizedBox(height: 8),

          /// ✅ Second Line
          if (showSecondLine)
            OffsetText(
              text: 'The exchange of taste.',
              duration: const Duration(milliseconds: 120),
              type: AnimationType.letter,
              slideType: SlideAnimationType.topBottom,
              textStyle: textStyle,
              textAlignment: TextAlignment.center,
            ),
        ],
      ),
    );
  }
}
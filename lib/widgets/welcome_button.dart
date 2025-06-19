import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key, this.imageProvider, this.onTap, this.color, this.borderRadius, this.buttonText, this.textStyle, this.borderColor});
  final ImageProvider? imageProvider;
  final String? buttonText; 
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color!,
          border: Border.all(
            color: borderColor!,
            width: 2,
          ),
          borderRadius: borderRadius!,
        ),
        child: /*imageProvider != null ? Image(image: imageProvider!, fit: BoxFit.contain,)
        : const SizedBox.shrink(),*/ Text(
          //imageProvider!,
          buttonText!,
          textAlign: TextAlign.center,
          style: textStyle!,
        ),
      ),
    );
  }
}

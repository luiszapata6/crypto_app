import 'package:crypto_app/presentation/presentation.dart';
import 'package:flutter/material.dart';

class StaticButton extends StatelessWidget {
  const StaticButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.fontSize,
    this.width,
    this.height,
    this.icon,
    this.color,
    this.textColor,
    this.borderColor,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final String? icon;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height ?? size.height * 0.0566,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? CustomColors().purple,
          ),
          color: color ?? CustomColors().purple,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextPoppins(
                fontSize: fontSize ?? 18,
                text: text,
                color: textColor ?? Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

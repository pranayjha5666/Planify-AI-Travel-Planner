import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;
  final Color buttonColor;
  final Color textColor;
  final BorderRadiusGeometry borderRadius;

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.width,
    this.padding,
    this.margin,
    this.fontSize,
    this.buttonColor = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin?? const EdgeInsets.all(0),
        width: width ?? double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: borderRadius,
          border: Border.all(color: Colors.black)
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize ??16,
            fontFamily: 'Outfit',
            color: textColor,
          ),
        ),
      ),
    );
  }
}

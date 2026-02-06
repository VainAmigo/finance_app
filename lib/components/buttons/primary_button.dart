import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    this.onPressed,
    super.key,
    this.color,
    this.foregroundColor,
    this.child,
  });

  final String text;
  final void Function()? onPressed;
  final Color? color;
  final Color? foregroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: foregroundColor ?? Colors.white,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        backgroundColor: color ?? Colors.amber,
        disabledBackgroundColor: Colors.amber.withValues(alpha: 0.3),
        disabledForegroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: child ?? Text(text),
    );
  }
}

class CenteredProgressingButton extends StatelessWidget {
  const CenteredProgressingButton(this.color, {super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color ?? Colors.white),
    );
  }
}

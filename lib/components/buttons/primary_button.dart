import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    this.onPressed,
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.size = PrimaryButtonSize.medium,
    this.paddingStyle = PrimaryButtonPaddingStyle.regular,
    this.fullWidth = true,
    this.rounded = false,
    this.iconOnly = false,
  });

  final void Function()? onPressed;
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PrimaryButtonSize size;
  final PrimaryButtonPaddingStyle paddingStyle;
  final bool fullWidth;
  final bool rounded;
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;

    final textColor = foregroundColor ?? colorScheme.onPrimary;
    final buttonColor = backgroundColor ?? colorScheme.primary;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: Size(fullWidth ? screenWidth : 0, size.height),
        padding: size.paddingWith(paddingStyle),
        shape: RoundedRectangleBorder(
          borderRadius: rounded
              ? BorderRadius.circular(100)
              : BorderRadius.circular(size.borderRadius),
        ),
        foregroundColor: textColor,
        backgroundColor: buttonColor,
        disabledBackgroundColor: buttonColor.withValues(alpha: 0.3),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: size.iconSize,
              color: isDisabled ? textColor.withValues(alpha: 0.5) : textColor,
            ),
            if (!iconOnly) SizedBox(width: size.iconPadding),
          ],
          if (!iconOnly)
            Text(
              text,
              style: TextStyle(
                color: isDisabled
                    ? textColor.withValues(alpha: 0.5)
                    : textColor,
                fontSize: size.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

enum PrimaryButtonSize { xSmall, small, medium, large }

enum PrimaryButtonPaddingStyle { slim, regular }

extension on PrimaryButtonSize {
  double get height {
    switch (this) {
      case PrimaryButtonSize.xSmall:
        return 32;
      case PrimaryButtonSize.small:
        return 40;
      case PrimaryButtonSize.medium:
        return 56;
      case PrimaryButtonSize.large:
        return 96;
    }
  }

  double get iconSize {
    switch (this) {
      case PrimaryButtonSize.xSmall:
        return 20;
      case PrimaryButtonSize.small:
        return 20;
      case PrimaryButtonSize.medium:
        return 24;
      case PrimaryButtonSize.large:
        return 32;
    }
  }

  double get iconPadding {
    switch (this) {
      case PrimaryButtonSize.xSmall:
        return 4;
      case PrimaryButtonSize.small:
        return 8;
      case PrimaryButtonSize.medium:
        return 8;
      case PrimaryButtonSize.large:
        return 12;
    }
  }

  double get borderRadius {
    switch (this) {
      case PrimaryButtonSize.xSmall:
        return 8;
      case PrimaryButtonSize.small:
        return 8;
      case PrimaryButtonSize.medium:
        return 12;
      case PrimaryButtonSize.large:
        return 16;
    }
  }

  double get fontSize {
    switch (this) {
      case PrimaryButtonSize.xSmall:
        return 12;
      case PrimaryButtonSize.small:
        return 14;
      case PrimaryButtonSize.medium:
        return 16;
      case PrimaryButtonSize.large:
        return 20;
    }
  }

  EdgeInsets paddingWith(PrimaryButtonPaddingStyle style) {
    switch (style) {
      case PrimaryButtonPaddingStyle.slim:
        switch (this) {
          case PrimaryButtonSize.xSmall:
            return const EdgeInsets.symmetric(horizontal: 3, vertical: 2);
          case PrimaryButtonSize.small:
            return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
          case PrimaryButtonSize.medium:
            return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
          case PrimaryButtonSize.large:
            return const EdgeInsets.symmetric(horizontal: 14, vertical: 6);
        }
      case PrimaryButtonPaddingStyle.regular:
        switch (this) {
          case PrimaryButtonSize.xSmall:
            return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
          case PrimaryButtonSize.small:
            return const EdgeInsets.symmetric(horizontal: 16, vertical: 4);
          case PrimaryButtonSize.medium:
            return const EdgeInsets.symmetric(horizontal: 24, vertical: 8);
          case PrimaryButtonSize.large:
            return const EdgeInsets.symmetric(horizontal: 48, vertical: 12);
        }
    }
  }
}

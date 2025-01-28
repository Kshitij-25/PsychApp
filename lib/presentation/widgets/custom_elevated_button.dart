import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    this.buttonLabel,
    this.icon,
    this.iconSize,
    this.textStyle,
    this.buttonStyle,
  });

  final void Function()? onPressed;
  final String? buttonLabel;
  final Widget? icon;
  final double? iconSize;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ElevatedButton.icon(
          style: buttonStyle,
          onPressed: onPressed,
          icon: icon != null
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: icon,
                )
              : const SizedBox.shrink(),
          label: Text(
            buttonLabel ?? '',
            style: textStyle ??
                Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).buttonTheme.colorScheme?.onPrimaryContainer,
                    ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

import 'package:taskify/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.disabled = false,
    this.isOutline = false,
    this.text,
    required this.onTap,
    this.elevation = 0,
    this.verticalPadding = 16,
    this.width,
    this.child,
    this.color,
    this.textColor,
  }) : super(key: key);

  final bool disabled;
  final bool isOutline;
  final String? text;
  final GestureTapCallback onTap;
  final double elevation;
  final double? width;
  final double verticalPadding;
  final Widget? child;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      splashColor: isOutline ? AppColors.blackshade : null,
      highlightColor: theme.primaryColor.withOpacity(0.12),
      elevation: elevation,
      highlightElevation: elevation,
      disabledColor: theme.cardColor,
      minWidth: width ?? double.infinity,
      color: color ?? (isOutline ? Colors.transparent : theme.primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isOutline
            ? BorderSide(color: theme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      onPressed: disabled ? null : onTap,
      child: child ??
          Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Text(
              text ?? '',
              style: TextStyle(
                color: textColor ??
                    (disabled
                        ? Colors.black38
                        : isOutline
                            ? theme.primaryColor
                            : Colors.white),
                fontSize: 20,
                letterSpacing: 0.8,
              ),
            ),
          ),
    );
  }
}

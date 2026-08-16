import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

/// 72 px : le double du minimum tactile recommandé par Android. Délibéré.
const double kCallButtonSize = 72;

class CallButton extends StatelessWidget {
  const CallButton({
    required this.palette,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  final AppPalette palette;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: SizedBox(
        width: kCallButtonSize,
        height: kCallButtonSize,
        child: Material(
          color: colors.button,
          shape: CircleBorder(
            side: BorderSide(color: colors.border, width: 3),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(
              Icons.phone,
              size: kCallButtonSize * 0.5,
              color: colors.onButton,
            ),
          ),
        ),
      ),
    );
  }
}

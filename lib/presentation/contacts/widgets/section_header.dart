import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/core/theme/text_sizes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.palette,
    this.icon,
    this.iconColor,
    this.onLongPress,
    super.key,
  });

  final String title;
  final AppPalette palette;

  final IconData? icon;

  final Color? iconColor;

  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        color: colors.header,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: kHeaderBaseSize * 1.4,
                color: iconColor ?? colors.onHeader,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

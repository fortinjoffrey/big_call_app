import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

/// Jamais d'écran vide sans explication : chaque impasse affiche un texte
/// en gros caractères et, quand c'est utile, une seule action.
class MessageScreen extends StatelessWidget {
  const MessageScreen({
    required this.message,
    required this.palette,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String message;
  final AppPalette palette;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              Material(
                color: colors.button,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: colors.border, width: 3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: InkWell(
                  onTap: onAction,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 22),
                    child: Text(
                      actionLabel!,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: colors.onButton),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

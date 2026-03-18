import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../generated/app_localizations.dart';

class CatalogErrorView extends StatelessWidget {
  const CatalogErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    required this.retryLabel,
  });

  final String? message;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.specialGrey),
            const SizedBox(height: 16),
            Text(
              message ?? AppLocalizations.of(context)!.errorGeneric,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.specialGrey),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(retryLabel),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

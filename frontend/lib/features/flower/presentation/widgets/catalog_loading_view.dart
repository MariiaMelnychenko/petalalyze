import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../shared/widgets/loading_indicator.dart';

class CatalogLoadingView extends StatelessWidget {
  const CatalogLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingIndicator(),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.loading,
            style: const TextStyle(color: AppColors.specialGrey),
          ),
        ],
      ),
    );
  }
}

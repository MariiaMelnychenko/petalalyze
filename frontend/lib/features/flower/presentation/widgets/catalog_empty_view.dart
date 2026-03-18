import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../generated/app_localizations.dart';

class CatalogEmptyView extends StatelessWidget {
  const CatalogEmptyView({
    super.key,
    required this.hasSearch,
    required this.catalogLabel,
  });

  final bool hasSearch;
  final String catalogLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 64, color: AppColors.specialGrey),
          const SizedBox(height: 16),
          Text(
            hasSearch ? AppLocalizations.of(context)!.errorNotFound : catalogLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.specialGrey),
          ),
        ],
      ),
    );
  }
}

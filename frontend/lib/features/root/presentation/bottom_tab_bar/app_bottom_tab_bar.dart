import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/tab_item.dart';
import '../../../../generated/app_localizations.dart';

/// Bottom tab bar with 3 sections: Головна, Каталог, Історія
class AppBottomTabBar extends StatelessWidget {
  const AppBottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static EdgeInsets bottomBarPadding(BuildContext context) {
    return EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: MediaQuery.of(context).padding.bottom + 8,
      top: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: bottomBarPadding(context),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.grey
                  : const Color(0xFFE5E5E5),
              Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E1E1E)
                  : AppColors.white,
            ],
          ),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF404040)
                : AppColors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TabItem(
              icon: Icons.home_rounded,
              label: l10n?.home ?? 'Головна',
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            TabItem(
              icon: Icons.menu_book_rounded,
              label: l10n?.catalog ?? 'Каталог',
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            TabItem(
              icon: Icons.history_rounded,
              label: l10n?.detections ?? 'Історія',
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

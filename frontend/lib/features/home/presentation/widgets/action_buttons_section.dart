import 'package:flutter/material.dart';
import 'package:petalalyze/core/constants/app_colors.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({
    super.key,
    required this.photoLabel,
    required this.importLabel,
    required this.onPhotoTap,
    required this.onImportTap,
  });

  final String photoLabel;
  final String importLabel;
  final VoidCallback onPhotoTap;
  final VoidCallback onImportTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(
            label: photoLabel,
            icon: Icons.camera_alt_rounded,
            onTap: onPhotoTap,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ActionButton(
            label: importLabel,
            icon: Icons.folder_open_rounded,
            onTap: onImportTap,
          ),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
        ),
        const SizedBox(height: 8),
        Material(
          color: AppColors.mediumGreen,
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mediumDarkGreen.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, color: AppColors.white, size: 28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

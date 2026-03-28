import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class FlowerImage extends StatelessWidget {
  const FlowerImage({
    super.key,
    this.imageUrl,
    this.baseUrl,
  });

  final String? imageUrl;
  final String? baseUrl;

  String? get _fullUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    final url = imageUrl!;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '${baseUrl ?? ''}$url';
  }

  @override
  Widget build(BuildContext context) {
    final url = _fullUrl;
    if (url == null) {
      return Container(
        color: AppColors.paleGreen,
        child: const Center(
          child: Icon(
            Icons.local_florist_rounded,
            size: 48,
            color: AppColors.mediumGreen,
          ),
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.paleGreen,
        child: const Center(
          child: Icon(
            Icons.broken_image_rounded,
            size: 48,
            color: AppColors.specialGrey,
          ),
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.paleGreen,
          child: Center(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.mediumGreen,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

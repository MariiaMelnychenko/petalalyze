import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_assets.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final double indicatorSize = size ?? 120;

    return Center(
      child: SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: Lottie.asset(
          AppAssets.flowerLoading,
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}

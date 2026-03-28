import 'package:flutter/material.dart';

import '../../domain/entities/flower.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';
import 'flower_image.dart';

class FlowersGrid extends StatelessWidget {
  const FlowersGrid({
    super.key,
    required this.flowers,
  });

  final List<Flower> flowers;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: flowers.length,
      itemBuilder: (context, index) {
        final flower = flowers[index];
        return FlowerCard(flower: flower);
      },
    );
  }
}

class FlowerCard extends StatelessWidget {
  const FlowerCard({
    super.key,
    required this.flower,
  });

  final Flower flower;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FlowerDetailsRoute(flowerId: flower.id.toString(), flowerName: flower.name).push(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neumorphBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: AppColors.neumorphHighlight,
              offset: Offset(-4, -4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.neumorphShadow,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FlowerImage(
                imageUrl: flower.imageUrl,
                baseUrl: ApiEndpoints.baseUrl,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              margin: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-9, -9),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: Color(0xFFBEBEBE),
                    offset: Offset(9, 9),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Text(
                flower.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../domain/entities/flower.dart';
import 'flower_card.dart';

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

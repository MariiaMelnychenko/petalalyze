import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/flower_details_cubit.dart';
import '../cubit/flower_details_state.dart';

/// Flower details - photo, name, description, characteristics
class FlowerDetailsPage extends StatelessWidget {
  const FlowerDetailsPage({super.key, required this.flowerId, required this.flowerName});

  final String flowerId;
  final String flowerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(flowerName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<FlowerDetailsCubit, FlowerDetailsState>(
        builder: (context, state) {
          if (state.isLoading && state.flower == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isFailure && state.flower == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.specialGrey),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Помилка завантаження',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.specialGrey),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        final id = int.tryParse(flowerId) ?? 0;
                        context.read<FlowerDetailsCubit>().loadFlower(id);
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Повторити'),
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
          final flower = state.flower;
          if (flower == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FlowerImage(imageUrl: flower.imageUrl),
                const SizedBox(height: 16),
                Text(
                  flower.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (flower.latinName != null && flower.latinName!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    flower.latinName!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.specialGrey,
                        ),
                  ),
                ],
                if (flower.description != null && flower.description!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    flower.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                if (flower.season != null && flower.season!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.paleGreen,
                    ),
                    child: Text(flower.season!),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FlowerImage extends StatelessWidget {
  const _FlowerImage({this.imageUrl});

  final String? imageUrl;

  String? get _fullUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    final url = imageUrl!;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '${ApiEndpoints.baseUrl}$url';
  }

  @override
  Widget build(BuildContext context) {
    final url = _fullUrl;
    if (url == null) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: AppColors.paleGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.local_florist_rounded,
            size: 64,
            color: AppColors.mediumGreen,
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: 400,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: AppColors.paleGreen,
          child: const Center(
            child: Icon(Icons.broken_image_rounded, size: 48, color: AppColors.specialGrey),
          ),
        ),
      ),
    );
  }
}

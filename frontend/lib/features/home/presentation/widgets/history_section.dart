import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petalalyze/core/routing/app_navigation.dart';
import 'package:petalalyze/features/detections/domain/entities/detection_list_item.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../generated/app_localizations.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({
    super.key,
    required this.title,
    required this.emptyMessage,
  });

  final String title;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.isHistoryLoading) {
              return SizedBox(
                height: 140,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.loading,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state.isHistoryFailure) {
              return EmptyHistoryPlaceholder(
                message: emptyMessage,
                onRetry: () => context.read<HomeCubit>().loadDetectionHistory(),
                retryLabel: AppLocalizations.of(context)!.retry,
              );
            }
            if (state.isHistoryEmpty) {
              return EmptyHistoryPlaceholder(message: emptyMessage);
            }
            return SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.detections.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = state.detections[index];
                  return HistoryCard(item: item);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.item,
  });

  final DetectionListItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => DetectionDetailsRoute(detectionId: '${item.id}').push(context),
      child: SizedBox(
        width: 160,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.mediumDarkGreen,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.mediumDarkGreen.withValues(alpha: 0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: item.imageUrl.isNotEmpty
                    ? Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.mediumDarkGreen,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.mediumDarkGreen,
                        child: const Icon(
                          Icons.photo_camera_outlined,
                          color: AppColors.white,
                          size: 40,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Розпізнавання #${item.id}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.detectionsCount} ${item.detectionsCount == 1 ? 'квітка' : 'квіт'}',
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyHistoryPlaceholder extends StatelessWidget {
  const EmptyHistoryPlaceholder({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel,
  });

  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.neutralLight,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                height: 1.4,
              ),
            ),
            if (onRetry != null && retryLabel != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onRetry,
                child: Text(retryLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

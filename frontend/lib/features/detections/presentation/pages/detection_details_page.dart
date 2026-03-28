import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/prediction_item.dart';
import '../cubit/detection_details_cubit.dart';
import '../cubit/detection_details_state.dart';

class DetectionDetailsPage extends StatefulWidget {
  const DetectionDetailsPage({super.key, required this.detectionId});

  final String detectionId;

  @override
  State<DetectionDetailsPage> createState() => _DetectionDetailsPageState();
}

class _DetectionDetailsPageState extends State<DetectionDetailsPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Розпізнавання #${widget.detectionId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<DetectionDetailsCubit, DetectionDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isFailure) {
            return _ErrorView(
              message: state.errorMessage ?? 'Не вдалося завантажити деталі',
              onRetry: () {
                final id = int.tryParse(widget.detectionId);
                if (id != null) context.read<DetectionDetailsCubit>().load(id);
              },
            );
          }
          if (!state.isSuccess) return const SizedBox.shrink();
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(DetectionDetailsState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          if ((state.imageUrl ?? '').isNotEmpty ||
              (state.resultImageUrl ?? '').isNotEmpty) ...[
            _buildCarousel(state),
            const SizedBox(height: 6),
            _buildPageIndicator(),
          ],
          _ConfidenceSlider(
            threshold: state.threshold,
            totalCount: state.fullDetections.length,
            filteredCount: state.filteredDetections.length,
            onChanged: (v) => context.read<DetectionDetailsCubit>().updateThreshold(v),
          ),
          if (!state.hasResults)
            const _EmptyFiltered()
          else ...[
            _buildStatsSection(state),
            _buildCropsSection(state),
          ],
        ],
      ),
    );
  }

  Widget _buildCarousel(DetectionDetailsState state) {
    return SizedBox(
      height: 300,
      child: PageView(
        controller: _pageController,
        onPageChanged: (p) => setState(() => _currentPage = p),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: (state.imageUrl ?? '').isNotEmpty
                  ? Image.network(
                      state.imageUrl!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => _imageError(),
                    )
                  : _imageError(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: (state.resultImageUrl ?? '').isNotEmpty
                  ? Image.network(
                      state.resultImageUrl!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => _imageError(),
                    )
                  : _imageError(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageError() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(child: Icon(Icons.image_not_supported, size: 36)),
    );
  }

  Widget _buildPageIndicator() {
    const labels = ['Оригінал', 'Розпізнавання'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (i) {
        final active = _currentPage == i;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: active ? 10 : 8,
                height: active ? 10 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? AppColors.mediumDarkGreen : Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? AppColors.mediumDarkGreen : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsSection(DetectionDetailsState state) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          'Детальна статистика (${state.filteredDetections.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.mediumDarkGreen,
          ),
        ),
        leading: const Icon(Icons.bar_chart_rounded, color: AppColors.mediumGreen),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                for (final det in state.filteredDetections) ...[
                  _DetectionCard(detection: det),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropsSection(DetectionDetailsState state) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          'Кропи квітів (${state.filteredDetections.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.mediumDarkGreen,
          ),
        ),
        leading: const Icon(Icons.crop_original_rounded, color: AppColors.mediumGreen),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.82,
              ),
              itemCount: state.filteredDetections.length,
              itemBuilder: (_, idx) {
                final det = state.filteredDetections[idx];
                return _CropCard(detection: det);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Спробувати ще раз'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfidenceSlider extends StatelessWidget {
  const _ConfidenceSlider({
    required this.threshold,
    required this.totalCount,
    required this.filteredCount,
    required this.onChanged,
  });

  final double threshold;
  final int totalCount;
  final int filteredCount;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Впевненість >= ${threshold.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mediumDarkGreen,
                ),
              ),
              const Spacer(),
              Text('$filteredCount / $totalCount',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            ],
          ),
          Slider(
            value: threshold,
            min: 0.0,
            max: 1.0,
            divisions: 100,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _DetectionCard extends StatelessWidget {
  const _DetectionCard({required this.detection});

  final PredictionItem detection;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(Icons.local_florist, color: AppColors.mediumGreen, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              detection.className,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${(detection.confidence * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _CropCard extends StatelessWidget {
  const _CropCard({required this.detection});

  final PredictionItem detection;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: (detection.cropUrl ?? '').isNotEmpty
                ? Image.network(
                    detection.cropUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  )
                : Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: AppColors.mediumGreen.withValues(alpha: 0.1),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    detection.className,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${(detection.confidence * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFiltered extends StatelessWidget {
  const _EmptyFiltered();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_list_off, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Немає результатів вище порогу',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:petalalyze/generated/app_localizations.dart';
import 'package:petalalyze/shared/widgets/loading_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/prediction_item.dart';
import '../cubit/predict_result_cubit.dart';
import '../cubit/predict_result_state.dart';

class PredictResultPage extends StatefulWidget {
  const PredictResultPage({super.key});

  @override
  State<PredictResultPage> createState() => _PredictResultPageState();
}

class _PredictResultPageState extends State<PredictResultPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  Size? _imageSize;
  List<Uint8List> _allCrops = [];
  bool _cropsReady = false;
  bool _processing = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _processImage(PredictResultState state) async {
    if (state.imagePath == null || _processing) return;
    _processing = true;

    try {
      final bytes = await File(state.imagePath!).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final size = Size(image.width.toDouble(), image.height.toDouble());

      final crops = <Uint8List>[];
      for (final det in state.fullDetections) {
        crops.add(
          det.bbox.length == 4 ? await _paddedCrop(image, det.bbox) : Uint8List(0),
        );
      }

      image.dispose();

      if (mounted) {
        setState(() {
          _imageSize = size;
          _allCrops = crops;
          _cropsReady = true;
        });
      }
    } catch (e) {
      debugPrint('Image processing error: $e');
    }
  }

  static Future<Uint8List> _paddedCrop(
    ui.Image image,
    List<double> bbox, {
    double padRatio = 0.3,
  }) async {
    final x1 = bbox[0], y1 = bbox[1], x2 = bbox[2], y2 = bbox[3];
    final imgW = image.width.toDouble(), imgH = image.height.toDouble();
    final bw = x2 - x1, bh = y2 - y1;

    final cx1 = (x1 - bw * padRatio).clamp(0.0, imgW);
    final cy1 = (y1 - bh * padRatio).clamp(0.0, imgH);
    final cx2 = (x2 + bw * padRatio).clamp(0.0, imgW);
    final cy2 = (y2 + bh * padRatio).clamp(0.0, imgH);

    final cropW = (cx2 - cx1).round();
    final cropH = (cy2 - cy1).round();
    if (cropW <= 0 || cropH <= 0) return Uint8List(0);

    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawImageRect(
      image,
      Rect.fromLTRB(cx1, cy1, cx2, cy2),
      Rect.fromLTWH(0, 0, cropW.toDouble(), cropH.toDouble()),
      Paint(),
    );

    final pic = recorder.endRecording();
    final cropped = await pic.toImage(cropW, cropH);
    final data = await cropped.toByteData(format: ui.ImageByteFormat.png);
    cropped.dispose();
    return data?.buffer.asUint8List() ?? Uint8List(0);
  }

  List<int> _filteredIndices(PredictResultState state) {
    return [
      for (int i = 0; i < state.fullDetections.length; i++)
        if (state.fullDetections[i].confidence >= state.threshold) i,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Результат розпізнавання'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<PredictResultCubit, PredictResultState>(
        listener: (context, state) {
          if (state.isSuccess && !_cropsReady) _processImage(state);
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.loading,
                    style: const TextStyle(color: AppColors.specialGrey),
                  ),
                ],
              ),
            );
          }
          if (state.isFailure) {
            return _ErrorView(
              message: state.errorMessage ?? 'Помилка розпізнавання',
              onRetry: () {
                if (state.imagePath != null) {
                  context.read<PredictResultCubit>().predict(state.imagePath!);
                }
              },
            );
          }
          if (state.isSuccess) return _buildBody(state);
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(PredictResultState state) {
    final indices = _filteredIndices(state);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          if (state.imagePath != null) ...[
            _buildCarousel(state),
            const SizedBox(height: 6),
            _buildPageIndicator(),
          ],
          _ConfidenceSlider(
            threshold: state.threshold,
            totalCount: state.fullDetections.length,
            filteredCount: state.filteredDetections.length,
          ),
          if (!state.hasResults)
            const _EmptyFiltered()
          else ...[
            _buildStatsSection(state),
            _buildCropsSection(state, indices),
          ],
        ],
      ),
    );
  }

  // ── Image carousel ──────────────────────────────────────

  Widget _buildCarousel(PredictResultState state) {
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
              child: Image.file(
                File(state.imagePath!),
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _imageSize != null
                  ? _AnnotatedImage(
                      imagePath: state.imagePath!,
                      detections: state.filteredDetections,
                      imageSize: _imageSize!,
                    )
                  : Image.file(
                      File(state.imagePath!),
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
            ),
          ),
        ],
      ),
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

  // ── Collapsible sections ────────────────────────────────

  Widget _buildStatsSection(PredictResultState state) {
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

  Widget _buildCropsSection(PredictResultState state, List<int> indices) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          'Кропи квітів (${indices.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.mediumDarkGreen,
          ),
        ),
        leading: const Icon(Icons.crop_original_rounded, color: AppColors.mediumGreen),
        children: [
          if (!_cropsReady)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else
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
                itemCount: indices.length,
                itemBuilder: (_, idx) {
                  final i = indices[idx];
                  final det = state.fullDetections[i];
                  final bytes = i < _allCrops.length ? _allCrops[i] : null;
                  return _CropCard(detection: det, cropBytes: bytes);
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Private widgets
// ═══════════════════════════════════════════════════════════

class _AnnotatedImage extends StatelessWidget {
  const _AnnotatedImage({
    required this.imagePath,
    required this.detections,
    required this.imageSize,
  });

  final String imagePath;
  final List<PredictionItem> detections;
  final Size imageSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final aspect = imageSize.width / imageSize.height;
      double w = constraints.maxWidth;
      double h = w / aspect;
      if (h > constraints.maxHeight) {
        h = constraints.maxHeight;
        w = h * aspect;
      }

      return Center(
        child: SizedBox(
          width: w,
          height: h,
          child: Stack(
            children: [
              Image.file(File(imagePath), width: w, height: h, fit: BoxFit.fill),
              CustomPaint(
                size: Size(w, h),
                painter: _BBoxPainter(
                  detections: detections,
                  imageSize: imageSize,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _BBoxPainter extends CustomPainter {
  _BBoxPainter({required this.detections, required this.imageSize});

  final List<PredictionItem> detections;
  final Size imageSize;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / imageSize.width;
    final sy = size.height / imageSize.height;

    final boxPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final bgPaint = Paint()..color = Colors.green.withValues(alpha: 0.78);

    for (final det in detections) {
      if (det.bbox.length < 4) continue;

      final x1 = det.bbox[0] * sx;
      final y1 = det.bbox[1] * sy;
      final x2 = det.bbox[2] * sx;
      final y2 = det.bbox[3] * sy;

      canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2), boxPaint);

      final text = '${det.className}  ${(det.confidence * 100).toStringAsFixed(0)}%';
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelH = tp.height + 6;
      final labelY = (y1 - labelH).clamp(0.0, size.height - labelH);
      canvas.drawRRect(
        RRect.fromLTRBR(x1, labelY, x1 + tp.width + 10, labelY + labelH, Radius.zero),
        bgPaint,
      );
      tp.paint(canvas, Offset(x1 + 5, labelY + 3));
    }
  }

  @override
  bool shouldRepaint(covariant _BBoxPainter old) => detections != old.detections;
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
            Text(message,
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
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
  });

  final double threshold;
  final int totalCount;
  final int filteredCount;

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
                'Впевненість \u2265 ${threshold.toStringAsFixed(2)}',
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
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.mediumGreen,
              inactiveTrackColor: AppColors.mediumGreen.withValues(alpha: 0.2),
              thumbColor: AppColors.mediumDarkGreen,
              overlayColor: AppColors.mediumGreen.withValues(alpha: 0.15),
            ),
            child: Slider(
              value: threshold,
              min: 0.0,
              max: 1.0,
              divisions: 100,
              onChanged: (v) => context.read<PredictResultCubit>().updateThreshold(v),
            ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_florist, color: AppColors.mediumGreen, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(detection.className,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              _ConfidenceBadge(value: detection.confidence),
            ],
          ),
          const SizedBox(height: 10),
          _ConfidenceBar(label: 'Загальна', value: detection.confidence),
          if (detection.yoloConfidence != null) ...[
            const SizedBox(height: 6),
            _ConfidenceBar(label: 'YOLO', value: detection.yoloConfidence!),
          ],
          if (detection.ensembleConfidence != null) ...[
            const SizedBox(height: 6),
            _ConfidenceBar(label: 'Ансамбль', value: detection.ensembleConfidence!),
          ],
        ],
      ),
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.value});
  final double value;

  Color get _color => value >= 0.8
      ? AppColors.mediumGreen
      : value >= 0.5
          ? Colors.orange
          : AppColors.red;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${(value * 100).toStringAsFixed(1)}%',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _color),
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  const _ConfidenceBar({required this.label, required this.value});
  final String label;
  final double value;

  Color get _color => value >= 0.8
      ? AppColors.mediumGreen
      : value >= 0.5
          ? Colors.orange
          : AppColors.red;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
          width: 80,
          child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(_color),
          ),
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
        width: 42,
        child: Text('${(value * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ),
    ]);
  }
}

class _CropCard extends StatelessWidget {
  const _CropCard({required this.detection, this.cropBytes});

  final PredictionItem detection;
  final Uint8List? cropBytes;

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
            child: cropBytes != null && cropBytes!.isNotEmpty
                ? Image.memory(cropBytes!, fit: BoxFit.cover)
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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: detection.confidence >= 0.8
                        ? AppColors.mediumGreen
                        : detection.confidence >= 0.5
                            ? Colors.orange
                            : AppColors.red,
                  ),
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

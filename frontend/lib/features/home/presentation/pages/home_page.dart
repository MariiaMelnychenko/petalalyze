import 'package:flutter/material.dart';
import 'package:petalalyze/core/constants/app_assets.dart';
import 'package:petalalyze/core/di/injection.dart' as di;
import 'package:petalalyze/features/detections/domain/usecases/detect_image_usecase.dart';
import 'package:petalalyze/shared/image_picker/image_picker_exceptions.dart';
import 'package:petalalyze/shared/image_picker/image_picker_service.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../generated/app_localizations.dart';
import '../widgets/home_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ImagePickerService _imagePickerService;
  late final DetectImageUseCase _detectImageUseCase;

  @override
  void initState() {
    super.initState();
    _imagePickerService = di.sl<ImagePickerService>();
    _detectImageUseCase = di.sl<DetectImageUseCase>();
  }

  Future<void> _handleTakePhoto() async {
    try {
      final path = await _imagePickerService.takePhoto();
      if (path != null && mounted) {
        await _openDetectionWithImage(path);
      }
    } on ImagePickerPermissionException catch (e) {
      if (e.isPermanentlyDenied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.noCameraAccess),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleImportImage() async {
    try {
      final path = await _imagePickerService.pickSingleImage();
      if (path != null && mounted) {
        await _openDetectionWithImage(path);
      }
    } on ImagePickerPermissionException catch (e) {
      if (e.isPermanentlyDenied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.noGalleryAccess),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  Future<void> _openDetectionWithImage(String imagePath) async {
    try {
      final detectionId = await _detectImageUseCase(imagePath);
      if (mounted) {
        DetectionResultRoute(detectionId: '$detectionId').push(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          l10n.appTitle,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.mediumDarkGreen,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HowItWorksSection(
                        title: l10n.howItWorks,
                        step1Title: l10n.step1Title,
                        step1Text: l10n.step1Text,
                        step1Image: AppAssets.photoIcon,
                        step2Title: l10n.step2Title,
                        step2Text: l10n.step2Text,
                        step2Image: AppAssets.analysisIcon,
                        step3Title: l10n.step3Title,
                        step3Text: l10n.step3Text,
                        step3Image: AppAssets.resultFlowerIcon,
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                            top: 3,
                            left: 3,
                            right: 3,
                            bottom: 24,
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.mediumGreen.withValues(alpha: 0.3),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(33),
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Text(
                                      l10n.homeTitle,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.mediumDarkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: ActionButtonsSection(
                                  photoLabel: l10n.photo,
                                  importLabel: l10n.import,
                                  onPhotoTap: () => _handleTakePhoto(),
                                  onImportTap: () => _handleImportImage(),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: HistorySection(
                                  title: l10n.historySection,
                                  emptyMessage: l10n.noDetectionsYet,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

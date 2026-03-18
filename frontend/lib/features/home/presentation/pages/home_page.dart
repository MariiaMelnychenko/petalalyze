import 'package:flutter/material.dart';
import 'package:petalalyze/core/constants/app_assets.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../generated/app_localizations.dart';
import '../widgets/home_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                                  // borderRadius: BorderRadius.all(Radius.circular(32))
                                  borderRadius: BorderRadius.vertical(
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
                                  onPhotoTap: () => _openDetection(context),
                                  onImportTap: () => _openDetection(context),
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

  void _openDetection(BuildContext context) {
    const DetectionResultRoute(detectionId: '1').push(context);
  }
}

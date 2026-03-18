import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../generated/app_localizations.dart';
import '../../../detections/presentation/cubit/detection_history_cubit.dart';
import '../../../detections/presentation/cubit/detection_history_state.dart';

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HowItWorksSection(
                title: l10n.howItWorks,
                step1Title: l10n.step1Title,
                step1Text: l10n.step1Text,
                step2Title: l10n.step2Title,
                step2Text: l10n.step2Text,
                step3Title: l10n.step3Title,
                step3Text: l10n.step3Text,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(33),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _HeaderSection(
                        title: l10n.appTitle,
                        subtitle: l10n.homeTitle,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _ActionButtonsSection(
                        photoLabel: l10n.photo,
                        importLabel: l10n.import,
                        onPhotoTap: () => _openDetection(context),
                        onImportTap: () => _openDetection(context),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _HistorySection(
                        title: l10n.historySection,
                        emptyMessage: l10n.noDetectionsYet,
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

  void _openDetection(BuildContext context) {
    const DetectionResultRoute(detectionId: '1').push(context);
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.mediumDarkGreen,
          ),
        ),
      ],
    );
  }
}

class _HowItWorksSection extends StatefulWidget {
  const _HowItWorksSection({
    required this.title,
    required this.step1Title,
    required this.step1Text,
    required this.step2Title,
    required this.step2Text,
    required this.step3Title,
    required this.step3Text,
  });

  final String title;
  final String step1Title;
  final String step1Text;
  final String step2Title;
  final String step2Text;
  final String step3Title;
  final String step3Text;

  @override
  State<_HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<_HowItWorksSection> {
  late PageController _controller;
  double _page = 1;

  static const _steps = 3;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.7,
      initialPage: 1,
    );
    _controller.addListener(() {
      setState(() {
        _page = _controller.page ?? 1;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  (String title, String text) _stepAt(int index) {
    final i = index % _steps;
    switch (i) {
      case 0:
        return (widget.step1Title, widget.step1Text);
      case 1:
        return (widget.step2Title, widget.step2Text);
      default:
        return (widget.step3Title, widget.step3Text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Text(
        //     widget.title,
        //     style: const TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.w600,
        //       color: AppColors.mediumDarkGreen,
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _controller,
            itemCount: 3,
            itemBuilder: (context, index) {
              final distance = (_page - index).abs();
              final scale = (1 - distance * 0.25).clamp(0.75, 1.0);
              final (title, text) = _stepAt(index);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Transform.scale(
                    scale: scale,
                    child: _HowItWorksCard(title: title, text: text),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(28),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.mediumDarkGreen,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtonsSection extends StatelessWidget {
  const _ActionButtonsSection({
    required this.photoLabel,
    required this.importLabel,
    required this.onPhotoTap,
    required this.onImportTap,
  });

  final String photoLabel;
  final String importLabel;
  final VoidCallback onPhotoTap;
  final VoidCallback onImportTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: photoLabel,
            icon: Icons.camera_alt_rounded,
            onTap: onPhotoTap,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionButton(
            label: importLabel,
            icon: Icons.folder_open_rounded,
            onTap: onImportTap,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
        ),
        const SizedBox(height: 8),
        Material(
          color: AppColors.mediumDarkGreen,
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mediumDarkGreen.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, color: AppColors.white, size: 28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({
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
        BlocBuilder<DetectionHistoryCubit, DetectionHistoryState>(
          builder: (context, state) {
            if (state.isLoading) {
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
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state.isEmpty) {
              return Container(
                height: 140,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.neutralLight,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    emptyMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                      height: 1.4,
                    ),
                  ),
                ),
              );
            }
            return SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.detections.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final detectionId = state.detections[index];
                  return GestureDetector(
                    onTap: () => DetectionDetailsRoute(detectionId: detectionId)
                        .push(context),
                    child: SizedBox(
                      width: 160,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.mediumDarkGreen,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Розпізнавання #$detectionId',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

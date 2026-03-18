import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petalalyze/core/constants/app_colors.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../generated/app_localizations.dart';
import '../cubit/detection_history_cubit.dart';
import '../cubit/detection_history_state.dart';

/// Detection history - list of previous detections
class DetectionHistoryPage extends StatelessWidget {
  const DetectionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(l10n?.detections ?? 'Історія'),
      ),
      body: BlocBuilder<DetectionHistoryCubit, DetectionHistoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n?.noDetectionsYet ?? 'Ще не було розпізнавань.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.detections.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = state.detections[index];
              return ListTile(
                tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text('Розпізнавання #${item.id}'),
                subtitle: Text('${item.detectionsCount} квіт'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () => DetectionDetailsRoute(detectionId: '${item.id}').push(context),
              );
            },
          );
        },
      ),
    );
  }
}

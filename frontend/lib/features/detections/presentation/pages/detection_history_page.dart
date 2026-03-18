import 'package:flutter/material.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../generated/app_localizations.dart';

/// Detection history - list of previous detections
class DetectionHistoryPage extends StatelessWidget {
  const DetectionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final history = const ['10', '11', '12'];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.detections ?? 'Історія'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final detectionId = history[index];
          return ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Розпізнавання #$detectionId'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => DetectionDetailsRoute(detectionId: detectionId).push(context),
          );
        },
      ),
    );
  }
}

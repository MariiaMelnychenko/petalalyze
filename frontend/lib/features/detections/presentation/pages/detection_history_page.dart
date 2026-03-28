import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petalalyze/core/constants/app_colors.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../generated/app_localizations.dart';
import '../../domain/entities/detection_list_item.dart';
import '../cubit/detection_history_cubit.dart';
import '../cubit/detection_history_state.dart';

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
          if (state.isLoading && state.detections.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => context.read<DetectionHistoryCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n?.noDetectionsYet ?? 'Ще не було розпізнавань.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<DetectionHistoryCubit>().load(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.detections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = state.detections[index];
                return _DetectionTile(item: item);
              },
            ),
          );
        },
      ),
    );
  }
}

class _DetectionTile extends StatelessWidget {
  const _DetectionTile({required this.item});

  final DetectionListItem item;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd.MM.yyyy  HH:mm').format(item.createdAt);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        context.read<DetectionHistoryCubit>().deleteDetection(item.id);
      },
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: const CircleAvatar(
          backgroundColor: AppColors.mediumGreen,
          child: Icon(Icons.local_florist_rounded, color: AppColors.mediumDarkGreen),
        ),
        title: Text('Розпізнавання #${item.id}'),
        subtitle: Text('$dateStr  •  ${item.detectionsCount} квіт'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade300, size: 22),
              onPressed: () async {
                final confirmed = await _confirmDelete(context);
                if (confirmed && context.mounted) {
                  context.read<DetectionHistoryCubit>().deleteDetection(item.id);
                }
              },
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
        onTap: () => DetectionDetailsRoute(detectionId: '${item.id}').push(context),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Видалити?'),
        content: const Text('Це розпізнавання буде видалено назавжди.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

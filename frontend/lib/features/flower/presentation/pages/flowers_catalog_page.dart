import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petalalyze/features/flower/domain/entities/flower.dart';
import 'package:petalalyze/shared/widgets/loading_indicator.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../generated/app_localizations.dart';
import '../cubit/flowers_catalog_cubit.dart';
import '../cubit/flowers_catalog_state.dart';

/// Flowers catalog - grid with search, loads from backend
class FlowersCatalogPage extends StatefulWidget {
  const FlowersCatalogPage({super.key});

  @override
  State<FlowersCatalogPage> createState() => _FlowersCatalogPageState();
}

class _FlowersCatalogPageState extends State<FlowersCatalogPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SearchBar(
              controller: _searchController,
              hintText: l10n.search,
              onChanged: (q) => context.read<FlowersCatalogCubit>().updateSearchQuery(q),
            ),
            Expanded(
              child: BlocBuilder<FlowersCatalogCubit, FlowersCatalogState>(
                builder: (context, state) {
                  if (state.isLoading && state.flowers.isEmpty) {
                    return const _LoadingView();
                  }
                  if (state.isFailure && state.flowers.isEmpty) {
                    return _ErrorView(
                      message: state.errorMessage,
                      onRetry: () => context.read<FlowersCatalogCubit>().loadFlowers(),
                      retryLabel: l10n.retry,
                    );
                  }
                  final flowers = state.filteredFlowers;
                  if (flowers.isEmpty) {
                    return _EmptyView(
                      hasSearch: state.searchQuery.isNotEmpty,
                      catalogLabel: l10n.catalog,
                    );
                  }
                  return _FlowersGrid(flowers: flowers);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(width: 1, color: AppColors.lightGrey),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.specialGrey,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: AppColors.mediumGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
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
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.retryLabel,
  });

  final String? message;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.specialGrey),
            const SizedBox(height: 16),
            Text(
              message ?? AppLocalizations.of(context)!.errorGeneric,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.specialGrey),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(retryLabel),
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
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.hasSearch, required this.catalogLabel});

  final bool hasSearch;
  final String catalogLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 64, color: AppColors.specialGrey),
          const SizedBox(height: 16),
          Text(
            hasSearch ? AppLocalizations.of(context)!.errorNotFound : catalogLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.specialGrey),
          ),
        ],
      ),
    );
  }
}

class _FlowersGrid extends StatelessWidget {
  const _FlowersGrid({required this.flowers});

  final List<Flower> flowers;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: flowers.length,
      itemBuilder: (context, index) {
        final flower = flowers[index];
        return _FlowerCard(flower: flower);
      },
    );
  }
}

class _FlowerCard extends StatelessWidget {
  const _FlowerCard({required this.flower});

  final Flower flower;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FlowerDetailsRoute(flowerId: flower.id.toString()).push(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neumorphBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: AppColors.neumorphHighlight,
              offset: Offset(-4, -4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.neumorphShadow,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _FlowerImage(
                imageUrl: flower.imageUrl,
                baseUrl: ApiEndpoints.baseUrl,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              margin: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(22),
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
              //TODO: може глос бахнути на назву
              child: Text(
                flower.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowerImage extends StatelessWidget {
  const _FlowerImage({this.imageUrl, this.baseUrl});

  final String? imageUrl;
  final String? baseUrl;

  String? get _fullUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    final url = imageUrl!;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '${baseUrl ?? ''}$url';
  }

  @override
  Widget build(BuildContext context) {
    final url = _fullUrl;
    if (url == null) {
      return Container(
        color: AppColors.paleGreen,
        child: const Center(
          child: Icon(
            Icons.local_florist_rounded,
            size: 48,
            color: AppColors.mediumGreen,
          ),
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.paleGreen,
        child: const Center(
          child: Icon(
            Icons.broken_image_rounded,
            size: 48,
            color: AppColors.specialGrey,
          ),
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.paleGreen,
          child: Center(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.mediumGreen,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

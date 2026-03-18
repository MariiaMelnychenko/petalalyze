import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../generated/app_localizations.dart';
import '../cubit/flowers_catalog_cubit.dart';
import '../cubit/flowers_catalog_state.dart';
import '../widgets/catalog_widgets.dart';

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
            CatalogSearchBar(
              controller: _searchController,
              hintText: l10n.search,
              onChanged: (q) =>
                  context.read<FlowersCatalogCubit>().updateSearchQuery(q),
            ),
            Expanded(
              child: BlocBuilder<FlowersCatalogCubit, FlowersCatalogState>(
                builder: (context, state) {
                  if (state.isLoading && state.flowers.isEmpty) {
                    return const CatalogLoadingView();
                  }
                  if (state.isFailure && state.flowers.isEmpty) {
                    return CatalogErrorView(
                      message: state.errorMessage,
                      onRetry: () =>
                          context.read<FlowersCatalogCubit>().loadFlowers(),
                      retryLabel: l10n.retry,
                    );
                  }
                  final flowers = state.filteredFlowers;
                  if (flowers.isEmpty) {
                    return CatalogEmptyView(
                      hasSearch: state.searchQuery.isNotEmpty,
                      catalogLabel: l10n.catalog,
                    );
                  }
                  return FlowersGrid(flowers: flowers);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:finance_app/domain/domain.dart';
import 'package:finance_app/presentation/presentaion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Экран транзакций: отображение категорий и подкатегорий пользователя.
class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Транзакции'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.addTransaction),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<CategoriesCubit>().load(),
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            return switch (state) {
              CategoriesInitial() || CategoriesLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              CategoriesError(:final message) => _ErrorContent(
                  message: message,
                  onRetry: () => context.read<CategoriesCubit>().load(),
                ),
              CategoriesLoaded(:final items) => items.isEmpty
                  ? _EmptyContent()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizing.defaultPadding,
                        vertical: AppSizing.spaceBtwElements,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _CategoryTile(item: items[index]);
                      },
                    ),
            };
          },
        ),
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  const _CategoryTile({required this.item});

  final CategoryWithSubCategories item;

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final category = widget.item.category;
    final subCategories = widget.item.subCategories;
    final hasSubs = category.hasSubCategories && subCategories.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizing.spaceBtwItems),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CategoryCard(
            title: category.name,
            subtitle: hasSubs
                ? '${subCategories.length} подкатегорий'
                : category.currency,
            leading: _CategoryLeading(colorId: category.colorId),
            trailing: hasSubs
                ? Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).colorScheme.onSecondary,
                  )
                : null,
            onTap: hasSubs
                ? () => setState(() => _isExpanded = !_isExpanded)
                : null,
          ),
          if (hasSubs && _isExpanded) ...[
            const SizedBox(height: AppSizing.spaceBtwItems),
            ...subCategories.map(
              (sub) => Padding(
                padding: const EdgeInsets.only(left: AppSizing.spaceBtwElements),
                child: _SubCategoryTile(subCategory: sub),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryLeading extends StatelessWidget {
  const _CategoryLeading({required this.colorId});

  final String colorId;

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(colorId, context);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizing.borderRadius8),
      ),
      child: Icon(
        Icons.category_outlined,
        color: _contrastColor(color),
        size: AppSizing.iconSizeM,
      ),
    );
  }

  Color _parseColor(String colorId, BuildContext context) {
    if (colorId.isEmpty) {
      return Theme.of(context).colorScheme.primary;
    }
    final hex = colorId.replaceFirst('#', '');
    if (hex.length == 6 || hex.length == 8) {
      try {
        return Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}
    }
    return Theme.of(context).colorScheme.primary;
  }

  Color _contrastColor(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}

class _SubCategoryTile extends StatelessWidget {
  const _SubCategoryTile({required this.subCategory});

  final SubCategoryEntity subCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizing.spaceBtwItems),
      child: CategoryCard(
        title: subCategory.name,
        style: CategoryCardStyle.outlined,
        leading: SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            Icons.subdirectory_arrow_right,
            color: Theme.of(context).colorScheme.onSecondary,
            size: AppSizing.iconSizeS,
          ),
        ),
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              const SizedBox(height: AppSizing.spaceBtwElements),
              Text(
                'Нет категорий',
                style: AppTextStyles.listTileTitle(context),
              ),
              const SizedBox(height: AppSizing.spaceBtwItems),
              Text(
                'Добавьте категории в настройках',
                style: AppTextStyles.listTileSubtitle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizing.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: AppSizing.spaceBtwElements),
                Text(
                  'Ошибка загрузки',
                  style: AppTextStyles.listTileTitle(context),
                ),
                const SizedBox(height: AppSizing.spaceBtwItems),
                Text(
                  message,
                  style: AppTextStyles.listTileSubtitle(context),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizing.spaceBtwElements),
                TextButton(
                  onPressed: onRetry,
                  child: const Text('Повторить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

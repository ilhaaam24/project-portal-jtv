import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/biro_entity.dart';
import 'package:portal_jtv/config/injection/injection.dart' as di;

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<CategoryBloc>()..add(const LoadCategories()),
      child: const _CategoryView(),
    );
  }
}

class _CategoryView extends StatefulWidget {
  const _CategoryView();

  @override
  State<_CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<_CategoryView> {
  bool _isBiroExpanded = true;
  bool _isKanalExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori'), centerTitle: true),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          switch (state.status) {
            case CategoryStatus.initial:
            case CategoryStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case CategoryStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(state.errorMessage ?? 'Gagal memuat'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CategoryBloc>().add(
                        const LoadCategories(),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );

            case CategoryStatus.success:
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── BIRO DROPDOWN ───
                    _DropdownSection(
                      title: 'Biro',
                      isExpanded: _isBiroExpanded,
                      onToggle: () =>
                          setState(() => _isBiroExpanded = !_isBiroExpanded),
                      child: _buildBiroGrid(context, state.biros),
                    ),

                    const Divider(),
                    const SizedBox(height: 4),

                    // ─── KANAL DROPDOWN ───
                    _DropdownSection(
                      title: 'Kanal',
                      isExpanded: _isKanalExpanded,
                      onToggle: () =>
                          setState(() => _isKanalExpanded = !_isKanalExpanded),
                      child: _buildCategoryGrid(context, state.categories),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildCategoryGrid(
    BuildContext context,
    List<CategoryEntity> categories,
  ) {
    final categoryIcons = <String, String>{
      'peristiwa': 'assets/icons/category/peristiwa.png',
      'politik': 'assets/icons/category/politik.png',
      'hukum': 'assets/icons/category/hukum.png',
      'ekbis': 'assets/icons/category/ekbis.png',
      'olahraga': 'assets/icons/category/olahraga.png',
      'pendidikan': 'assets/icons/category/pendidikan.png',
      'kesehatan': 'assets/icons/category/kesehatan.png',
      'nasional': 'assets/icons/category/nasional.png',
      'gaya-hidup': 'assets/icons/category/gaya-hidup.png',
      'komunitas': 'assets/icons/category/komunitas.png',
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final icon = categoryIcons[category.seo];

        return icon != null
            ? GestureDetector(
                onTap: () => _navigateToNews(
                  context,
                  seo: category.seo,
                  title: category.title,
                  isBiro: false,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(icon, width: 48, height: 48),
                    const SizedBox(height: 6),
                    Text(
                      category.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : null;
      },
    );
  }

  Widget _buildBiroGrid(BuildContext context, List<BiroEntity> biros) {
    final biroIcons = <String, String>{
      'jember': 'assets/icons/biro/jember.png',
      'kediri': 'assets/icons/biro/kediri.png',
      'banyuwangi': 'assets/icons/biro/banyuwangi.png',
      'pacitan': 'assets/icons/biro/pacitan.png',
      'madiun': 'assets/icons/biro/madiun.png',
      'madura': 'assets/icons/biro/madura.png',
      'malang': 'assets/icons/biro/malang.png',
      'bojonegoro': 'assets/icons/biro/bojonegoro.png',
    };

    final filteredBiros = biros
        .where((b) => biroIcons.containsKey(b.seo))
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
      ),
      itemCount: filteredBiros.length,
      itemBuilder: (context, index) {
        final biro = filteredBiros[index];
        final icon = biroIcons[biro.seo]!;

        return GestureDetector(
          onTap: () => _navigateToNews(
            context,
            seo: biro.seo,
            title: biro.title,
            isBiro: true,
          ),
          child: Column(
            children: [
              Image.asset(icon, width: 48, height: 48),
              const SizedBox(height: 6),
              Text(
                biro.seo.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToNews(
    BuildContext context, {
    required String seo,
    required String title,
    required bool isBiro,
  }) {
    context.pushNamed(
      'category-news',
      extra: {'seo': seo, 'title': title, 'isBiro': isBiro},
    );
  }
}

/// Widget reusable untuk section dropdown (Biro / Kanal)
class _DropdownSection extends StatelessWidget {
  const _DropdownSection({
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
  });

  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header bisa diklik untuk toggle
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // Gunakan TitleCategorySection asli jika ada, atau Text biasa
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0 : -0.5, // panah rotate saat collapse
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),

        // Konten animasi expand/collapse
        AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: child,
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}

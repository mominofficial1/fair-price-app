import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/product_visual_badge.dart';
import '../product/product_detail_screen.dart';
import '../providers/app_state_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AppStateProvider>();
    final isBn = provider.isBangla;
    final loc = AppLocalizations.of(context);

    final filtered = provider.products.where((p) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      return p.productNameBn.toLowerCase().contains(q) ||
          p.productNameEn.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: loc.searchPlaceholder,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
              fontSize: 14,
            ),
          ),
          onChanged: (val) => setState(() => _query = val),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          children: [
            if (_query.isEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    size: 16,
                    color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isBn ? 'জনপ্রিয় অনুসন্ধান' : 'Popular Searches',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['পেঁয়াজ', 'চাল', 'ডিম', 'সয়াবিন তেল', 'আলু', 'মুরগি', 'আম', 'চিনি'].map((term) {
                  return ActionChip(
                    label: Text(term),
                    backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                    onPressed: () {
                      _searchController.text = term;
                      setState(() => _query = term);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            if (filtered.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    isBn ? 'কোনো পণ্য পাওয়া যায়নি' : 'No products found',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                ),
              )
            else
              ...filtered.map((p) {
                return Card(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: ListTile(
                    leading: ProductVisualBadge(
                      productId: p.productId,
                      category: p.category,
                      size: 40,
                    ),
                    title: Text(
                      isBn ? p.productNameBn : p.productNameEn,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                      ),
                    ),
                    subtitle: Text(
                      '${loc.fairPrice}: ৳${p.fairPrice.toInt()} | ${loc.marketAvg}: ৳${p.marketAvg.toInt()}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                      ),
                    ),
                    trailing: Text(
                      '৳${p.fairPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.fairGreen,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                      );
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

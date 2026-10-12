import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/product_visual_badge.dart';
import '../../core/widgets/sliding_switch_toggle.dart';
import '../../domain/entities/market_price.dart';
import '../budget/budget_calculator_screen.dart';
import '../community/community_screen.dart';
import '../compare/compare_screen.dart';
import '../location/location_selector_screen.dart';
import '../product/product_detail_screen.dart';
import '../profile/profile_screen.dart';
import '../providers/app_state_provider.dart';
import '../search/search_screen.dart';
import '../settings/data_sources_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppStateProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AppStateProvider>();
    final loc = AppLocalizations.of(context);
    final isBn = provider.isBangla;

    final List<Widget> pages = [
      _buildHomeContent(context, provider, isDark, loc),
      const CompareScreen(),
      const BudgetCalculatorScreen(),
      const CommunityScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(child: pages[_currentTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) => setState(() => _currentTabIndex = idx),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_rounded),
            label: loc.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.balance_outlined),
            activeIcon: const Icon(Icons.balance_rounded),
            label: loc.navCompare,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome_rounded),
            activeIcon: const Icon(Icons.auto_awesome_rounded),
            label: isBn ? 'বাজেট ও AI' : 'Budget & AI',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.campaign_outlined),
            activeIcon: const Icon(Icons.campaign_rounded),
            label: isBn ? 'পোস্ট ও ফিড' : 'Community',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            activeIcon: const Icon(Icons.person_rounded),
            label: loc.navProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    AppStateProvider provider,
    bool isDark,
    AppLocalizations loc,
  ) {
    final isBn = provider.isBangla;
    final currentMarket = provider.currentMarket;

    return RefreshIndicator(
      onRefresh: () async {
        await provider.syncWithDam();
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        children: [
          // Header: Greeting, Location Picker, DAM Live Sync Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.greeting,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LocationSelectorScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primaryGreen),
                        const SizedBox(width: 4),
                        Text(
                          isBn ? currentMarket.nameBn : currentMarket.nameEn,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  provider.syncWithDam();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isBn ? '🔄 DAM সরকারি বাজারদর আপডেট হয়েছে!' : '🔄 DAM live prices updated!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: provider.isAutoSyncing
                        ? const Color(0xFF10A878).withValues(alpha: 0.3)
                        : (isDark ? AppColors.darkSurfaceRaised : AppColors.damBadgeBg),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.darkPrimaryGreen : AppColors.damBadgeBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: provider.isAutoSyncing ? Colors.amber : AppColors.fairGreen,
                          boxShadow: [
                            BoxShadow(
                              color: (provider.isAutoSyncing ? Colors.amber : AppColors.fairGreen).withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        provider.isAutoSyncing
                            ? (isBn ? 'আপডেট হচ্ছে...' : 'Syncing...')
                            : 'DAM Auto-Live',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkPrimaryGreen : AppColors.damBadgeText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sliding Toggles Control Row (Language & Theme Mode)
          Row(
            children: [
              Expanded(
                child: ModernSlidingSwitch<String>(
                  selectedValue: provider.isBangla ? 'bn' : 'en',
                  height: 34,
                  options: const [
                    SlidingOption(value: 'bn', label: '🇧🇩 বাংলা'),
                    SlidingOption(value: 'en', label: '🇬🇧 English'),
                  ],
                  onChanged: (val) => provider.setLanguage(val),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ModernSlidingSwitch<ThemeMode>(
                  selectedValue: provider.themeMode == ThemeMode.dark
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  height: 34,
                  options: const [
                    SlidingOption(value: ThemeMode.light, label: 'Light', icon: Icons.wb_sunny_rounded),
                    SlidingOption(value: ThemeMode.dark, label: 'Dark', icon: Icons.nightlight_round),
                  ],
                  onChanged: (mode) => provider.setThemeMode(mode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Search Bar Trigger
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    loc.searchPlaceholder,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Price Surge Urgent Card
          InkWell(
            onTap: () {
              final onion = provider.products.firstWhere(
                (p) => p.productId == 'onion',
                orElse: () => provider.products.first,
              );
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProductDetailScreen(product: onion)),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark ? const Color(0xFF381518) : AppColors.overpricedRedBg,
                    isDark ? AppColors.darkSurface : Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.overpricedRed.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Text('🧅', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${loc.marketSurgeTitle}: ${isBn ? 'পেঁয়াজ' : 'Onion'}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${loc.marketSurgeDesc} (${isBn ? currentMarket.nameBn : currentMarket.nameEn})',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.overpricedRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.overpricedRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '+১২.৫%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Category Pills
          _buildCategoryPills(provider, isDark, loc),
          const SizedBox(height: 20),

          // Section Title & Data Source info link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBn ? 'আজকের প্রয়োজনীয় বাজার দর' : "Today's Essential Prices",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceRaised : AppColors.damBadgeBg,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: isDark ? AppColors.darkPrimaryGreen : AppColors.damBadgeBorder,
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          loc.damBadge,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkPrimaryGreen : AppColors.damBadgeText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '• ${provider.lastSyncTimestamp}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DataSourcesScreen()),
                  );
                },
                child: Text(
                  isBn ? 'উৎস তথ্য ⓘ' : 'Sources ⓘ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Price Cards Grid
          if (provider.isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
          else
            _buildPriceCardsGrid(context, provider, isDark, loc),
        ],
      ),
    );
  }

  Widget _buildCategoryPills(
    AppStateProvider provider,
    bool isDark,
    AppLocalizations loc,
  ) {
    final isBn = provider.isBangla;
    final categories = [
      {'id': 'all', 'icon': Icons.grid_view_rounded, 'name': loc.catAll},
      {'id': 'grains', 'icon': Icons.grass_rounded, 'name': loc.catGrains},
      {'id': 'vegetables', 'icon': Icons.eco_rounded, 'name': loc.catVegetables},
      {'id': 'meat_fish', 'icon': Icons.lunch_dining_rounded, 'name': loc.catMeatFish},
      {'id': 'dairy_eggs', 'icon': Icons.egg_rounded, 'name': loc.catDairyEggs},
      {'id': 'oil_spices', 'icon': Icons.local_fire_department_rounded, 'name': loc.catOilSpices},
      {'id': 'lentils', 'icon': Icons.grain_rounded, 'name': loc.catLentils},
      {'id': 'fruits', 'icon': Icons.apple_rounded, 'name': isBn ? 'ফলমূল' : 'Fruits'},
      {'id': 'essentials', 'icon': Icons.kitchen_rounded, 'name': isBn ? 'নিত্যপ্রয়োজনীয়' : 'Essentials'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = provider.selectedCategory == cat['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              avatar: Icon(
                cat['icon'] as IconData,
                size: 16,
                color: isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen),
              ),
              label: Text(cat['name'] as String),
              selected: isSelected,
              selectedColor: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              labelStyle: TextStyle(
                color: isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? AppColors.darkTextPrimary : AppColors.darkText),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen)
                      : (isDark ? AppColors.darkBorder : AppColors.border),
                ),
              ),
              onSelected: (_) => provider.selectCategory(cat['id'] as String),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceCardsGrid(
    BuildContext context,
    AppStateProvider provider,
    bool isDark,
    AppLocalizations loc,
  ) {
    final isBn = provider.isBangla;
    final items = provider.products;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
              ),
              const SizedBox(height: 12),
              Text(
                isBn ? 'এই ক্যাটাগরিতে কোনো পণ্য পাওয়া যায়নি' : 'No commodities found in this category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.69,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final p = items[index];
        final isFav = provider.favorites.contains(p.productId);

        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Product Visual Badge + Favorite Heart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProductVisualBadge(
                      productId: p.productId,
                      category: p.category,
                      size: 44,
                    ),
                    InkWell(
                      onTap: () => provider.toggleFavorite(p.productId),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.darkSurfaceRaised : AppColors.softMint,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 16,
                          color: isFav ? AppColors.overpricedRed : (isDark ? AppColors.darkTextSecondary : AppColors.mutedText),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Name & Unit
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? p.productNameBn : p.productNameEn,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${isBn ? "প্রতি" : "per"} ${isBn ? p.unitBn : p.unitEn}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),

                // Fair Price vs Market Price Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceRaised : const Color(0xFFF1F8F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryGreen.withValues(alpha: 0.15),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.fairPrice,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                            ),
                          ),
                          Text(
                            '৳${p.fairPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.marketAvg,
                            style: TextStyle(
                              fontSize: 9,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                            ),
                          ),
                          Text(
                            '৳${p.marketAvg.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bottom Row: Status Pill + Quick Add to Basket
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusPill(p.status, loc, isDark),
                    InkWell(
                      onTap: () {
                        final currentQty = provider.budgetQuantities[p.productId] ?? 0.0;
                        provider.updateBudgetQuantity(p.productId, currentQty + 1.0);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${isBn ? p.productNameBn : p.productNameEn} ${isBn ? "বাজেট ব্যাগে যোগ হয়েছে" : "added to budget bag"}'),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.add_shopping_cart_rounded, size: 12, color: Colors.white),
                            const SizedBox(width: 3),
                            Text(
                              isBn ? 'যোগ' : 'Add',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusPill(PriceStatus status, AppLocalizations loc, bool isDark) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case PriceStatus.fair:
        bg = isDark ? const Color(0xFF113322) : AppColors.fairGreenBg;
        fg = AppColors.fairGreen;
        label = loc.statusFair;
        break;
      case PriceStatus.warning:
        bg = isDark ? const Color(0xFF382E11) : AppColors.warningYellowBg;
        fg = AppColors.warningYellow;
        label = loc.statusWarning;
        break;
      case PriceStatus.overpriced:
        bg = isDark ? const Color(0xFF3E1618) : AppColors.overpricedRedBg;
        fg = AppColors.overpricedRed;
        label = loc.statusOverpriced;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

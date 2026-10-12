import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/app_state_provider.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AppStateProvider>();
    final isBn = provider.isBangla;
    final loc = AppLocalizations.of(context);

    final compareList = [
      {'nameBn': 'চাল (মিনিকেট)', 'nameEn': 'Miniket Rice', 'm1': 70, 'm2': 74, 'm3': 68},
      {'nameBn': 'পেঁয়াজ (দেশি)', 'nameEn': 'Local Onion', 'm1': 78, 'm2': 84, 'm3': 76},
      {'nameBn': 'ডিম (ফার্ম ডজন)', 'nameEn': 'Eggs (Dozen)', 'm1': 140, 'm2': 145, 'm3': 138},
      {'nameBn': 'আলু (লাল ডায়মন্ড)', 'nameEn': 'Red Potato', 'm1': 52, 'm2': 56, 'm3': 50},
      {'nameBn': 'সয়াবিন তেল (লিটার)', 'nameEn': 'Soybean Oil (1L)', 'm1': 180, 'm2': 185, 'm3': 178},
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          loc.compareTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          children: [
            Text(
              isBn
                  ? 'বাংলাদেশব্যাপী যে কোনো বাজারের সাথে মূল্য তুলনা করুন'
                  : 'Compare daily commodity prices across major bazars',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),

            // Savings Banner Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.fairGreen, AppColors.deepGreen],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('💰', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBn ? 'আনুমানিক ৳২৪৫ সাশ্রয়!' : 'Save approx ৳245!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          loc.compareSavings,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Comparison Table Container
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceRaised : AppColors.softMint,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            isBn ? 'পণ্য' : 'Item',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            isBn ? 'সাহেব বাজার' : 'Shaheb B.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            isBn ? 'কারওয়ান' : 'Karwan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            isBn ? 'নওদাপাড়া' : 'Naodapara',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Rows
                  ...compareList.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? AppColors.darkBorderLight : AppColors.borderLight,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              isBn ? item['nameBn'] as String : item['nameEn'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF113322) : AppColors.fairGreenBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '৳${item['m1']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.fairGreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '৳${item['m2']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '৳${item['m3']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isBn ? '🧺 আপনার প্রিয় বাজার তালিকা লোড হয়েছে!' : '🧺 Saved basket loaded!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.shopping_basket_outlined, size: 18),
              label: Text(isBn ? 'সেভ করা বাস্কেট দিয়ে তুলনা করুন' : 'Compare with Saved Basket'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

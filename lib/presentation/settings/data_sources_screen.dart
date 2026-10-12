import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/app_state_provider.dart';

class DataSourcesScreen extends StatelessWidget {
  const DataSourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBn = context.watch<AppStateProvider>().isBangla;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          loc.dataSourcesTitle,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          children: [
            Text(
              loc.dataSourcesSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),

            // DAM Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkPrimaryGreen : AppColors.damBadgeBorder,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceRaised : AppColors.damBadgeBg,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          isBn ? '🟢 ১. কৃষি বিপণন অধিদপ্তর (DAM)' : '🟢 1. Dept. of Agricultural Marketing (DAM)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkPrimaryGreen : AppColors.damBadgeText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isBn
                        ? 'গণপ্রজাতন্ত্রী বাংলাদেশ সরকারের কৃষি মন্ত্রণালয়ের অধীন কৃষি বিপণন অধিদপ্তর (DAM) দৈনিক বাজারদর পর্যবেক্ষণ পোর্টাল (market.dam.gov.bd) থেকে প্রতিদিন সকাল ৮:০০ টায় পাইকারি ও খুচরা ন্যায্যমূল্য সংগ্রহ ও সমন্বয় করা হয়।'
                        : 'Official daily wholesale and retail fair prices are synchronized every morning at 8:00 AM from the Bangladesh Ministry of Agriculture Department of Agricultural Marketing (DAM) portal (market.dam.gov.bd).',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Community Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? const Color(0xFF244975) : AppColors.communityBadgeBorder,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF13273D) : AppColors.communityBadgeBg,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          isBn ? '👥 ২. কমিউনিটি ভেরিফাইড রিপোর্ট' : '👥 2. Community Verified Reports',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF6BA8FF) : AppColors.communityBadgeText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isBn
                        ? 'সাধারণ নাগরিক ও ক্রেতাদের প্রেরিত রসিদের ছবি এবং জিপিএস অবস্থান যাচাইয়ের মাধ্যমে স্থানীয় দোকানের তাৎক্ষণিক বিক্রয়মূল্য ট্রাস্ট স্কোর অ্যালগরিদম দ্বারা সমন্বয় করা হয়।'
                        : 'Crowdsourced prices submitted by citizens are validated through receipt photos, geolocation tags, and community consensus algorithms.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

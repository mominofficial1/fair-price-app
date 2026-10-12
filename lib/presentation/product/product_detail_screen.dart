import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/price_trend_chart_painter.dart';
import '../../core/widgets/product_visual_badge.dart';
import '../../domain/entities/market_price.dart';
import '../alerts/alerts_screen.dart';
import '../community/community_screen.dart';
import '../overcharge/overcharge_report_screen.dart';
import '../providers/app_state_provider.dart';
import '../reports/report_price_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final MarketPrice product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _is30Days = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AppStateProvider>();
    final isBn = provider.isBangla;
    final loc = AppLocalizations.of(context);
    final p = widget.product;
    final isFav = provider.favorites.contains(p.productId);

    final chartData = _is30Days ? p.history30d : p.history7d;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          isBn ? p.productNameBn : p.productNameEn,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? AppColors.overpricedRed : null,
            ),
            onPressed: () => provider.toggleFavorite(p.productId),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          children: [
            // Official DAM Hero Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProductVisualBadge(
                        productId: p.productId,
                        category: p.category,
                        size: 54,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurfaceRaised : AppColors.damBadgeBg,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: isDark ? AppColors.darkPrimaryGreen : AppColors.damBadgeBorder,
                                ),
                              ),
                              child: Text(
                                loc.damBadge,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkPrimaryGreen : AppColors.damBadgeText,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isBn ? p.productNameBn : p.productNameEn,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                              ),
                            ),
                            Text(
                              '📍 ${isBn ? p.marketNameBn : p.marketNameEn}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Big Price Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${loc.fairPrice} (রেঞ্জ: ৳${p.minimumPrice.toInt()}–${p.maximumPrice.toInt()})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              text: '৳${p.fairPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                              ),
                              children: [
                                TextSpan(
                                  text: ' / ${isBn ? p.unitBn : p.unitEn}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            loc.marketAvg,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                '৳${p.marketAvg.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(+${p.differencePercent}%)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.overpricedRed,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Wholesale Price Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceRaised : AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isBn ? '📦 পাইকারি দর (Wholesale DAM):' : '📦 Wholesale DAM Price:',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                          ),
                        ),
                        Text(
                          '৳${p.wholesalePrice.toStringAsFixed(0)} / ${isBn ? p.unitBn : p.unitEn}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Community Crowdsourced Separation Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF244975) : AppColors.communityBadgeBorder,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF13273D) : AppColors.communityBadgeBg,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          loc.communityBadge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF6BA8FF) : AppColors.communityBadgeText,
                          ),
                        ),
                      ),
                      Text(
                        isBn ? '৮৮% যাচাইকৃত' : '88% Verified',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E60D5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${isBn ? "সর্বশেষ ক্রেতার রিপোর্ট:" : "Latest Buyer Report:"} ৳${p.marketAvg.toStringAsFixed(0)} / ${isBn ? p.unitBn : p.unitEn}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn ? 'ভাই ভাই স্টোর • ৩০ মিনিট আগে' : 'Bhai Bhai Store • 30 mins ago',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CommunityScreen()),
                          );
                        },
                        child: Text(
                          isBn ? 'সকল রিপোর্ট →' : 'All Reports →',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Price Trend Analysis Chart Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn ? '📈 মূল্য ট্রেন্ড অ্যানালাইসিস' : '📈 Price Trend Analysis',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                        ),
                      ),
                      Row(
                        children: [
                          ChoiceChip(
                            label: Text(isBn ? '৭ দিন' : '7 Days'),
                            selected: !_is30Days,
                            selectedColor: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                            backgroundColor: isDark ? AppColors.darkSurfaceRaised : AppColors.softMint,
                            labelStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: !_is30Days
                                  ? (isDark ? Colors.black : Colors.white)
                                  : (isDark ? AppColors.darkTextPrimary : AppColors.darkText),
                            ),
                            onSelected: (_) => setState(() => _is30Days = false),
                          ),
                          const SizedBox(width: 6),
                          ChoiceChip(
                            label: Text(isBn ? '৩০ দিন' : '30 Days'),
                            selected: _is30Days,
                            selectedColor: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                            backgroundColor: isDark ? AppColors.darkSurfaceRaised : AppColors.softMint,
                            labelStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _is30Days
                                  ? (isDark ? Colors.black : Colors.white)
                                  : (isDark ? AppColors.darkTextPrimary : AppColors.darkText),
                            ),
                            onSelected: (_) => setState(() => _is30Days = true),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: PriceTrendChartPainter(
                        dataPoints: chartData,
                        fairPrice: p.fairPrice,
                        isDark: isDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBn ? 'ন্যয্যমূল্য লাইন: ৳${p.fairPrice.toInt()}' : 'Fair baseline: ৳${p.fairPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fairGreen,
                        ),
                      ),
                      Text(
                        isBn ? 'লাল ডট = সর্বোচ্চ বৃদ্ধি' : 'Red dot = Price spike',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.overpricedRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReportPriceScreen()),
                );
              },
              icon: const Icon(Icons.rate_review_outlined, size: 18),
              label: Text(loc.btnReportPrice),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AlertsScreen()),
                );
              },
              icon: const Icon(Icons.notifications_active_outlined, size: 18),
              label: Text(loc.btnSetAlert),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => OverchargeReportScreen(product: p)),
                );
              },
              icon: const Icon(Icons.warning_amber_rounded, size: 18),
              label: Text(loc.btnOvercharge),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF3E1618) : AppColors.overpricedRedBg,
                foregroundColor: AppColors.overpricedRed,
                elevation: 0,
                side: BorderSide(
                  color: AppColors.overpricedRed.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

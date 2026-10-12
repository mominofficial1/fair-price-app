import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/market_price.dart';
import '../providers/app_state_provider.dart';

class OverchargeReportScreen extends StatefulWidget {
  final MarketPrice? product;

  const OverchargeReportScreen({super.key, this.product});

  @override
  State<OverchargeReportScreen> createState() => _OverchargeReportScreenState();
}

class _OverchargeReportScreenState extends State<OverchargeReportScreen> {
  final TextEditingController _shopController = TextEditingController(text: 'মেসার্স সততা এন্টারপ্রাইজ');
  final TextEditingController _chargedPriceController = TextEditingController(text: '155');
  bool _forwardToDncrp = true;

  @override
  void dispose() {
    _shopController.dispose();
    _chargedPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AppStateProvider>();
    final isBn = provider.isBangla;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          isBn ? 'অতিরিক্ত দামের অভিযোগ (DNCRP)' : 'Overcharge Complaint (DNCRP)',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          children: [
            Text(
              isBn
                  ? 'জাতীয় ভোক্তা-অধিকার সংরক্ষণ অধিদপ্তরে (DNCRP) সরাসরি রিপোর্ট পাঠান'
                  : 'Submit overcharging complaint directly to Consumer Rights Directorate',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),

            // Active Case Tracker Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(18),
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
                      const Text(
                        'কেস নং: DNCRP-2026-981',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.overpricedRed,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF382E11) : AppColors.warningYellowBg,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text(
                          'Under Review',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warningYellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${isBn ? "দোকান:" : "Shop:"} মেসার্স সততা এন্টারপ্রাইজ • সাদা চিনি',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  Text(
                    '${isBn ? "ন্যায্য দর:" : "Fair:"} ৳১৩০ | ${isBn ? "আদায়কৃত:" : "Charged:"} ৳১৫৫',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 4-step visual tracker
                  Row(
                    children: [
                      _buildStepDot(1, 'জমা', true, isDark),
                      _buildStepLine(true),
                      _buildStepDot(2, 'তদন্ত', true, isDark),
                      _buildStepLine(false),
                      _buildStepDot(3, 'DNCRP', false, isDark),
                      _buildStepLine(false),
                      _buildStepDot(4, 'নিষ্পত্তি', false, isDark),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Complaint Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBn ? 'দোকানের নাম ও অবস্থান' : 'Shop Name & Location',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _shopController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurfaceRaised : AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    isBn ? 'অতিরিক্ত আদায়কৃত দর (টাকা)' : 'Overcharged Price (BDT)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _chargedPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: '৳ ',
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurfaceRaised : AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  CheckboxListTile(
                    value: _forwardToDncrp,
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primaryGreen,
                    title: Text(
                      isBn
                          ? 'ভোক্তা অধিকার সংরক্ষণ অধিদপ্তরে (DNCRP) পাঠাতে চাই'
                          : 'Forward complaint to Consumer Rights Directorate (DNCRP)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                      ),
                    ),
                    onChanged: (val) => setState(() => _forwardToDncrp = val ?? true),
                  ),
                  const SizedBox(height: 14),

                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isBn ? '✓ অভিযোগ দাখিল সম্পন্ন হয়েছে (কেস #DNCRP-2026-982)' : '✓ Overcharge complaint filed (#DNCRP-2026-982)'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.overpricedRed,
                    ),
                    child: Text(isBn ? 'অভিযোগ জমা দিন' : 'Submit Complaint'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepDot(int step, String label, bool isDone, bool isDark) {
    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? AppColors.fairGreen : (isDark ? AppColors.darkSurfaceRaised : AppColors.border),
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isDone ? Colors.white : AppColors.secondaryText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: isDone ? AppColors.fairGreen : AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isDone) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 14),
        color: isDone ? AppColors.fairGreen : AppColors.border,
      ),
    );
  }
}

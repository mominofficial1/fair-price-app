import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../community/community_screen.dart';
import '../providers/app_state_provider.dart';

class ReportPriceScreen extends StatefulWidget {
  const ReportPriceScreen({super.key});

  @override
  State<ReportPriceScreen> createState() => _ReportPriceScreenState();
}

class _ReportPriceScreenState extends State<ReportPriceScreen> {
  final TextEditingController _priceController = TextEditingController(text: '80');
  final TextEditingController _shopController = TextEditingController(text: 'ভাই ভাই স্টোর');
  String _selectedProduct = 'পেঁয়াজ (দেশি)';
  bool _photoAttached = false;

  @override
  void dispose() {
    _priceController.dispose();
    _shopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AppStateProvider>();
    final isBn = provider.isBangla;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          loc.navReport,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          children: [
            Text(
              isBn
                  ? 'আপনার দেখা সঠিক বাজার দর জানান এবং ট্রাস্ট স্কোর অর্জন করুন'
                  : 'Report fair market rates and earn community trust points',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),

            // Camera / Receipt Upload Card
            InkWell(
              onTap: () {
                setState(() => _photoAttached = !_photoAttached);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isBn ? '📸 রসিদের ছবি সফলভাবে যুক্ত হয়েছে!' : '📸 Receipt photo attached!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _photoAttached
                        ? AppColors.fairGreen
                        : (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _photoAttached
                            ? AppColors.fairGreenBg
                            : (isDark ? AppColors.darkSurfaceRaised : AppColors.softMint),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _photoAttached ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                        color: _photoAttached
                            ? AppColors.fairGreen
                            : (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _photoAttached
                          ? (isBn ? '✓ রসিদের ছবি সংরক্ষিত (রসিদ #7819)' : '✓ Receipt Attached (#7819)')
                          : (isBn ? '📷 দাম বা রসিদের ছবি তুলুন' : '📷 Take Photo of Price Tag / Receipt'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBn ? 'ছবি প্রমাণে রিপোর্ট বেশি দ্রুত ভেরিফাই হয়' : 'Photo proof increases verification speed',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Details Form
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
                    isBn ? 'পণ্যের নাম' : 'Product',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceRaised : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedProduct,
                        isExpanded: true,
                        dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                        items: ['পেঁয়াজ (দেশি)', 'চাল (মিনিকেট)', 'সয়াবিন তেল', 'ডিম (ডজন)'].map((name) {
                          return DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedProduct = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    isBn ? 'আপনার আদায়কৃত দর (টাকা)' : 'Price Paid (BDT)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                    decoration: InputDecoration(
                      prefixText: '৳ ',
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurfaceRaised : AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    isBn ? 'দোকানের নাম' : 'Shop Name',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _shopController,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurfaceRaised : AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isBn ? '✓ রিপোর্ট জমা হয়েছে! +১০ ট্রাস্ট পয়েন্ট' : '✓ Price submitted! +10 Trust Points'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CommunityScreen()),
                      );
                    },
                    child: Text(loc.btnSubmitPrice),
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

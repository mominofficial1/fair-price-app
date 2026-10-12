import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/app_state_provider.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<Map<String, dynamic>> _alerts = [
    {
      'id': 'onion',
      'nameBn': 'পেঁয়াজ (দেশি)',
      'nameEn': 'Local Onion',
      'price': 82,
      'threshold': 5,
      'active': true,
    },
    {
      'id': 'oil',
      'nameBn': 'সয়াবিন তেল (লিটার)',
      'nameEn': 'Soybean Oil (1L)',
      'price': 185,
      'threshold': 3,
      'active': true,
    },
    {
      'id': 'sugar',
      'nameBn': 'চিনি (খোলা সাদা)',
      'nameEn': 'Refined Sugar',
      'price': 148,
      'threshold': 10,
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBn = context.watch<AppStateProvider>().isBangla;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          loc.navAlerts,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isBn ? 'নতুন সতর্কতার ফর্ম সক্রিয়' : 'New alert form opened'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          children: [
            Text(
              isBn
                  ? 'আপনার নিত্যপ্রয়োজনীয় পণ্যে মূল্য বৃদ্ধির নোটিফিকেশন ট্র্যাক করুন'
                  : 'Track instant alerts when essential product prices shift',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),

            ..._alerts.map((a) {
              final isActive = a['active'] as bool;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceRaised : AppColors.softMint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: isActive
                            ? (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen)
                            : (isDark ? AppColors.darkTextMuted : AppColors.mutedText),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBn ? a['nameBn'] : a['nameEn'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${isBn ? "বর্তমান দর:" : "Current Price:"} ৳${a['price']} • +${a['threshold']}% ${isBn ? "বাড়লে সতর্কতা" : "threshold"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isActive,
                      activeThumbColor: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                      onChanged: (val) {
                        setState(() {
                          a['active'] = val;
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/sliding_switch_toggle.dart';
import '../budget/budget_calculator_screen.dart';
import '../location/location_selector_screen.dart';
import '../news/news_screen.dart';
import '../providers/app_state_provider.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'মমিন আলী';
  double _monthlyBudget = 15000.0;

  void _showEditProfileDialog(BuildContext context, bool isBn, bool isDark) {
    final nameController = TextEditingController(text: _userName);
    final budgetController = TextEditingController(text: _monthlyBudget.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isBn ? 'প্রোফাইল সম্পাদনা' : 'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: isBn ? 'আপনার নাম' : 'Your Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: isBn ? 'মাসিক বাজেট (টাকা)' : 'Monthly Budget (BDT)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(isBn ? 'বাতিল' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  _userName = nameController.text.trim();
                  final b = double.tryParse(budgetController.text.trim());
                  if (b != null && b > 0) _monthlyBudget = b;
                });
              }
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isBn ? 'প্রোফাইল সফলভাবে আপডেট হয়েছে' : 'Profile updated successfully')),
              );
            },
            child: Text(isBn ? 'সংরক্ষণ' : 'Save'),
          ),
        ],
      ),
    );
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
          loc.navProfile,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () => _showEditProfileDialog(context, isBn, isDark),
            tooltip: isBn ? 'সম্পাদনা' : 'Edit',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.emerald, AppColors.deepGreen],
                ),
                borderRadius: BorderRadius.circular(20),
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
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _userName.isNotEmpty ? _userName[0] : 'ম',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            isBn ? 'গোল্ড রিপোর্টার • ৯২০ পয়েন্ট' : 'Gold Reporter • 920 pts',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                    onPressed: () => _showEditProfileDialog(context, isBn, isDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Target Budget Highlight Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isBn ? 'নির্ধারিত মাসিক বাজেট' : 'Target Monthly Budget',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '৳${_monthlyBudget.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkSurfaceRaised : AppColors.softMint,
                      foregroundColor: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BudgetCalculatorScreen()),
                      );
                    },
                    icon: const Icon(Icons.calculate_outlined, size: 18),
                    label: Text(isBn ? 'হিসাব করুন' : 'Calculate'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Profile Actions List
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
                  _buildProfileTile(
                    context: context,
                    icon: Icons.account_balance_wallet_outlined,
                    title: isBn ? 'মাসিক বাজার হিসাব (বাজেট)' : 'Grocery Budget Planner',
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BudgetCalculatorScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    context: context,
                    icon: Icons.location_on_outlined,
                    title: isBn ? 'বাজার / এলাকা পরিবর্তন' : 'Switch Market / Area',
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LocationSelectorScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    context: context,
                    icon: Icons.newspaper_outlined,
                    title: isBn ? 'খবর ও সরকারি প্রজ্ঞাপন' : 'News & Govt Notices',
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NewsScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    context: context,
                    icon: Icons.settings_outlined,
                    title: loc.settingsTitle,
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sliding Toggles for Language & Theme Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBn ? 'অ্যাপ সেটিংস ও ডিসপ্লে মোড' : 'App Settings & Display Mode',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isBn ? 'ভাষা নির্বাচন' : 'Language', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 170,
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
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isBn ? 'থিম মোড' : 'Theme Mode', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 170,
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
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
      ),
      onTap: onTap,
    );
  }
}

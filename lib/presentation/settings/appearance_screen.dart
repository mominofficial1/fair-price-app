import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/app_state_provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

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
          loc.appearanceTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
              loc.appearanceDesc,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 20),

            _buildThemeOptionCard(
              title: loc.themeLight,
              subtitle: isBn ? 'সাদা ও উজ্জ্বল পটভূমি' : 'Clean & bright interface',
              previewColor1: const Color(0xFFF7FAF8),
              previewColor2: const Color(0xFFFFFFFF),
              isSelected: provider.themeMode == ThemeMode.light,
              isDark: isDark,
              onTap: () => provider.setThemeMode(ThemeMode.light),
            ),
            const SizedBox(height: 12),

            _buildThemeOptionCard(
              title: loc.themeDark,
              subtitle: isBn ? 'ডার্ক মোড (#0E1915) চোখের জন্য আরামদায়ক' : 'Dark OLED-friendly theme (#0E1915)',
              previewColor1: const Color(0xFF0E1915),
              previewColor2: const Color(0xFF14231D),
              isSelected: provider.themeMode == ThemeMode.dark,
              isDark: isDark,
              onTap: () => provider.setThemeMode(ThemeMode.dark),
            ),
            const SizedBox(height: 12),

            _buildThemeOptionCard(
              title: loc.themeSystem,
              subtitle: isBn ? 'ডিভাইসের সিস্টেম অনুযায়ী স্বয়ংক্রিয়' : 'Matches device system settings',
              previewColor1: const Color(0xFFF7FAF8),
              previewColor2: const Color(0xFF0E1915),
              isSelected: provider.themeMode == ThemeMode.system,
              isDark: isDark,
              onTap: () => provider.setThemeMode(ThemeMode.system),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOptionCard({
    required String title,
    required String subtitle,
    required Color previewColor1,
    required Color previewColor2,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final borderColor = isSelected
        ? (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen)
        : (isDark ? AppColors.darkBorder : AppColors.border);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(child: Container(color: previewColor1)),
                  Expanded(child: Container(color: previewColor2)),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen)
                      : (isDark ? AppColors.darkTextMuted : AppColors.mutedText),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14, color: isDark ? Colors.black : Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

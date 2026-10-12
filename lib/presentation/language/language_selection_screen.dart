import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../onboarding/onboarding_screen.dart';
import '../providers/app_state_provider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLang = 'bn';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.read<AppStateProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Center(
                child: Text('🌐', style: TextStyle(fontSize: 48)),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'আপনার ভাষা নির্বাচন করুন',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Select your preferred language',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Bangla Option Card
              _buildLanguageCard(
                code: 'bn',
                title: 'বাংলা',
                subtitle: 'বাংলায় ব্যবহার করুন',
                flag: '🇧🇩',
                isSelected: _selectedLang == 'bn',
                isDark: isDark,
                onTap: () {
                  setState(() => _selectedLang = 'bn');
                  provider.setLanguage('bn');
                },
              ),
              const SizedBox(height: 16),

              // English Option Card
              _buildLanguageCard(
                code: 'en',
                title: 'English',
                subtitle: 'Use Fair Price in English',
                flag: '🌐',
                isSelected: _selectedLang == 'en',
                isDark: isDark,
                onTap: () {
                  setState(() => _selectedLang = 'en');
                  provider.setLanguage('en');
                },
              ),

              const Spacer(),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  provider.setLanguage(_selectedLang);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_selectedLang == 'bn' ? 'চালিয়ে যান' : 'Continue'),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String code,
    required String title,
    required String subtitle,
    required String flag,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen).withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
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
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: isDark ? Colors.black : Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

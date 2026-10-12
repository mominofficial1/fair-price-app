import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/storage/local_storage.dart';
import '../location/location_permission_screen.dart';
import '../providers/app_state_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'icon': '⚖️',
      'titleBn': 'আজকের ন্যায্য দাম জানুন',
      'titleEn': "Know Today's Fair Price",
      'descBn':
          'সরকারি কৃষি বিপণন অধিদপ্তর (DAM) এর ন্যায্যমূল্যের সাথে স্থানীয় বাজার দর যাচাই করুন।',
      'descEn':
          'Verify local retail prices against official Department of Agricultural Marketing (DAM) fair rates.',
    },
    {
      'icon': '🗺️',
      'titleBn': 'কোথায় কম দামে পাবেন?',
      'titleEn': 'Find Where Prices Are Lower',
      'descBn':
          'ঢাকা, চট্টগ্রাম, রাজশাহীসহ সারা দেশের যে কোনো বাজারের পণ্যদর এক সাথে তুলনা করুন।',
      'descEn':
          'Compare product prices across bazars nationwide to find the cheapest spots and save money.',
    },
    {
      'icon': '📸',
      'titleBn': 'আপনার দেখা দাম জানান',
      'titleEn': 'Report the Price You See',
      'descBn':
          'রসিদের ছবি দিয়ে বাজার দর জানান এবং পয়েন্ট অর্জন করে কমিউনিটি ট্রাস্ট স্কোর বৃদ্ধি করুন।',
      'descEn':
          'Snap a receipt photo, share daily market rates, and earn trust badges in your community.',
    },
    {
      'icon': '🔔',
      'titleBn': 'দামের পরিবর্তন আগে জানুন',
      'titleEn': 'Stay Ahead of Price Changes',
      'descBn':
          'আপনার প্রয়োজনীয় পণ্যের মূল্য বৃদ্ধি বা সরবরাহ হ্রাস পেলে সাথে সাথে সতর্কতা নোটিফিকেশন পান।',
      'descEn':
          'Receive instant smart notifications whenever your tracked staple prices increase or surge.',
    },
  ];

  void _finishOnboarding() {
    LocalStorage.setOnboardingCompleted(true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LocationPermissionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBn = context.watch<AppStateProvider>().isBangla;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    loc.btnSkip,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppColors.darkSurfaceRaised : AppColors.mint,
                          ),
                          child: Center(
                            child: Text(
                              slide['icon']!,
                              style: const TextStyle(fontSize: 54),
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          isBn ? slide['titleBn']! : slide['titleEn']!,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          isBn ? slide['descBn']! : slide['descEn']!,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final isSelected = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isSelected ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isSelected
                        ? (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen)
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Bottom Next / Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == _slides.length - 1) {
                    _finishOnboarding();
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentPage == _slides.length - 1
                          ? loc.btnGetStarted
                          : loc.btnNext,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _currentPage == _slides.length - 1
                          ? Icons.check_circle_outline_rounded
                          : Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

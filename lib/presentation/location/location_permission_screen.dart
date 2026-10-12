import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../auth/login_screen.dart';
import '../providers/app_state_provider.dart';
import 'location_selector_screen.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBn = context.watch<AppStateProvider>().isBangla;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.darkSurfaceRaised : AppColors.mint,
                ),
                child: const Center(
                  child: Text('📍', style: TextStyle(fontSize: 42)),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                isBn
                    ? 'আপনার এলাকার বাজার দর দেখাতে লোকেশন প্রয়োজন'
                    : 'We need your location to show nearby market prices',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isBn
                    ? 'নিকটবর্তী বাজারের সঠিক দর প্রদর্শন এবং আপনার এলাকার রিপোর্ট ট্যাগ করতে লোকেশন অনুমতি প্রয়োজন।'
                    : 'Location access allows us to display accurate daily prices for markets in your upazila and division.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              // Allow Location Button
              ElevatedButton(
                onPressed: () {
                  context.read<AppStateProvider>().selectMarket('rajshahi_shaheb_bazar');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.my_location_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(loc.btnAllowLocation),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Manual Area Button
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LocationSelectorScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.map_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(loc.btnManualArea),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Later Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: Text(
                  loc.btnLater,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

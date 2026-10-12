import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../home/home_screen.dart';
import '../providers/app_state_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController =
      TextEditingController(text: '01712345678');
  bool _isOtpSent = false;
  int _timerSeconds = 45;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timerSeconds = 45;
      _isOtpSent = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  void _proceedToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceRaised : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  loc.btnLogin,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  isBn
                      ? 'বাজার দর জানাতে এবং ট্রাস্ট স্কোর বাড়াতে লগইন করুন'
                      : 'Login to report prices and earn community trust badges',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 36),

              if (!_isOtpSent) ...[
                Text(
                  isBn ? 'মোবাইল নম্বর দিন' : 'Enter Mobile Number',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_iphone_rounded),
                    hintText: '01XXXXXXXXX',
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurface : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text(loc.btnSendOtp),
                ),
              ] else ...[
                Text(
                  isBn ? '৬-সংখ্যার কোডটি লিখুন' : 'Enter 6-digit OTP Code',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isBn
                      ? 'কোড পাঠানো হয়েছে: ${_phoneController.text} (ডেমো কোড: 729418)'
                      : 'Code sent to: ${_phoneController.text} (Demo: 729418)',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['7', '2', '9', '4', '1', '8'].map((digit) {
                    return Container(
                      width: 44,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          digit,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _timerSeconds > 0
                          ? '${isBn ? 'পুনরায় পাঠান:' : 'Resend code in:'} ${_timerSeconds}s'
                          : (isBn ? 'কোড পাননি?' : 'Didn’t get code?'),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                      ),
                    ),
                    if (_timerSeconds == 0)
                      TextButton(
                        onPressed: _startTimer,
                        child: Text(isBn ? 'পুনরায় কোড পাঠান' : 'Resend OTP'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _proceedToHome,
                  child: Text(isBn ? 'যাচাই করুন ও প্রবেশ করুন' : 'Verify & Continue'),
                ),
              ],

              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _proceedToHome,
                  child: Text(
                    loc.btnGuest,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

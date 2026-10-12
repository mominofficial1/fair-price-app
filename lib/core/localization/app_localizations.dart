import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('bn'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isBangla => locale.languageCode == 'bn';

  String get appTitle => isBangla ? 'ন্যায্য দাম' : 'Fair Price';
  String get appSubTitle => isBangla ? 'Fair Price' : 'ন্যায্য দাম';
  String get tagline =>
      isBangla ? 'আজকের বাজার দর, প্রতিদিন' : "Today's market price, every day";
  String get greeting => isBangla ? 'শুভ সন্ধ্যা 👋' : 'Good Evening 👋';
  String get searchPlaceholder => isBangla
      ? 'পণ্য খুঁজুন (যেমন: পেঁয়াজ, চাল, তেল)...'
      : 'Search products (e.g. Onion, Rice, Oil)...';
  String get marketSurgeTitle =>
      isBangla ? 'আজকের বাজারের বড় পরিবর্তন' : "Today's Major Price Shift";
  String get marketSurgeDesc =>
      isBangla ? 'গতকালের তুলনায় দাম বেড়েছে' : 'Price increased compared to yesterday';
  String get fairPrice => isBangla ? 'ন্যায্য দাম' : 'Fair Price';
  String get marketAvg => isBangla ? 'বাজার গড়' : 'Market Avg';
  String get statusFair => isBangla ? 'ন্যায্য দাম' : 'Fair Price';
  String get statusWarning => isBangla ? 'কিছুটা বেশি' : 'Slightly High';
  String get statusOverpriced => isBangla ? 'অতিরিক্ত দাম' : 'Overpriced';
  String get lastUpdated =>
      isBangla ? 'শেষ আপডেট: ২ ঘণ্টা আগে' : 'Last updated: 2 hours ago';
  String get damBadge => isBangla ? '🟢 DAM সরকারি মূল্য' : '🟢 DAM Govt Price';
  String get communityBadge =>
      isBangla ? '👥 কমিউনিটি রিপোর্ট' : '👥 Community Report';

  // Navigation
  String get navHome => isBangla ? 'হোম' : 'Home';
  String get navCompare => isBangla ? 'তুলনা' : 'Compare';
  String get navAlerts => isBangla ? 'সতর্কতা' : 'Alerts';
  String get navReport => isBangla ? 'রিপোর্ট' : 'Report';
  String get navProfile => isBangla ? 'প্রোফাইল' : 'Profile';

  // Categories
  String get catAll => isBangla ? 'সব পণ্য' : 'All Items';
  String get catGrains => isBangla ? 'চাল ও শস্য' : 'Rice & Grains';
  String get catVegetables => isBangla ? 'সবজি' : 'Vegetables';
  String get catMeatFish => isBangla ? 'মাছ ও মাংস' : 'Fish & Meat';
  String get catOilSpices => isBangla ? 'তেল ও মসলা' : 'Oil & Spices';
  String get catFruits => isBangla ? 'ফলমূল' : 'Fruits';
  String get catDairyEggs => isBangla ? 'দুধ ও ডিম' : 'Dairy & Eggs';
  String get catLentils => isBangla ? 'ডাল' : 'Pulses / Dal';

  // Location Selector
  String get locationSelectorTitle =>
      isBangla ? 'আপনার বাজার নির্বাচন করুন' : 'Select Your Market';
  String get locationSelectorSubtitle => isBangla
      ? 'বাংলাদেশজুড়ে আপনার এলাকার সঠিক দৈনিক বাজার দর দেখুন'
      : 'View daily localized fair prices across Bangladesh';
  String get useCurrentGps => isBangla
      ? '📍 বর্তমান অবস্থান ব্যবহার করুন (স্বয়ংক্রিয়)'
      : '📍 Use Current Location (Auto-detect)';
  String get selectDivision =>
      isBangla ? 'বিভাগ নির্বাচন করুন' : 'Select Division';
  String get selectDistrict =>
      isBangla ? 'জেলা নির্বাচন করুন' : 'Select District';
  String get selectUpazila =>
      isBangla ? 'উপজেলা নির্বাচন করুন' : 'Select Upazila';
  String get selectMarket =>
      isBangla ? 'বাজার নির্বাচন করুন' : 'Select Market';
  String get savedLocations =>
      isBangla ? 'সেভ করা বাজারসমূহ' : 'Saved Markets';

  // Settings
  String get settingsTitle => isBangla ? 'সেটিংস' : 'Settings';
  String get appearanceTitle =>
      isBangla ? 'অ্যাপ থিম ও ভিজ্যুয়াল' : 'Appearance & Theme';
  String get appearanceDesc => isBangla
      ? 'আপনার পছন্দের ডিসপ্লে মোড নির্বাচন করুন'
      : 'Choose your preferred display theme';
  String get themeSystem =>
      isBangla ? 'সিস্টেম ডিফল্ট (System Default)' : 'System Default';
  String get themeLight => isBangla ? 'লাইট মোড (Light Mode)' : 'Light Mode';
  String get themeDark => isBangla ? 'ডার্ক মোড (Dark Mode)' : 'Dark Mode';
  String get languageTitle => isBangla ? 'ভাষা (Language)' : 'Language (ভাষা)';
  String get languageDesc => isBangla
      ? 'অ্যাপের সকল লেখা নির্বাচিত ভাষায় প্রদর্শিত হবে'
      : 'Choose your preferred language for the application';
  String get dataSourcesTitle =>
      isBangla ? 'দাম কোথা থেকে এসেছে?' : 'Where Does This Price Come From?';
  String get dataSourcesSubtitle => isBangla
      ? 'তথ্যসূত্র ও ন্যায্য মূল্য নির্ধারণ নীতিমালা'
      : 'Official Data Sources & Trust Methodology';

  // Buttons
  String get btnContinue => isBangla ? 'চালিয়ে যান' : 'Continue';
  String get btnGetStarted => isBangla ? 'শুরু করুন' : 'Get Started';
  String get btnNext => isBangla ? 'পরবর্তী' : 'Next';
  String get btnSkip => isBangla ? 'এড়িয়ে যান' : 'Skip';
  String get btnAllowLocation =>
      isBangla ? 'লোকেশন অনুমতি দিন' : 'Allow Location';
  String get btnManualArea =>
      isBangla ? 'এলাকা নিজে নির্বাচন করুন' : 'Select Area Manually';
  String get btnLater => isBangla ? 'পরে করব' : 'Maybe Later';
  String get btnLogin => isBangla ? 'লগইন করুন' : 'Login';
  String get btnSendOtp => isBangla ? 'OTP পাঠান' : 'Send OTP';
  String get btnGuest =>
      isBangla ? 'Guest হিসেবে চালিয়ে যান' : 'Continue as Guest';
  String get btnSubmitPrice => isBangla ? 'দাম জমা দিন' : 'Submit Price';
  String get btnReportPrice =>
      isBangla ? 'এই দাম রিপোর্ট করুন' : 'Report This Price';
  String get btnSetAlert =>
      isBangla ? 'দামের সতর্কতা সেট করুন' : 'Set Price Alert';
  String get btnOvercharge =>
      isBangla ? 'অতিরিক্ত দামের অভিযোগ করুন' : 'Report Overcharging';

  // Compare & Savings
  String get compareTitle =>
      isBangla ? 'বাজার দর তুলনা করুন' : 'Compare Market Prices';
  String get compareSavings => isBangla
      ? 'এখানে কিনলে আপনি আনুমানিক ৳২৪৫ সাশ্রয় করতে পারেন!'
      : 'You can save approx ৳245 by shopping here!';

  // Budget
  String get budgetTitle =>
      isBangla ? 'মাসিক বাজার হিসাব' : 'Monthly Grocery Budget';
  String get householdSize =>
      isBangla ? 'পরিবারের সদস্য সংখ্যা' : 'Household Members';
  String get estimatedBudget =>
      isBangla ? 'আনুমানিক সরকারি ন্যায্য বাজেট' : 'Estimated Fair Budget';
  String get btnPdfExport =>
      isBangla ? '📄 PDF হিসেবে সংরক্ষণ' : '📄 Export as PDF';

  // Offline Banners
  String get offlineBanner => isBangla
      ? 'আপনি অফলাইনে আছেন — শেষ সংরক্ষিত বাজার দর দেখানো হচ্ছে।'
      : 'You are offline — displaying cached market rates.';
  String get syncedBanner => isBangla
      ? 'সংযোগ পুনঃস্থাপিত — দাম আপডেট হয়েছে ✓'
      : 'Connection Restored — Prices Synchronized ✓';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['bn', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

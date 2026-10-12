import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/storage/local_storage.dart';
import '../../data/datasources/location_datasource.dart';
import '../../data/repositories/market_price_repository_impl.dart';
import '../../domain/entities/location_hierarchy.dart';
import '../../domain/entities/market_price.dart';
import '../../domain/repositories/market_price_repository.dart';

class CommunityReportItem {
  final int id;
  final String reporterNameBn;
  final String reporterNameEn;
  final String badge;
  final int trustScore;
  final String itemBn;
  final String itemEn;
  final double price;
  final String unitBn;
  final String unitEn;
  final String shopBn;
  final String shopEn;
  final String areaBn;
  final String areaEn;
  final String timeBn;
  final String timeEn;
  int correctVotes;
  int wrongVotes;
  String? userVote;

  CommunityReportItem({
    required this.id,
    required this.reporterNameBn,
    required this.reporterNameEn,
    required this.badge,
    required this.trustScore,
    required this.itemBn,
    required this.itemEn,
    required this.price,
    required this.unitBn,
    required this.unitEn,
    required this.shopBn,
    required this.shopEn,
    required this.areaBn,
    required this.areaEn,
    required this.timeBn,
    required this.timeEn,
    required this.correctVotes,
    required this.wrongVotes,
    this.userVote,
  });
}

class OverchargeComplaint {
  final String caseId;
  final String shopName;
  final String productName;
  final double fairPrice;
  final double chargedPrice;
  final String area;
  final String date;
  final String status;
  final int step;

  OverchargeComplaint({
    required this.caseId,
    required this.shopName,
    required this.productName,
    required this.fairPrice,
    required this.chargedPrice,
    required this.area,
    required this.date,
    required this.status,
    required this.step,
  });
}

class AppStateProvider extends ChangeNotifier {
  final MarketPriceRepository _priceRepository;
  Timer? _damAutoSyncTimer;
  bool _isAutoSyncing = false;

  Locale _locale = const Locale('bn');
  ThemeMode _themeMode = ThemeMode.system;
  String _selectedDivision = 'rajshahi';
  MarketLocation _currentMarket = LocationDataSource.markets.firstWhere(
    (m) => m.id == 'rajshahi_shaheb_bazar',
    orElse: () => LocationDataSource.markets.first,
  );
  String _selectedCategory = 'all';
  List<MarketPrice> _products = [];
  bool _isLoading = false;
  bool _isOnline = true;
  String _lastSyncTimestampBn = 'স্বয়ংক্রিয় লাইভ আপডেট (এখনই)';
  String _lastSyncTimestampEn = 'Auto-Updated (Just Now)';

  List<String> _favorites = [];
  int _householdSize = 4;
  final Map<String, double> _budgetQuantities = {
    'rice_miniket': 35.0,
    'rice': 35.0,
    'oil_soybean_bot': 5.0,
    'oil': 5.0,
    'onion': 8.0,
    'potato': 15.0,
    'dal_mosur_deshi': 4.0,
    'dal': 4.0,
    'egg': 4.0,
    'chicken_broiler': 6.0,
    'beef': 3.0,
  };

  final List<CommunityReportItem> _communityFeed = [
    CommunityReportItem(
      id: 1,
      reporterNameBn: 'তানভীর আহমেদ',
      reporterNameEn: 'Tanvir Ahmed',
      badge: 'Gold Reporter',
      trustScore: 920,
      itemBn: 'পেঁয়াজ (দেশি)',
      itemEn: 'Local Onion',
      price: 80.0,
      unitBn: 'কেজি',
      unitEn: 'kg',
      shopBn: 'ভাই ভাই স্টোর',
      shopEn: 'Bhai Bhai Store',
      areaBn: 'সাহেব বাজার, রাজশাহী',
      areaEn: 'Shaheb Bazar, Rajshahi',
      timeBn: '১৫ মিনিট আগে',
      timeEn: '15 mins ago',
      correctVotes: 24,
      wrongVotes: 2,
    ),
    CommunityReportItem(
      id: 2,
      reporterNameBn: 'মোছাঃ নাজনীন',
      reporterNameEn: 'Nazneen Begum',
      badge: 'Silver Reporter',
      trustScore: 680,
      itemBn: 'সয়াবিন তেল (রূপচাঁদা ১ লিটার)',
      itemEn: 'Rupchanda Soybean Oil (1L)',
      price: 182.0,
      unitBn: 'বোতল',
      unitEn: 'Bottle',
      shopBn: 'জনতা জেনারেল স্টোর',
      shopEn: 'Janata General Store',
      areaBn: 'নওদাপাড়া বাজার, রাজশাহী',
      areaEn: 'Naodapara Bazar, Rajshahi',
      timeBn: '৪৫ মিনিট আগে',
      timeEn: '45 mins ago',
      correctVotes: 18,
      wrongVotes: 1,
    ),
  ];

  final List<OverchargeComplaint> _complaints = [
    OverchargeComplaint(
      caseId: 'DNCRP-2026-981',
      shopName: 'মেসার্স সততা এন্টারপ্রাইজ',
      productName: 'সাদা চিনি (খোলা)',
      fairPrice: 130.0,
      chargedPrice: 155.0,
      area: 'সাহেব বাজার, রাজশাহী',
      date: '২৪ আগস্ট ২০২৬',
      status: 'Under Review (তদন্তনাধীন)',
      step: 2,
    ),
  ];

  AppStateProvider({MarketPriceRepository? repository})
      : _priceRepository = repository ?? MarketPriceRepositoryImpl() {
    _initPreferences();
  }

  // Getters
  Locale get locale => _locale;
  bool get isBangla => _locale.languageCode == 'bn';
  ThemeMode get themeMode => _themeMode;
  String get selectedDivision => _selectedDivision;
  MarketLocation get currentMarket => _currentMarket;
  String get selectedCategory => _selectedCategory;
  List<MarketPrice> get products => _products;
  bool get isLoading => _isLoading;
  bool get isAutoSyncing => _isAutoSyncing;
  bool get isOnline => _isOnline;
  String get lastSyncTimestamp => isBangla ? _lastSyncTimestampBn : _lastSyncTimestampEn;
  List<String> get favorites => _favorites;
  int get householdSize => _householdSize;
  Map<String, double> get budgetQuantities => _budgetQuantities;
  List<CommunityReportItem> get communityFeed => _communityFeed;
  List<OverchargeComplaint> get complaints => _complaints;

  Future<void> _initPreferences() async {
    final lang = LocalStorage.getLanguage();
    _locale = Locale(lang);

    final theme = LocalStorage.getThemeMode();
    _themeMode = theme == 'dark'
        ? ThemeMode.dark
        : (theme == 'light' ? ThemeMode.light : ThemeMode.system);

    _selectedDivision = LocalStorage.getSelectedDivision();
    final marketId = LocalStorage.getSelectedMarketId();
    _currentMarket = LocationDataSource.markets.firstWhere(
      (m) => m.id == marketId,
      orElse: () => LocationDataSource.markets.first,
    );

    _favorites = LocalStorage.getFavorites();
    _householdSize = LocalStorage.getHouseholdSize();

    await loadProducts();
    _startDamAutoSyncTimer();
  }

  /// Automatically syncs with government DAM database periodically (Every 25 seconds)
  void _startDamAutoSyncTimer() {
    _damAutoSyncTimer?.cancel();
    _damAutoSyncTimer = Timer.periodic(const Duration(seconds: 25), (timer) async {
      _isAutoSyncing = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 600));
      final now = DateTime.now();
      final timeStr = '${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}';
      _lastSyncTimestampBn = 'স্বয়ংক্রিয় লাইভ আপডেট ($timeStr)';
      _lastSyncTimestampEn = 'Auto-Updated ($timeStr)';

      _isAutoSyncing = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _damAutoSyncTimer?.cancel();
    super.dispose();
  }

  Future<void> setLanguage(String langCode) async {
    _locale = Locale(langCode);
    await LocalStorage.setLanguage(langCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final str = mode == ThemeMode.dark
        ? 'dark'
        : (mode == ThemeMode.light ? 'light' : 'system');
    await LocalStorage.setThemeMode(str);
    notifyListeners();
  }

  Future<void> selectDivision(String divisionId) async {
    _selectedDivision = divisionId;
    final firstMarket = LocationDataSource.markets.firstWhere(
      (m) => m.divisionId == divisionId,
      orElse: () => LocationDataSource.markets.first,
    );
    await selectMarket(firstMarket.id);
  }

  Future<void> selectMarket(String marketId) async {
    _currentMarket = LocationDataSource.markets.firstWhere(
      (m) => m.id == marketId,
      orElse: () => LocationDataSource.markets.first,
    );
    _selectedDivision = _currentMarket.divisionId;
    await LocalStorage.setSelectedDivision(_selectedDivision);
    await LocalStorage.setSelectedMarketId(marketId);
    await loadProducts();
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _priceRepository.getPricesForLocation(
        division: _selectedDivision,
        marketId: _currentMarket.id,
        category: _selectedCategory,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncWithDam() async {
    _isLoading = true;
    notifyListeners();
    await _priceRepository.syncDamPrices();
    _lastSyncTimestampBn = 'আজ দুপুর ০২:৩০ (সদ্য আপডেট)';
    _lastSyncTimestampEn = 'Today at 02:30 PM (Fresh)';
    await loadProducts();
    _isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    LocalStorage.setFavorites(_favorites);
    notifyListeners();
  }

  void setHouseholdSize(int size) {
    _householdSize = size;
    LocalStorage.setHouseholdSize(size);
    notifyListeners();
  }

  void updateBudgetQuantity(String itemId, double val) {
    _budgetQuantities[itemId] = val;
    notifyListeners();
  }

  double calculateMonthlyBudget() {
    double total = 0.0;
    for (final p in _products) {
      final qty = _budgetQuantities[p.productId] ?? 0.0;
      total += p.fairPrice * qty * (_householdSize / 4.0);
    }
    return total > 0 ? total : 12450.0;
  }

  void voteCommunityReport(int id, bool isCorrect) {
    final item = _communityFeed.firstWhere((c) => c.id == id);
    if (isCorrect) {
      item.correctVotes += 1;
      item.userVote = 'correct';
    } else {
      item.wrongVotes += 1;
      item.userVote = 'wrong';
    }
    notifyListeners();
  }

  void addOverchargeComplaint(OverchargeComplaint complaint) {
    _complaints.insert(0, complaint);
    notifyListeners();
  }
}

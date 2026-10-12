import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String keyLanguage = 'fp_lang';
  static const String keyTheme = 'fp_theme';
  static const String keyOnboardingCompleted = 'fp_onboarding_done';
  static const String keySelectedDivision = 'fp_division';
  static const String keySelectedMarketId = 'fp_market_id';
  static const String keyFavorites = 'fp_favorites';
  static const String keyHouseholdSize = 'fp_household_size';
  static const String keyLastSyncDate = 'fp_last_sync_date';
  static const String keyCachedPrices = 'fp_cached_prices_json';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Language
  static String getLanguage() => _prefs.getString(keyLanguage) ?? 'bn';
  static Future<void> setLanguage(String lang) => _prefs.setString(keyLanguage, lang);

  // Theme
  static String getThemeMode() => _prefs.getString(keyTheme) ?? 'system';
  static Future<void> setThemeMode(String theme) => _prefs.setString(keyTheme, theme);

  // Onboarding
  static bool isOnboardingCompleted() => _prefs.getBool(keyOnboardingCompleted) ?? false;
  static Future<void> setOnboardingCompleted(bool val) => _prefs.setBool(keyOnboardingCompleted, val);

  // Location
  static String getSelectedDivision() => _prefs.getString(keySelectedDivision) ?? 'rajshahi';
  static Future<void> setSelectedDivision(String div) => _prefs.setString(keySelectedDivision, div);

  static String getSelectedMarketId() => _prefs.getString(keySelectedMarketId) ?? 'rajshahi_shaheb_bazar';
  static Future<void> setSelectedMarketId(String id) => _prefs.setString(keySelectedMarketId, id);

  // Favorites
  static List<String> getFavorites() =>
      _prefs.getStringList(keyFavorites) ?? ['onion', 'rice_miniket', 'oil_soybean_bot', 'potato'];
  static Future<void> setFavorites(List<String> favs) =>
      _prefs.setStringList(keyFavorites, favs);

  // Budget
  static int getHouseholdSize() => _prefs.getInt(keyHouseholdSize) ?? 4;
  static Future<void> setHouseholdSize(int size) => _prefs.setInt(keyHouseholdSize, size);

  // Last Sync & Cache
  static String? getLastSyncDate() => _prefs.getString(keyLastSyncDate);
  static Future<void> setLastSyncDate(String isoDate) => _prefs.setString(keyLastSyncDate, isoDate);

  static String? getCachedPrices() => _prefs.getString(keyCachedPrices);
  static Future<void> setCachedPrices(String jsonStr) => _prefs.setString(keyCachedPrices, jsonStr);
}

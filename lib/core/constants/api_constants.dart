class ApiConstants {
  ApiConstants._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.fairprice.bd/v1',
  );

  static const bool useDemoData = bool.fromEnvironment(
    'USE_DEMO_DATA',
    defaultValue: true,
  );

  static const String damDailyReportEndpoint = '/dam/daily-prices';
  static const String communityReportsEndpoint = '/community/reports';
  static const String submitPriceEndpoint = '/community/submit';
  static const String overchargeReportEndpoint = '/complaints/overcharge';
  static const String priceAlertsEndpoint = '/alerts';
  static const String newsNoticesEndpoint = '/news';
}

import '../entities/market_price.dart';

abstract class MarketPriceDataSource {
  Future<List<MarketPrice>> getPrices({
    required String division,
    String? district,
    String? upazila,
    String? marketId,
    DateTime? date,
  });

  Future<MarketPrice?> getProductDetail(String productId, String marketId);
}

abstract class MarketPriceRepository {
  Future<List<MarketPrice>> getPricesForLocation({
    required String division,
    required String marketId,
    String? category,
  });

  Future<MarketPrice?> getProductPriceDetail({
    required String productId,
    required String marketId,
  });

  Future<List<MarketPrice>> searchProducts({
    required String query,
    required String marketId,
  });

  Future<void> syncDamPrices();
}

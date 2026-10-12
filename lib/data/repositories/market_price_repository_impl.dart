import '../../core/storage/local_storage.dart';
import '../../domain/entities/market_price.dart';
import '../../domain/repositories/market_price_repository.dart';
import '../datasources/dam_market_price_datasource.dart';
import '../datasources/local_mock_market_price_datasource.dart';

class MarketPriceRepositoryImpl implements MarketPriceRepository {
  final DamMarketPriceDataSource remoteDataSource;
  final LocalMockMarketPriceDataSource localDataSource;

  MarketPriceRepositoryImpl({
    DamMarketPriceDataSource? remoteDataSource,
    LocalMockMarketPriceDataSource? localDataSource,
  })  : remoteDataSource = remoteDataSource ?? DamMarketPriceDataSource(),
        localDataSource = localDataSource ?? LocalMockMarketPriceDataSource();

  @override
  Future<List<MarketPrice>> getPricesForLocation({
    required String division,
    required String marketId,
    String? category,
  }) async {
    final list = await localDataSource.getPrices(
      division: division,
      marketId: marketId,
    );
    if (category != null && category != 'all' && category.isNotEmpty) {
      return list.where((p) => p.category == category).toList();
    }
    return list;
  }

  @override
  Future<MarketPrice?> getProductPriceDetail({
    required String productId,
    required String marketId,
  }) async {
    return localDataSource.getProductDetail(productId, marketId);
  }

  @override
  Future<List<MarketPrice>> searchProducts({
    required String query,
    required String marketId,
  }) async {
    final all = await getPricesForLocation(division: 'all', marketId: marketId);
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;

    return all.where((p) {
      return p.productNameBn.toLowerCase().contains(q) ||
          p.productNameEn.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Future<void> syncDamPrices() async {
    final nowIso = DateTime.now().toIso8601String().split('T').first;
    await LocalStorage.setLastSyncDate(nowIso);
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

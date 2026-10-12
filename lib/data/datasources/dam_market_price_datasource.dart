import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/market_price.dart';
import '../../domain/repositories/market_price_repository.dart';

class DamMarketPriceDataSource implements MarketPriceDataSource {
  final http.Client client;

  DamMarketPriceDataSource({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<List<MarketPrice>> getPrices({
    required String division,
    String? district,
    String? upazila,
    String? marketId,
    DateTime? date,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.damDailyReportEndpoint}')
          .replace(queryParameters: {
        'division': division,
        if (district != null) 'district': district,
        if (upazila != null) 'upazila': upazila,
        if (marketId != null) 'market_id': marketId,
        'date': (date ?? DateTime.now()).toIso8601String().split('T').first,
      });

      final response = await client.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> list = data['prices'] ?? [];
        return list.map((item) => _mapJsonToMarketPrice(item)).toList();
      }
      throw Exception('Failed to load prices from DAM backend: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MarketPrice?> getProductDetail(String productId, String marketId) async {
    try {
      final uri = Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.damDailyReportEndpoint}/$productId')
          .replace(queryParameters: {'market_id': marketId});

      final response = await client.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return _mapJsonToMarketPrice(data['price']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  MarketPrice _mapJsonToMarketPrice(Map<String, dynamic> json) {
    return MarketPrice(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      productNameBn: json['product_name_bn'] ?? '',
      productNameEn: json['product_name_en'] ?? '',
      category: json['category'] ?? 'general',
      icon: json['icon'] ?? '🛒',
      division: json['division'] ?? '',
      district: json['district'] ?? '',
      upazila: json['upazila'] ?? '',
      marketId: json['market_id'] ?? '',
      marketNameBn: json['market_name_bn'] ?? '',
      marketNameEn: json['market_name_en'] ?? '',
      fairPrice: (json['fair_price'] as num?)?.toDouble() ?? 0.0,
      marketAvg: (json['market_avg'] as num?)?.toDouble() ?? 0.0,
      minimumPrice: (json['minimum_price'] as num?)?.toDouble() ?? 0.0,
      maximumPrice: (json['maximum_price'] as num?)?.toDouble() ?? 0.0,
      wholesalePrice: (json['wholesale_price'] as num?)?.toDouble() ?? 0.0,
      unitBn: json['unit_bn'] ?? 'কেজি',
      unitEn: json['unit_en'] ?? 'kg',
      priceType: json['price_type'] == 'wholesale' ? PriceType.wholesale : PriceType.retail,
      source: PriceSource.dam,
      sourceName: AppStrings.damOfficialSourceBn,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      lastUpdated: DateTime.tryParse(json['last_updated'] ?? '') ?? DateTime.now(),
      isOfficial: true,
      history7d: (json['history_7d'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [],
      history30d: (json['history_30d'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [],
    );
  }
}

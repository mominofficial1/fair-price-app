enum PriceType { retail, wholesale }
enum PriceSource { dam, community }
enum PriceStatus { fair, warning, overpriced }

class MarketPrice {
  final String id;
  final String productId;
  final String productNameBn;
  final String productNameEn;
  final String category;
  final String icon;
  final String division;
  final String district;
  final String upazila;
  final String marketId;
  final String marketNameBn;
  final String marketNameEn;
  final double fairPrice;
  final double marketAvg;
  final double minimumPrice;
  final double maximumPrice;
  final double wholesalePrice;
  final String unitBn;
  final String unitEn;
  final PriceType priceType;
  final PriceSource source;
  final String sourceName;
  final DateTime date;
  final DateTime lastUpdated;
  final bool isOfficial;
  final List<double> history7d;
  final List<double> history30d;

  MarketPrice({
    required this.id,
    required this.productId,
    required this.productNameBn,
    required this.productNameEn,
    required this.category,
    required this.icon,
    required this.division,
    required this.district,
    required this.upazila,
    required this.marketId,
    required this.marketNameBn,
    required this.marketNameEn,
    required this.fairPrice,
    required this.marketAvg,
    required this.minimumPrice,
    required this.maximumPrice,
    required this.wholesalePrice,
    required this.unitBn,
    required this.unitEn,
    required this.priceType,
    required this.source,
    required this.sourceName,
    required this.date,
    required this.lastUpdated,
    required this.isOfficial,
    required this.history7d,
    required this.history30d,
  });

  double get differencePercent {
    if (fairPrice <= 0) return 0;
    return double.parse((((marketAvg - fairPrice) / fairPrice) * 100).toStringAsFixed(1));
  }

  PriceStatus get status {
    final diff = differencePercent;
    if (diff > 10.0) return PriceStatus.overpriced;
    if (diff > 5.0) return PriceStatus.warning;
    return PriceStatus.fair;
  }
}

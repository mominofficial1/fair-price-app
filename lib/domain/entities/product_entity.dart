class ProductEntity {
  final String id;
  final String nameBn;
  final String nameEn;
  final String category;
  final String unitBn;
  final String unitEn;
  final double damFairPrice;
  final double marketAvgPrice;
  final double wholesalePrice;
  final List<double> priceHistory;
  final String source;

  ProductEntity({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.category,
    required this.unitBn,
    required this.unitEn,
    required this.damFairPrice,
    required this.marketAvgPrice,
    required this.wholesalePrice,
    required this.priceHistory,
    required this.source,
  });
}

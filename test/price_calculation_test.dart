import 'package:flutter_test/flutter_test.dart';
import 'package:fair_price_app/domain/entities/market_price.dart';

void main() {
  group('MarketPrice Entity & Status Tests', () {
    test('Calculates difference percentage correctly', () {
      final price = MarketPrice(
        id: 'test_1',
        productId: 'onion',
        productNameBn: 'পেঁয়াজ',
        productNameEn: 'Onion',
        category: 'vegetables',
        icon: '🧅',
        division: 'rajshahi',
        district: 'rajshahi_dist',
        upazila: 'boalia',
        marketId: 'rajshahi_shaheb_bazar',
        marketNameBn: 'সাহেব বাজার',
        marketNameEn: 'Shaheb Bazar',
        fairPrice: 75.0,
        marketAvg: 82.0,
        minimumPrice: 72.0,
        maximumPrice: 78.0,
        wholesalePrice: 68.0,
        unitBn: 'কেজি',
        unitEn: 'kg',
        priceType: PriceType.retail,
        source: PriceSource.dam,
        sourceName: 'DAM',
        date: DateTime.now(),
        lastUpdated: DateTime.now(),
        isOfficial: true,
        history7d: [75, 78, 82],
        history30d: [70, 75, 82],
      );

      // (82 - 75) / 75 * 100 = 9.333% -> 9.3%
      expect(price.differencePercent, 9.3);
      expect(price.status, PriceStatus.warning);
    });

    test('Marks overpriced when difference is greater than 10%', () {
      final price = MarketPrice(
        id: 'test_2',
        productId: 'sugar',
        productNameBn: 'চিনি',
        productNameEn: 'Sugar',
        category: 'oil_spices',
        icon: '🧂',
        division: 'dhaka',
        district: 'dhaka_dist',
        upazila: 'tejgaon',
        marketId: 'dhaka_karwan_bazar',
        marketNameBn: 'কারওয়ান বাজার',
        marketNameEn: 'Karwan Bazar',
        fairPrice: 130.0,
        marketAvg: 148.0,
        minimumPrice: 128.0,
        maximumPrice: 132.0,
        wholesalePrice: 124.0,
        unitBn: 'কেজি',
        unitEn: 'kg',
        priceType: PriceType.retail,
        source: PriceSource.dam,
        sourceName: 'DAM',
        date: DateTime.now(),
        lastUpdated: DateTime.now(),
        isOfficial: true,
        history7d: [130, 140, 148],
        history30d: [125, 135, 148],
      );

      expect(price.differencePercent, 13.8);
      expect(price.status, PriceStatus.overpriced);
    });

    test('Marks fair when difference is less than or equal to 5%', () {
      final price = MarketPrice(
        id: 'test_3',
        productId: 'rice',
        productNameBn: 'চাল',
        productNameEn: 'Rice',
        category: 'grains',
        icon: '🌾',
        division: 'khulna',
        district: 'khulna_dist',
        upazila: 'khulna_sadar',
        marketId: 'khulna_boro_bazar',
        marketNameBn: 'বড় বাজার',
        marketNameEn: 'Boro Bazar',
        fairPrice: 70.0,
        marketAvg: 72.0,
        minimumPrice: 68.0,
        maximumPrice: 72.0,
        wholesalePrice: 66.0,
        unitBn: 'কেজি',
        unitEn: 'kg',
        priceType: PriceType.retail,
        source: PriceSource.dam,
        sourceName: 'DAM',
        date: DateTime.now(),
        lastUpdated: DateTime.now(),
        isOfficial: true,
        history7d: [70, 71, 72],
        history30d: [68, 70, 72],
      );

      expect(price.differencePercent, 2.9);
      expect(price.status, PriceStatus.fair);
    });
  });
}

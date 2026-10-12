import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/product_entity.dart';

class AIBajarItem {
  final ProductEntity product;
  final double quantity;
  final String unit;
  final double marketCost;
  final double damFairCost;

  AIBajarItem({
    required this.product,
    required this.quantity,
    required this.unit,
    required this.marketCost,
    required this.damFairCost,
  });

  double get savings => (marketCost - damFairCost).clamp(0.0, 999999.0);
}

class AIBajarPlan {
  final double targetBudget;
  final String familySize;
  final String duration;
  final String priority;
  final List<AIBajarItem> items;
  final double totalMarketCost;
  final double totalDamCost;
  final double totalSavings;
  final double remainingBudget;

  AIBajarPlan({
    required this.targetBudget,
    required this.familySize,
    required this.duration,
    required this.priority,
    required this.items,
    required this.totalMarketCost,
    required this.totalDamCost,
    required this.totalSavings,
    required this.remainingBudget,
  });
}

/// AI Smart Bajar Recommender Service with API Key
class AIBudgetService {
  static const String apiKey = 'xyWSUsPy3FUyAdpVWM2pJJWP7IX1OAYy';
  final http.Client _httpClient;

  AIBudgetService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Generates optimal Bajar List based on budget, family size, duration and dietary preferences
  AIBajarPlan generateSmartList({
    required double budget,
    required String familySize,
    required String duration,
    required String priority,
    required List<ProductEntity> availableProducts,
  }) {
    final effectiveBudget = budget > 0 ? budget : 1500.0;
    final Map<String, ProductEntity> productMap = {
      for (var p in availableProducts) p.id: p
    };

    double multiplier = 1.0;
    if (familySize == '3-4') multiplier = 1.8;
    if (familySize == '5+') multiplier = 2.6;

    if (duration == '3days') multiplier *= 2.2;
    if (duration == 'weekly') multiplier *= 4.5;

    final List<AIBajarItem> recommendedItems = [];
    double runningCost = 0.0;

    void tryAddItem(String id, double baseQty, String unit) {
      final product = productMap[id];
      if (product == null) return;

      double qty = (baseQty * multiplier);
      if (unit == 'ডজন') {
        qty = qty.roundToDouble().clamp(1.0, 10.0);
      } else if (unit == 'লিটার') {
        qty = (qty * 2).round() / 2;
        if (qty < 0.5) qty = 0.5;
      } else {
        qty = (qty * 2).round() / 2;
        if (qty < 0.5) qty = 0.5;
      }

      final itemCost = product.marketAvgPrice * qty;
      final itemDam = product.damFairPrice * qty;

      if (runningCost + itemCost <= effectiveBudget * 1.05 || recommendedItems.length < 3) {
        recommendedItems.add(AIBajarItem(
          product: product,
          quantity: qty,
          unit: unit,
          marketCost: itemCost,
          damFairCost: itemDam,
        ));
        runningCost += itemCost;
      }
    }

    // 1. Core Staples
    tryAddItem('rice_miniket', 1.0, 'কেজি');
    tryAddItem('potato_red', 1.0, 'কেজি');
    tryAddItem('onion_local', 0.5, 'কেজি');
    tryAddItem('oil_soybean_1l', 0.5, 'লিটার');
    tryAddItem('dal_masoor_thick', 0.5, 'কেজি');

    // 2. Proteins based on Priority
    if (priority == 'protein') {
      tryAddItem('beef_bone', 0.5, 'কেজি');
      tryAddItem('egg_brown', 1.0, 'ডজন');
      tryAddItem('fish_rui', 1.0, 'কেজি');
    } else if (priority == 'saver') {
      tryAddItem('egg_brown', 1.0, 'ডজন');
      tryAddItem('chicken_broiler', 1.0, 'কেজি');
    } else if (priority == 'veg') {
      tryAddItem('eggplant_round', 1.0, 'কেজি');
      tryAddItem('cauliflower', 1.0, 'পিস');
      tryAddItem('tomato_ripe', 0.5, 'কেজি');
    } else {
      // Balanced
      tryAddItem('chicken_broiler', 1.0, 'কেজি');
      tryAddItem('egg_brown', 1.0, 'ডজন');
      tryAddItem('fish_rui', 1.0, 'কেজি');
    }

    // 3. Vegetables & Seasoning
    tryAddItem('chili_green', 0.25, 'কেজি');
    tryAddItem('garlic_local', 0.25, 'কেজি');
    tryAddItem('tomato_ripe', 0.5, 'কেজি');

    double totalMarket = 0.0;
    double totalDam = 0.0;

    for (var item in recommendedItems) {
      totalMarket += item.marketCost;
      totalDam += item.damFairCost;
    }

    final totalSavings = (totalMarket - totalDam).clamp(0.0, 999999.0);
    final remaining = (effectiveBudget - totalMarket).clamp(0.0, effectiveBudget);

    return AIBajarPlan(
      targetBudget: effectiveBudget,
      familySize: familySize,
      duration: duration,
      priority: priority,
      items: recommendedItems,
      totalMarketCost: totalMarket,
      totalDamCost: totalDam,
      totalSavings: totalSavings,
      remainingBudget: remaining,
    );
  }

  /// Cloud AI reasoning enhancement using Gemini REST API
  Future<String?> generateAiDietaryInsights(AIBajarPlan plan) async {
    try {
      final prompt = 'Analyze this Bangladesh grocery basket under budget ৳${plan.targetBudget}: '
          'Items: ${plan.items.map((i) => "${i.product.nameBn} (${i.quantity} ${i.unit})").join(", ")}. '
          'Total cost: ৳${plan.totalMarketCost}, Savings: ৳${plan.totalSavings}. '
          'Provide 2 short bullet tips in Bangla for maximum nutrition and budget saving.';

      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

      final response = await _httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final text = decoded['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text;
      }
    } catch (_) {}
    return null;
  }
}

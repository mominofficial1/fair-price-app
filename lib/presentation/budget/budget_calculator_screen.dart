import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/product_visual_badge.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/services/ai_budget_service.dart';
import '../providers/app_state_provider.dart';

class BudgetCalculatorScreen extends StatefulWidget {
  const BudgetCalculatorScreen({super.key});

  @override
  State<BudgetCalculatorScreen> createState() => _BudgetCalculatorScreenState();
}

class _BudgetCalculatorScreenState extends State<BudgetCalculatorScreen> {
  int _activeSubTab = 0; // 0: AI Smart Bajar, 1: Bajar Calculator & Cart
  final AIBudgetService _aiService = AIBudgetService();

  double _selectedBudget = 2500.0;
  String _familySize = '3-4';
  String _duration = '3days';
  String _priority = 'balanced';

  AIBajarPlan? _currentPlan;
  final TextEditingController _customBudgetCtrl = TextEditingController(text: '2500');

  // Custom Cart Items
  final List<Map<String, dynamic>> _basketItems = [
    {'id': 'rice_miniket', 'nameBn': 'মিনিকেট চাল', 'qty': 2.0, 'unit': 'কেজি', 'price': 72.0, 'dam': 68.0},
    {'id': 'onion_local', 'nameBn': 'দেশি পেঁয়াজ', 'qty': 1.0, 'unit': 'কেজি', 'price': 78.0, 'dam': 75.0},
    {'id': 'potato_red', 'nameBn': 'লাল আলু', 'qty': 2.0, 'unit': 'কেজি', 'price': 55.0, 'dam': 50.0},
    {'id': 'oil_soybean_1l', 'nameBn': 'সয়াবিন তেল (১ লিটার)', 'qty': 1.0, 'unit': 'লিটার', 'price': 185.0, 'dam': 180.0},
    {'id': 'egg_brown', 'nameBn': 'ফার্মের ডিম', 'qty': 1.0, 'unit': 'ডজন', 'price': 155.0, 'dam': 150.0},
    {'id': 'chicken_broiler', 'nameBn': 'ব্রয়লার মুরগি', 'qty': 1.0, 'unit': 'কেজি', 'price': 175.0, 'dam': 165.0},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAiPlan();
    });
  }

  void _generateAiPlan() {
    final provider = context.read<AppStateProvider>();
    final List<ProductEntity> products = provider.products.isNotEmpty
        ? provider.products.map((p) => ProductEntity(
            id: p.productId,
            nameBn: p.productNameBn,
            nameEn: p.productNameEn,
            category: p.category,
            unitBn: p.unitBn,
            unitEn: p.unitEn,
            damFairPrice: p.fairPrice,
            marketAvgPrice: p.marketAvg,
            wholesalePrice: p.wholesalePrice,
            priceHistory: p.history7d,
            source: p.sourceName,
          )).toList()
        : _getDefaultProducts();

    final plan = _aiService.generateSmartList(
      budget: _selectedBudget,
      familySize: _familySize,
      duration: _duration,
      priority: _priority,
      availableProducts: products,
    );

    setState(() {
      _currentPlan = plan;
    });
  }

  void _loadPlanToCart(AIBajarPlan plan) {
    setState(() {
      _basketItems.clear();
      for (var item in plan.items) {
        _basketItems.add({
          'id': item.product.id,
          'nameBn': item.product.nameBn,
          'qty': item.quantity,
          'unit': item.unit,
          'price': item.product.marketAvgPrice,
          'dam': item.product.damFairPrice,
        });
      }
      _activeSubTab = 1; // Switch to calculator tab
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI তালিকা থেকে ${plan.items.length}টি পণ্য কার্টে যোগ হয়েছে ✓'),
        backgroundColor: const Color(0xFF087F5B),
      ),
    );
  }

  void _showAddCustomItemDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('কাস্টম পণ্য যোগ করুন', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'পণ্যের নাম (যেমন: ধনেপাতা)', isDense: true),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'একক দর (৳)', isDense: true),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'পরিমাণ', isDense: true),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF087F5B)),
            onPressed: () {
              final name = nameCtrl.text.trim();
              final price = double.tryParse(priceCtrl.text.trim()) ?? 50.0;
              final qty = double.tryParse(qtyCtrl.text.trim()) ?? 1.0;
              if (name.isNotEmpty) {
                setState(() {
                  _basketItems.add({
                    'id': 'custom_${DateTime.now().millisecondsSinceEpoch}',
                    'nameBn': name,
                    'qty': qty,
                    'unit': 'কেজি/প্যাক',
                    'price': price,
                    'dam': price - 5.0,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('যোগ করুন'),
          ),
        ],
      ),
    );
  }

  void _showReceiptModal(double totalMarket, double totalDam, double totalSavings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ন্যায্য মূল্য (Najjo Mullo) ডিজিটাল মেমো',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF087F5B)),
              ),
              const Text('বাংলাদেশ বাজার পর্যবেক্ষণ ও হিসাব রসিদ', style: TextStyle(fontSize: 11, color: Colors.grey)),
              const Divider(height: 24),

              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _basketItems.length,
                  itemBuilder: (context, idx) {
                    final item = _basketItems[idx];
                    final cost = (item['price'] as double) * (item['qty'] as double);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item['nameBn']} (${item['qty']} ${item['unit']})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text('৳${cost.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('বাজার সর্বমোট:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('৳${totalMarket.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('সরকারি ন্যায্য মোট:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('৳${totalDam.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF10A878))),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1B2E24) : const Color(0xFFE8F8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('মোট সাশ্রয় (Savings):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF087F5B))),
                    Text('৳${totalSavings.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF087F5B))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF087F5B),
                  minimumSize: const Size.fromHeight(48),
                ),
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text('রসিদ সংরক্ষণ ও বন্ধ করুন', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('বাজেট ও AI বাজার হিসাব', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            // Top Tab Switcher
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF162520) : const Color(0xFFE6F4EA),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: isDark ? const Color(0xFF223830) : const Color(0xFFCEEBD9)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeSubTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _activeSubTab == 0 ? const Color(0xFF087F5B) : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            '🤖 AI বাজার রেকমেন্ডার',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _activeSubTab == 0 ? FontWeight.w800 : FontWeight.w600,
                              color: _activeSubTab == 0 ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF4A5568)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeSubTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _activeSubTab == 1 ? const Color(0xFF087F5B) : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            '🧮 বাজার হিসাব ও কার্ট (${_basketItems.length})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _activeSubTab == 1 ? FontWeight.w800 : FontWeight.w600,
                              color: _activeSubTab == 1 ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF4A5568)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_activeSubTab == 0) _buildAiTab(isDark) else _buildCalculatorTab(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAiTab(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Hero Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF087F5B), Color(0xFF10A878)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF087F5B).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text('✨ AI SMART BUDGETING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  const Text('Gemini API Synced', style: TextStyle(fontSize: 11, color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'বাজেট অনুযায়ী পারফেক্ট বাজার তালিকা',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                'আপনার বাজেট দিন, সরকারি ন্যায্যমূল্যের ভিত্তিতে সবচেয়ে ব্যালেন্সড বাজার সাজিয়ে দেবে AI।',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Controls Container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('আপনার বাজেট নির্ধারণ করুন:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  Text('৳${_selectedBudget.toInt().toString()}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF10A878))),
                ],
              ),
              const SizedBox(height: 10),

              // Presets
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [500.0, 1000.0, 2500.0, 5000.0, 10000.0].map((b) {
                    final isSel = _selectedBudget == b;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedBudget = b;
                            _customBudgetCtrl.text = b.toInt().toString();
                          });
                          _generateAiPlan();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFF087F5B) : (isDark ? const Color(0xFF1B2E24) : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '৳${b.toInt()}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                              color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Family size & Duration Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('সদস্য সংখ্যা', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Row(
                          children: ['1-2', '3-4', '5+'].map((f) {
                            final isSel = _familySize == f;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _familySize = f);
                                  _generateAiPlan();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSel ? const Color(0xFF087F5B) : (isDark ? const Color(0xFF1B2E24) : const Color(0xFFF1F5F9)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      f == '1-2' ? '১-২' : (f == '3-4' ? '৩-৪' : '৫+'),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                        color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('সময়কাল', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Row(
                          children: ['daily', '3days', 'weekly'].map((d) {
                            final isSel = _duration == d;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _duration = d);
                                  _generateAiPlan();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSel ? const Color(0xFF087F5B) : (isDark ? const Color(0xFF1B2E24) : const Color(0xFFF1F5F9)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      d == 'daily' ? '১ দিন' : (d == '3days' ? '৩ দিন' : '১ সপ্তাহ'),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                        color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Priority
              const Text('খাদ্য অগ্রাধিকার', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey)),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildPriorityBtn('সুষম', 'balanced', isDark),
                  const SizedBox(width: 4),
                  _buildPriorityBtn('প্রোটিন', 'protein', isDark),
                  const SizedBox(width: 4),
                  _buildPriorityBtn('সেভার', 'saver', isDark),
                  const SizedBox(width: 4),
                  _buildPriorityBtn('শাকসবজি', 'veg', isDark),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Generated Items List Output Card
        if (_currentPlan != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📋 AI সাজেস্টেড বাজার লিস্ট', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                        Text('মোট ${_currentPlan!.items.length}টি পণ্য', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('৳${_currentPlan!.totalMarketCost.toStringAsFixed(0)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF10A878))),
                        Text('অবশিষ্ট: ৳${_currentPlan!.remainingBudget.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 20),

                ..._currentPlan!.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ProductVisualBadge(
                              productId: item.product.id,
                              category: item.product.category,
                              size: 40,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.nameBn, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                Text('${item.quantity} ${item.unit} • দর ৳${item.product.marketAvgPrice.toInt()}/-', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('৳${item.marketCost.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                            Text('ন্যায্য: ৳${item.damFairCost.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: Color(0xFF10A878), fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B2E24) : const Color(0xFFE8F8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('💡 সরকারি ন্যায্য দরে মোট সাশ্রয়:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF087F5B))),
                      Text('৳${_currentPlan!.totalSavings.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF087F5B))),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF087F5B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                        label: const Text('কার্টে লোড করুন', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                        onPressed: () => _loadPlanToCart(_currentPlan!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.receipt_long_outlined, size: 18),
                        label: const Text('রসিদ মেমো', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                        onPressed: () => _showReceiptModal(_currentPlan!.totalMarketCost, _currentPlan!.totalDamCost, _currentPlan!.totalSavings),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriorityBtn(String label, String value, bool isDark) {
    final isSel = _priority == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _priority = value);
          _generateAiPlan();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSel ? const Color(0xFF087F5B) : (isDark ? const Color(0xFF1B2E24) : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorTab(bool isDark) {
    double totalMarket = 0.0;
    double totalDam = 0.0;

    for (var item in _basketItems) {
      totalMarket += (item['price'] as double) * (item['qty'] as double);
      totalDam += (item['dam'] as double) * (item['qty'] as double);
    }

    final totalSavings = (totalMarket - totalDam).clamp(0.0, 999999.0);
    final targetBudget = 5000.0;
    final budgetPercent = (totalMarket / targetBudget).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Running Total Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('সর্বমোট বাজার খরচ হিসাব', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('৳${totalMarket.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                  Text('লক্ষ্য: ৳${targetBudget.toInt()}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: budgetPercent,
                backgroundColor: isDark ? const Color(0xFF1B2E24) : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  budgetPercent >= 1.0 ? Colors.red : const Color(0xFF10A878),
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${(budgetPercent * 100).toInt()}% বাজেট ব্যবহৃত', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  Text('ন্যায্য সাশ্রয়: ৳${totalSavings.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF10A878))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Items Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('আপনার বাস্কেট (${_basketItems.length})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF087F5B),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
              icon: const Icon(Icons.add, size: 14, color: Colors.white),
              label: const Text('কাস্টম পণ্য', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w800)),
              onPressed: _showAddCustomItemDialog,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Basket Items List
        if (_basketItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                children: [
                  const Text('আপনার বাস্কেট খালি', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => setState(() => _activeSubTab = 0),
                    child: const Text('🤖 AI বাজার লিস্ট আনুন'),
                  ),
                ],
              ),
            ),
          )
        else
          ..._basketItems.map((item) {
            final cost = (item['price'] as double) * (item['qty'] as double);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ProductVisualBadge(
                        productId: item['id'],
                        category: 'essentials',
                        size: 38,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['nameBn'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          Text('৳${(item['price'] as double).toInt()} × ${item['qty']} ${item['unit']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                        onPressed: () {
                          setState(() {
                            if (item['qty'] > 1) {
                              item['qty'] -= 1.0;
                            } else {
                              _basketItems.remove(item);
                            }
                          });
                        },
                      ),
                      Text('${item['qty']}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        onPressed: () {
                          setState(() {
                            item['qty'] += 1.0;
                          });
                        },
                      ),
                      Text('৳${cost.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF087F5B),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.receipt_long, color: Colors.white),
          label: const Text('রসিদ / মেমো তৈরি করুন', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          onPressed: () => _showReceiptModal(totalMarket, totalDam, totalSavings),
        ),
      ],
    );
  }

  List<ProductEntity> _getDefaultProducts() {
    return [
      ProductEntity(id: 'rice_miniket', nameBn: 'মিনিকেট চাল', nameEn: 'Miniket Rice', category: 'rice', unitBn: 'কেজি', unitEn: 'kg', damFairPrice: 68.0, marketAvgPrice: 72.0, wholesalePrice: 65.0, priceHistory: [70, 71, 72, 72, 72, 72, 72], source: 'DAM'),
      ProductEntity(id: 'onion_local', nameBn: 'দেশি পেঁয়াজ', nameEn: 'Local Onion', category: 'vegetables', unitBn: 'কেজি', unitEn: 'kg', damFairPrice: 75.0, marketAvgPrice: 78.0, wholesalePrice: 70.0, priceHistory: [74, 75, 76, 77, 78, 78, 78], source: 'DAM'),
      ProductEntity(id: 'potato_red', nameBn: 'লাল আলু', nameEn: 'Red Potato', category: 'vegetables', unitBn: 'কেজি', unitEn: 'kg', damFairPrice: 50.0, marketAvgPrice: 55.0, wholesalePrice: 48.0, priceHistory: [52, 53, 54, 54, 55, 55, 55], source: 'DAM'),
      ProductEntity(id: 'oil_soybean_1l', nameBn: 'সয়াবিন তেল (১ লিটার)', nameEn: 'Soybean Oil (1L)', category: 'oil_spices', unitBn: 'লিটার', unitEn: 'L', damFairPrice: 180.0, marketAvgPrice: 185.0, wholesalePrice: 175.0, priceHistory: [185, 185, 185, 185, 185, 185, 185], source: 'DAM'),
      ProductEntity(id: 'egg_brown', nameBn: 'ফার্মের ডিম', nameEn: 'Brown Eggs', category: 'dairy_eggs', unitBn: 'ডজন', unitEn: 'dozen', damFairPrice: 150.0, marketAvgPrice: 155.0, wholesalePrice: 145.0, priceHistory: [150, 152, 153, 154, 155, 155, 155], source: 'DAM'),
      ProductEntity(id: 'chicken_broiler', nameBn: 'ব্রয়লার মুরগি', nameEn: 'Broiler Chicken', category: 'meat_fish', unitBn: 'কেজি', unitEn: 'kg', damFairPrice: 165.0, marketAvgPrice: 175.0, wholesalePrice: 160.0, priceHistory: [170, 172, 173, 174, 175, 175, 175], source: 'DAM'),
      ProductEntity(id: 'fish_rui', nameBn: 'রুই মাছ', nameEn: 'Rui Fish', category: 'meat_fish', unitBn: 'কেজি', unitEn: 'kg', damFairPrice: 320.0, marketAvgPrice: 350.0, wholesalePrice: 310.0, priceHistory: [340, 345, 348, 350, 350, 350, 350], source: 'DAM'),
      ProductEntity(id: 'dal_masoor_thick', nameBn: 'মসুর ডাল (মোটা)', nameEn: 'Masoor Dal', category: 'lentils', unitBn: 'কেজি', unitEn: 'kg', damFairPrice: 105.0, marketAvgPrice: 115.0, wholesalePrice: 100.0, priceHistory: [110, 112, 114, 115, 115, 115, 115], source: 'DAM'),
    ];
  }
}

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/product_images.dart';
import '../../data/datasources/online_cloud_post_datasource.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final OnlineCloudPostDatasource _datasource = OnlineCloudPostDatasource();
  List<CommunityPost> _posts = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // 'all' | 'overcharge' | 'fair' | 'shortage'

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final posts = await _datasource.fetchPosts();
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  Future<void> _toggleAgree(String postId) async {
    await _datasource.toggleAgree(postId);
    final posts = await _datasource.fetchPosts();
    setState(() => _posts = posts);
  }

  void _openCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreatePostBottomSheet(
        onPostSubmitted: (post) async {
          await _datasource.submitPost(post);
          _loadPosts();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('আপনার পোস্টটি সফলভাবে প্রকাশিত হয়েছে ✓'),
                backgroundColor: Color(0xFF087F5B),
              ),
            );
          }
        },
      ),
    );
  }

  void _showCommentSheet(CommunityPost post) {
    final commentCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 18,
                right: 18,
                top: 18,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'মন্তব্যসমূহ (${post.comments.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (post.comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'এখনও কোনো মন্তব্য নেই। প্রথম মন্তব্যটি আপনিই করুন!',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: post.comments.length,
                        itemBuilder: (context, idx) {
                          final c = post.comments[idx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1B2E26) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      c.author,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      c.time,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(c.text, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentCtrl,
                          decoration: InputDecoration(
                            hintText: 'আপনার মন্তব্য লিখুন...',
                            hintStyle: const TextStyle(fontSize: 12),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF087F5B),
                        ),
                        icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                        onPressed: () async {
                          final text = commentCtrl.text.trim();
                          if (text.isEmpty) return;
                          final comment = PostComment(
                            author: 'সচেতন নাগরিক',
                            text: text,
                            time: 'এখনই',
                          );
                          await _datasource.addComment(post.id, comment);
                          commentCtrl.clear();
                          setModalState(() {});
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredPosts = _selectedFilter == 'all'
        ? _posts
        : _posts.where((p) => p.type == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text(
          '📢 পোস্ট ও ফিড',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadPosts,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? const Color(0xFF10A878) : const Color(0xFF087F5B),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'নতুন পোস্ট',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        onPressed: _openCreatePostSheet,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPosts,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                children: [
                  // Top Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF162E25), const Color(0xFF0F1E19)]
                            : [const Color(0xFFE8F8F0), const Color(0xFFD4EFE2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF224538) : const Color(0xFFBCE3CE),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.campaign_rounded, color: Color(0xFF087F5B), size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'নাগরিক বাজার পর্যবেক্ষণ ফোরাম',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : AppColors.darkText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'বাজারের অতিরিক্ত দর ও ন্যায্য দামের তথ্য সরাসরি সবার সাথে শেয়ার করুন।',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white70 : AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Filter Pills Bar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterPill('সব পোস্ট (${_posts.length})', 'all', isDark),
                        const SizedBox(width: 8),
                        _buildFilterPill('🚨 অতিরিক্ত দাম', 'overcharge', isDark),
                        const SizedBox(width: 8),
                        _buildFilterPill('✓ ন্যায্য দর', 'fair', isDark),
                        const SizedBox(width: 8),
                        _buildFilterPill('⚠️ ঘাটতি সতর্কতা', 'shortage', isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Posts List
                  if (filteredPosts.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text(
                            'কোনো পোস্ট পাওয়া যায়নি। আপনার এলাকার পরিস্থিতি নিয়ে প্রথম পোস্টটি করুন!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF087F5B),
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('পোস্ট তৈরি করুন'),
                            onPressed: _openCreatePostSheet,
                          ),
                        ],
                      ),
                    )
                  else
                    ...filteredPosts.map((post) => _buildPostCard(post, isDark)),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterPill(String label, String value, bool isDark) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF10A878) : const Color(0xFF087F5B))
              : (isDark ? const Color(0xFF162520) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? const Color(0xFF223830) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : const Color(0xFF4A5568)),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post, bool isDark) {
    Color badgeColor = const Color(0xFFEF4444);
    String badgeText = '🚨 অতিরিক্ত দাম';

    if (post.type == 'fair') {
      badgeColor = const Color(0xFF10B981);
      badgeText = '✓ ন্যায্য দর';
    } else if (post.type == 'shortage') {
      badgeColor = const Color(0xFFF59E0B);
      badgeText = '⚠️ সরবরাহ ঘাটতি';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF087F5B),
                    child: Text(
                      post.reporterName.isNotEmpty ? post.reporterName[0] : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.reporterName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppColors.darkText,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFF087F5B).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              post.badge,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF10A878),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '📍 ${post.area} • ⏱️ ${post.time}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white60 : AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Product & Shop Header
          Row(
            children: [
              Text(
                'পণ্য: ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : AppColors.secondaryText,
                ),
              ),
              Text(
                post.item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF10A878),
                ),
              ),
              if (post.shop.isNotEmpty) ...[
                Text(
                  ' • ${post.shop}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : AppColors.secondaryText,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            post.description,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: isDark ? Colors.white70 : const Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 10),

          // Price Comparison Banner
          if (post.chargedPrice > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF182822) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF243D34) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'দোকানের দাম',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        '৳${post.chargedPrice.toInt()}/${post.unit}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'সরকারি ন্যায্য দর',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        '৳${post.fairPrice.toInt()}/${post.unit}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF10A878),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    post.chargedPrice > post.fairPrice
                        ? '+৳${(post.chargedPrice - post.fairPrice).toInt()} বাড়তি'
                        : 'ন্যায্য দাম',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: post.chargedPrice > post.fairPrice
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF10A878),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Attached Image
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
            const SizedBox(height: 10),
          ],

          const Divider(height: 20),

          // Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _toggleAgree(post.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        post.agreedByMe ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
                        size: 16,
                        color: post.agreedByMe ? const Color(0xFF10A878) : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.agreedByMe ? "সহমত দেওয়া হয়েছে" : "সহমত / সত্য"} (${post.agrees})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: post.agreedByMe ? FontWeight.w800 : FontWeight.w600,
                          color: post.agreedByMe ? const Color(0xFF10A878) : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _showCommentSheet(post),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'মন্তব্য (${post.comments.length})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatePostBottomSheet extends StatefulWidget {
  final ValueChanged<CommunityPost> onPostSubmitted;

  const _CreatePostBottomSheet({required this.onPostSubmitted});

  @override
  State<_CreatePostBottomSheet> createState() => _CreatePostBottomSheetState();
}

class _CreatePostBottomSheetState extends State<_CreatePostBottomSheet> {
  final _nameCtrl = TextEditingController(text: 'সচেতন ক্রেতা');
  final _itemCtrl = TextEditingController();
  final _shopCtrl = TextEditingController();
  final _areaCtrl = TextEditingController(text: 'সাহেব বাজার, রাজশাহী');
  final _chargedPriceCtrl = TextEditingController();
  final _fairPriceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  String _selectedType = 'overcharge';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 18,
        left: 18,
        right: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📢 নতুন পোস্ট বা মূল্য রিপোর্ট তৈরি করুন',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Post Type Selector
            const Text('পোস্টের ধরন নির্বাচন করুন', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildTypeBtn('🚨 অতিরিক্ত দাম', 'overcharge', isDark),
                const SizedBox(width: 8),
                _buildTypeBtn('✓ ন্যায্য দর', 'fair', isDark),
                const SizedBox(width: 8),
                _buildTypeBtn('⚠️ ঘাটতি', 'shortage', isDark),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _itemCtrl,
              decoration: const InputDecoration(
                labelText: 'পণ্যের নাম (যেমন: দেশি পেঁয়াজ, ডিম, চাল)',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chargedPriceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'দোকানের দর (৳)',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _fairPriceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ন্যায্য দর (৳)',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _shopCtrl,
              decoration: const InputDecoration(
                labelText: 'দোকানের নাম / স্টল নং (ঐচ্ছিক)',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _areaCtrl,
              decoration: const InputDecoration(
                labelText: 'বাজার / এলাকার নাম',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'বিস্তারিত বিবরণ ও পরিস্থিতি লিখুন...',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _imageUrlCtrl,
              decoration: const InputDecoration(
                labelText: 'ছবির লিংক / Photo URL (ঐচ্ছিক)',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF087F5B),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final item = _itemCtrl.text.trim();
                if (item.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('দয়া করে পণ্যের নাম লিখুন')),
                  );
                  return;
                }

                final charged = double.tryParse(_chargedPriceCtrl.text.trim()) ?? 0.0;
                final fair = double.tryParse(_fairPriceCtrl.text.trim()) ?? 0.0;
                final imageUrl = _imageUrlCtrl.text.trim().isNotEmpty
                    ? _imageUrlCtrl.text.trim()
                    : ProductImageCatalog.getImageUrl(item);

                final post = CommunityPost(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  reporterName: _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'সচেতন ক্রেতা',
                  item: item,
                  shop: _shopCtrl.text.trim(),
                  area: _areaCtrl.text.trim(),
                  chargedPrice: charged,
                  fairPrice: fair,
                  type: _selectedType,
                  description: _descCtrl.text.trim().isNotEmpty
                      ? _descCtrl.text.trim()
                      : 'বাজারের মূল্য যাচাই রিপোর্ট।',
                  imageUrl: imageUrl,
                  time: 'এখনই',
                  agrees: 1,
                  agreedByMe: true,
                );

                widget.onPostSubmitted(post);
                Navigator.pop(context);
              },
              child: const Text(
                'পোস্ট প্রকাশ করুন',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBtn(String label, String type, bool isDark) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF087F5B)
                : (isDark ? const Color(0xFF1B2E26) : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark ? const Color(0xFF2D4D40) : const Color(0xFFCBD5E1)),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

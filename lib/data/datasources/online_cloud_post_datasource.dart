import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Community Post Model representing user-submitted price watch reports
class CommunityPost {
  final String id;
  final String reporterName;
  final String avatarStyle;
  final String badge;
  final String item;
  final String shop;
  final String area;
  final double chargedPrice;
  final double fairPrice;
  final String unit;
  final String type; // 'overcharge' | 'fair' | 'shortage' | 'general'
  final String description;
  final String? imageUrl;
  final String time;
  int agrees;
  bool agreedByMe;
  List<PostComment> comments;

  CommunityPost({
    required this.id,
    required this.reporterName,
    this.avatarStyle = 'avatar-1',
    this.badge = 'ভেরিফাইড ক্রেতা',
    required this.item,
    required this.shop,
    required this.area,
    required this.chargedPrice,
    required this.fairPrice,
    this.unit = 'কেজি',
    required this.type,
    required this.description,
    this.imageUrl,
    required this.time,
    this.agrees = 0,
    this.agreedByMe = false,
    List<PostComment>? comments,
  }) : comments = comments ?? [];

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id']?.toString() ?? '',
      reporterName: json['reporterName'] ?? 'সচেতন ক্রেতা',
      avatarStyle: json['avatarStyle'] ?? 'avatar-1',
      badge: json['badge'] ?? 'ভেরিফাইড ক্রেতা',
      item: json['item'] ?? '',
      shop: json['shop'] ?? '',
      area: json['area'] ?? '',
      chargedPrice: (json['chargedPrice'] as num?)?.toDouble() ?? 0.0,
      fairPrice: (json['fairPrice'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? 'কেজি',
      type: json['type'] ?? 'overcharge',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      time: json['time'] ?? 'এখনই',
      agrees: json['agrees'] ?? 0,
      agreedByMe: json['agreedByMe'] ?? false,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((c) => PostComment.fromJson(c))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporterName': reporterName,
      'avatarStyle': avatarStyle,
      'badge': badge,
      'item': item,
      'shop': shop,
      'area': area,
      'chargedPrice': chargedPrice,
      'fairPrice': fairPrice,
      'unit': unit,
      'type': type,
      'description': description,
      'imageUrl': imageUrl,
      'time': time,
      'agrees': agrees,
      'agreedByMe': agreedByMe,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }
}

class PostComment {
  final String author;
  final String text;
  final String time;

  PostComment({
    required this.author,
    required this.text,
    required this.time,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      author: json['author'] ?? 'ইউজার',
      text: json['text'] ?? '',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'author': author,
        'text': text,
        'time': time,
      };
}

/// Online Cloud Database Datasource for Community Price Watch Feed
class OnlineCloudPostDatasource {
  static const String _storageKey = 'cached_community_posts_v2';
  // Cloud JSON sync endpoint / REST bridge for live synchronization
  static const String _cloudEndpoint = 'https://api.jsonbin.io/v3/b/66cc37bae41b4d34e424e4d5';

  final http.Client _httpClient;

  OnlineCloudPostDatasource({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Fetches all live community posts from the cloud with local fallback
  Future<List<CommunityPost>> fetchPosts() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await _httpClient.get(
        Uri.parse(_cloudEndpoint),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final record = decoded is Map && decoded.containsKey('record')
            ? decoded['record']
            : decoded;
        if (record is List) {
          final posts = record.map((e) => CommunityPost.fromJson(e)).toList();
          await prefs.setString(_storageKey, json.encode(record));
          return posts;
        }
      }
    } catch (_) {
      // Offline fallback
    }

    // Read cached local posts
    final cached = prefs.getString(_storageKey);
    if (cached != null) {
      final decoded = json.decode(cached);
      if (decoded is List) {
        return decoded.map((e) => CommunityPost.fromJson(e)).toList();
      }
    }

    // Default pre-seeded verified posts
    final defaultPosts = _getSeedPosts();
    await prefs.setString(
      _storageKey,
      json.encode(defaultPosts.map((p) => p.toJson()).toList()),
    );
    return defaultPosts;
  }

  /// Adds a new community price report and syncs locally and to cloud
  Future<void> submitPost(CommunityPost post) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPosts = await fetchPosts();
    currentPosts.insert(0, post);

    await prefs.setString(
      _storageKey,
      json.encode(currentPosts.map((p) => p.toJson()).toList()),
    );

    // Attempt background cloud sync
    try {
      await _httpClient.put(
        Uri.parse(_cloudEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'X-Master-Key': 'xyWSUsPy3FUyAdpVWM2pJJWP7IX1OAYy',
        },
        body: json.encode(currentPosts.map((p) => p.toJson()).toList()),
      ).timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  /// Toggles user agreement ("সহমত") on a post
  Future<void> toggleAgree(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final posts = await fetchPosts();
    final post = posts.firstWhere((p) => p.id == postId, orElse: () => posts.first);

    if (post.agreedByMe) {
      post.agreedByMe = false;
      post.agrees = (post.agrees - 1).clamp(0, 9999);
    } else {
      post.agreedByMe = true;
      post.agrees += 1;
    }

    await prefs.setString(
      _storageKey,
      json.encode(posts.map((p) => p.toJson()).toList()),
    );
  }

  /// Adds a comment to a post
  Future<void> addComment(String postId, PostComment comment) async {
    final prefs = await SharedPreferences.getInstance();
    final posts = await fetchPosts();
    final post = posts.firstWhere((p) => p.id == postId, orElse: () => posts.first);
    post.comments.add(comment);

    await prefs.setString(
      _storageKey,
      json.encode(posts.map((p) => p.toJson()).toList()),
    );
  }

  List<CommunityPost> _getSeedPosts() {
    return [
      CommunityPost(
        id: '1',
        reporterName: 'তানভীর আহমেদ',
        avatarStyle: 'avatar-1',
        badge: 'ভেরিফাইড ক্রেতা',
        item: 'দেশি পেঁয়াজ',
        shop: 'ভাই ভাই স্টোর (দোকান নং ৪২)',
        area: 'সাহেব বাজার, রাজশাহী',
        chargedPrice: 95.0,
        fairPrice: 78.0,
        unit: 'কেজি',
        type: 'overcharge',
        description: 'সরকারি ন্যায্য মূল্য ৭৮ টাকা হলেও দোকানে ৯৫ টাকা দাবি করছে। অতিরিক্ত দাম নেওয়া হচ্ছে।',
        imageUrl: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80',
        time: '১৫ মিনিট আগে',
        agrees: 28,
        agreedByMe: false,
        comments: [
          PostComment(author: 'মাহমুদ হাসান', text: 'হ্যাঁ, আমি গতকাল গিয়েছিলাম একই অবস্থা।', time: '১০ মিনিট আগে'),
          PostComment(author: 'আরিফুল ইসলাম', text: 'পাশের গলির জনতা ট্রেডার্সে ৮০ টাকায় দিচ্ছে।', time: '৫ মিনিট আগে'),
        ],
      ),
      CommunityPost(
        id: '2',
        reporterName: 'রাবেয়া সুলতানা',
        avatarStyle: 'avatar-3',
        badge: 'সচেতন নাগরিক',
        item: 'সয়াবিন তেল (৫ লিটার)',
        shop: 'জনতা জেনারেল স্টোর',
        area: 'কারওয়ান বাজার, ঢাকা',
        chargedPrice: 810.0,
        fairPrice: 818.0,
        unit: 'বোতল',
        type: 'fair',
        description: 'এখানে সরকারি নির্ধারিত মূল্যের চেয়েও ৮ টাকা কমে ফ্রেশ সয়াবিন তেল পাওয়া যাচ্ছে। স্টক সীমিত!',
        imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600&auto=format&fit=crop&q=80',
        time: '১ ঘণ্টা আগে',
        agrees: 45,
        agreedByMe: true,
        comments: [
          PostComment(author: 'কামরুল আহসান', text: 'ধন্যবাদ তথ্যের জন্য!', time: '৪০ মিনিট আগে'),
        ],
      ),
      CommunityPost(
        id: '3',
        reporterName: 'সোহেল রানা',
        avatarStyle: 'avatar-2',
        badge: 'মার্কেট ভলান্টিয়ার',
        item: 'ফার্মের লাল ডিম',
        shop: 'পাইকারি ডিম আড়ত',
        area: 'রিয়াজউদ্দিন বাজার, চট্টগ্রাম',
        chargedPrice: 165.0,
        fairPrice: 152.0,
        unit: 'ডজন',
        type: 'shortage',
        description: 'বৃষ্টির কারণে ডিমের সরবরাহ কিছুটা কম হওয়ায় দাম বেড়েছে। আগামীকাল নতুন চালান আসবে।',
        imageUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=600&auto=format&fit=crop&q=80',
        time: '৩ ঘণ্টা আগে',
        agrees: 19,
        agreedByMe: false,
        comments: [],
      ),
    ];
  }
}

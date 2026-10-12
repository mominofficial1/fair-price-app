import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../providers/app_state_provider.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AppStateProvider>();
    final isBn = provider.isBangla;

    final newsList = [
      {
        'tag': 'DAM প্রজ্ঞাপন',
        'title': 'কৃষি বিপণন অধিদপ্তর কর্তৃক ২৯টি নিত্যপণ্যের যৌক্তিক দাম নির্ধারণ',
        'desc': 'দেশব্যাপী বাজার স্থিতিশীল রাখতে জেলা প্রশাসন ও কৃষি বিপণন অধিদপ্তরের যৌথ মনিটরিং শুরু।',
        'date': '২৪ আগস্ট ২০২৬',
      },
      {
        'tag': 'টিসিবি মনিটরিং',
        'title': 'ন্যায্যমূল্যে টিসিবি ট্রাকসেল কার্যক্রমে তেল, ডাল ও চিনি সরবরাহ বৃদ্ধি',
        'desc': 'সারাদেশের সকল উপজেলা ও পৌরসভায় খোলা ট্রাকে সাশ্রয়ী মূল্যে পণ্য বিক্রয় অব্যাহত।',
        'date': '২৩ আগস্ট ২০২৬',
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          isBn ? 'খবর ও নোটিশ' : 'News & Notices',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          children: [
            ...newsList.map((n) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceRaised : AppColors.damBadgeBg,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        n['tag']!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkPrimaryGreen : AppColors.damBadgeText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      n['title']!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      n['desc']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      n['date']!,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

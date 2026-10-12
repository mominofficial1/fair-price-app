import 'package:flutter/material.dart';
import '../constants/product_images.dart';

/// Ultra-Modern Product Visual Component
/// Renders high-quality photography with caching, shimmer placeholder, and vector fallback
class ProductVisualBadge extends StatelessWidget {
  final String productId;
  final String category;
  final double size;
  final double? borderRadius;

  const ProductVisualBadge({
    super.key,
    required this.productId,
    required this.category,
    this.size = 48.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrl = ProductImageCatalog.getImageUrl(productId);
    final radius = borderRadius ?? (size * 0.28);

    if (imageUrl != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isDark
                ? const Color(0xFF223830)
                : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 1.2),
          child: Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildFallbackVector(context, isDark, radius),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: isDark ? const Color(0xFF162520) : const Color(0xFFF1F5F9),
                child: Center(
                  child: SizedBox(
                    width: size * 0.35,
                    height: size * 0.35,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? const Color(0xFF27C98A) : const Color(0xFF087F5B),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return _buildFallbackVector(context, isDark, radius);
  }

  Widget _buildFallbackVector(BuildContext context, bool isDark, double radius) {
    final id = productId.toLowerCase();

    IconData iconData = Icons.shopping_basket_rounded;
    Color primaryColor = const Color(0xFF10A878);
    Color bgGradientStart = const Color(0xFFE8F5E9);
    Color bgGradientEnd = const Color(0xFFC8E6C9);

    if (id.contains('miniket') || id.contains('nazir') || id.contains('rice') || id.contains('chinigura')) {
      iconData = Icons.grass_rounded;
      primaryColor = const Color(0xFF2E7D32);
      bgGradientStart = isDark ? const Color(0xFF1B2E1E) : const Color(0xFFE8F5E9);
      bgGradientEnd = isDark ? const Color(0xFF112013) : const Color(0xFFC8E6C9);
    } else if (id.contains('onion') || id.contains('potato') || id.contains('garlic') || id.contains('ginger') || id.contains('tomato') || id.contains('chili') || id.contains('eggplant') || category == 'vegetables') {
      iconData = Icons.eco_rounded;
      primaryColor = const Color(0xFF388E3C);
      bgGradientStart = isDark ? const Color(0xFF182D1E) : const Color(0xFFE8F8F0);
      bgGradientEnd = isDark ? const Color(0xFF0F1E14) : const Color(0xFFC8E6C9);
    } else if (id.contains('ilish') || id.contains('rui') || id.contains('fish') || id.contains('prawn') || id.contains('shrimp')) {
      iconData = Icons.water_drop_rounded;
      primaryColor = const Color(0xFF0288D1);
      bgGradientStart = isDark ? const Color(0xFF152838) : const Color(0xFFE1F5FE);
      bgGradientEnd = isDark ? const Color(0xFF0D1B26) : const Color(0xFFB3E5FC);
    } else if (id.contains('chicken') || id.contains('beef') || id.contains('mutton') || category == 'meat_fish') {
      iconData = Icons.lunch_dining_rounded;
      primaryColor = const Color(0xFFD32F2F);
      bgGradientStart = isDark ? const Color(0xFF381A1A) : const Color(0xFFFFEBEE);
      bgGradientEnd = isDark ? const Color(0xFF261010) : const Color(0xFFFFCDD2);
    } else if (id.contains('egg') || id.contains('milk') || category == 'dairy_eggs') {
      iconData = Icons.egg_rounded;
      primaryColor = const Color(0xFFFFA000);
      bgGradientStart = isDark ? const Color(0xFF382E14) : const Color(0xFFFFF8E1);
      bgGradientEnd = isDark ? const Color(0xFF261F0A) : const Color(0xFFFFECB3);
    } else if (id.contains('oil') || id.contains('salt') || id.contains('spice') || category == 'oil_spices') {
      iconData = Icons.local_fire_department_rounded;
      primaryColor = const Color(0xFFE65100);
      bgGradientStart = isDark ? const Color(0xFF382312) : const Color(0xFFFFF3E0);
      bgGradientEnd = isDark ? const Color(0xFF26170A) : const Color(0xFFFFE0B2);
    } else if (id.contains('dal') || category == 'lentils') {
      iconData = Icons.scatter_plot_rounded;
      primaryColor = const Color(0xFFFBC02D);
      bgGradientStart = isDark ? const Color(0xFF332B12) : const Color(0xFFFFFDE7);
      bgGradientEnd = isDark ? const Color(0xFF211B08) : const Color(0xFFFFF9C4);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgGradientStart, bgGradientEnd],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Center(
        child: Icon(
          iconData,
          size: size * 0.52,
          color: primaryColor,
        ),
      ),
    );
  }
}

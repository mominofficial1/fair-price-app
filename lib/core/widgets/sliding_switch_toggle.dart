import 'package:flutter/material.dart';

/// Modern Animated Sliding Pill Switch Widget
/// Provides a sleek segmented slider for Language (🇧🇩 বাংলা / 🇬🇧 EN) & Theme (☀️ Light / 🌙 Dark)
class ModernSlidingSwitch<T> extends StatelessWidget {
  final T selectedValue;
  final List<SlidingOption<T>> options;
  final ValueChanged<T> onChanged;
  final double height;
  final double? width;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;

  const ModernSlidingSwitch({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.height = 38.0,
    this.width,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = backgroundColor ??
        (isDark ? const Color(0xFF162520) : const Color(0xFFE6F4EA));
    final thumbColor = activeColor ??
        (isDark ? const Color(0xFF10A878) : const Color(0xFF087F5B));

    final selectedIndex = options.indexWhere((opt) => opt.value == selectedValue);
    final validIndex = selectedIndex >= 0 ? selectedIndex : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = width ?? constraints.maxWidth;
        final optionWidth = (totalWidth - 6) / options.length;

        return Container(
          width: totalWidth,
          height: height,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: isDark ? const Color(0xFF223830) : const Color(0xFFCEEBD9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Animated Sliding Thumb
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOutCubic,
                left: validIndex * optionWidth,
                top: 0,
                bottom: 0,
                width: optionWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: thumbColor,
                    borderRadius: BorderRadius.circular((height - 6) / 2),
                    boxShadow: [
                      BoxShadow(
                        color: thumbColor.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Segment Items
              Row(
                children: options.map((option) {
                  final isSelected = option.value == selectedValue;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(option.value),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (option.icon != null) ...[
                              Icon(
                                option.icon,
                                size: 14,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : const Color(0xFF4A5568)),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              option.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : const Color(0xFF4A5568)),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SlidingOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SlidingOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

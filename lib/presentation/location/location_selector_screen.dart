import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/datasources/location_datasource.dart';
import '../providers/app_state_provider.dart';

class LocationSelectorScreen extends StatefulWidget {
  const LocationSelectorScreen({super.key});

  @override
  State<LocationSelectorScreen> createState() => _LocationSelectorScreenState();
}

class _LocationSelectorScreenState extends State<LocationSelectorScreen> {
  String _selectedDivId = 'rajshahi';
  String _selectedMarketId = 'rajshahi_shaheb_bazar';

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppStateProvider>();
    _selectedDivId = provider.selectedDivision;
    _selectedMarketId = provider.currentMarket.id;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AppStateProvider>();
    final isBn = provider.isBangla;
    final loc = AppLocalizations.of(context);

    final filteredMarkets = LocationDataSource.markets
        .where((m) => m.divisionId == _selectedDivId)
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          loc.locationSelectorTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          children: [
            Text(
              loc.locationSelectorSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),

            // GPS Auto-detect Button
            ElevatedButton.icon(
              onPressed: () {
                provider.selectMarket('rajshahi_shaheb_bazar');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isBn ? '📍 GPS অবস্থান শনাক্ত হয়েছে: সাহেব বাজার' : '📍 GPS Auto-detected: Shaheb Bazar'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.my_location_rounded, size: 18),
              label: Text(loc.useCurrentGps),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkSurfaceRaised : Colors.white,
                foregroundColor: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 24),

            // Saved Places
            Text(
              loc.savedLocations,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 10),
            ...LocationDataSource.defaultSavedPlaces.map((p) {
              final isCurrent = p.marketId == provider.currentMarket.id;
              return Card(
                color: isDark ? AppColors.darkSurface : Colors.white,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isCurrent
                        ? (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen)
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                    width: isCurrent ? 1.5 : 1.0,
                  ),
                ),
                child: ListTile(
                  dense: true,
                  title: Text(
                    isBn ? p.labelBn : p.labelEn,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  trailing: isCurrent
                      ? Text(
                          isBn ? '✓ সক্রিয়' : 'Active',
                          style: TextStyle(
                            color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        )
                      : const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {
                    provider.selectMarket(p.marketId);
                    Navigator.of(context).pop();
                  },
                ),
              );
            }),
            const SizedBox(height: 24),

            // 4-Tier Cascaded Hierarchy Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🗺️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        isBn ? 'বিভাগভিত্তিক বাজার নির্বাচন (DAM)' : 'Division & Market Selector (DAM)',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Division Chips Horizontal List
                  Text(
                    loc.selectDivision,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: LocationDataSource.divisions.map((d) {
                        final isSelected = d.id == _selectedDivId;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(isBn ? d.nameBn : d.nameEn),
                            selected: isSelected,
                            selectedColor: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                            backgroundColor: isDark ? AppColors.darkSurfaceRaised : AppColors.softMint,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? (isDark ? Colors.black : Colors.white)
                                  : (isDark ? AppColors.darkTextPrimary : AppColors.darkText),
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedDivId = d.id;
                                  final mList = LocationDataSource.markets
                                      .where((m) => m.divisionId == d.id)
                                      .toList();
                                  if (mList.isNotEmpty) {
                                    _selectedMarketId = mList.first.id;
                                  }
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Market Dropdown
                  Text(
                    loc.selectMarket,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceRaised : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: filteredMarkets.any((m) => m.id == _selectedMarketId)
                            ? _selectedMarketId
                            : (filteredMarkets.isNotEmpty ? filteredMarkets.first.id : null),
                        isExpanded: true,
                        dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                        items: filteredMarkets.map((m) {
                          return DropdownMenuItem<String>(
                            value: m.id,
                            child: Text(
                              isBn ? m.nameBn : m.nameEn,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedMarketId = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Button
                  ElevatedButton(
                    onPressed: () {
                      provider.selectMarket(_selectedMarketId);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isBn ? 'এই বাজারের দর দেখুন' : 'View Market Prices'),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

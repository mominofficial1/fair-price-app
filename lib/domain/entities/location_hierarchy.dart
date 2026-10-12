class Division {
  final String id;
  final String nameBn;
  final String nameEn;

  const Division({
    required this.id,
    required this.nameBn,
    required this.nameEn,
  });
}

class District {
  final String id;
  final String divisionId;
  final String nameBn;
  final String nameEn;

  const District({
    required this.id,
    required this.divisionId,
    required this.nameBn,
    required this.nameEn,
  });
}

class Upazila {
  final String id;
  final String districtId;
  final String nameBn;
  final String nameEn;

  const Upazila({
    required this.id,
    required this.districtId,
    required this.nameBn,
    required this.nameEn,
  });
}

class MarketLocation {
  final String id;
  final String divisionId;
  final String districtId;
  final String upazilaId;
  final String nameBn;
  final String nameEn;
  final double priceModifier;
  final double? latitude;
  final double? longitude;

  const MarketLocation({
    required this.id,
    required this.divisionId,
    required this.districtId,
    required this.upazilaId,
    required this.nameBn,
    required this.nameEn,
    this.priceModifier = 1.0,
    this.latitude,
    this.longitude,
  });
}

class SavedPlace {
  final String id;
  final String labelBn;
  final String labelEn;
  final String marketId;

  const SavedPlace({
    required this.id,
    required this.labelBn,
    required this.labelEn,
    required this.marketId,
  });
}

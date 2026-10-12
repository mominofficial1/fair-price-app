import '../../domain/entities/location_hierarchy.dart';

class LocationDataSource {
  static const List<Division> divisions = [
    Division(id: 'dhaka', nameBn: 'ঢাকা', nameEn: 'Dhaka'),
    Division(id: 'chattogram', nameBn: 'চট্টগ্রাম', nameEn: 'Chattogram'),
    Division(id: 'rajshahi', nameBn: 'রাজশাহী', nameEn: 'Rajshahi'),
    Division(id: 'khulna', nameBn: 'খুলনা', nameEn: 'Khulna'),
    Division(id: 'barishal', nameBn: 'বরিশাল', nameEn: 'Barishal'),
    Division(id: 'sylhet', nameBn: 'সিলেট', nameEn: 'Sylhet'),
    Division(id: 'rangpur', nameBn: 'রংপুর', nameEn: 'Rangpur'),
    Division(id: 'mymensingh', nameBn: 'ময়মনসিংহ', nameEn: 'Mymensingh'),
  ];

  static const List<District> districts = [
    District(id: 'dhaka_dist', divisionId: 'dhaka', nameBn: 'ঢাকা জেলা', nameEn: 'Dhaka District'),
    District(id: 'gazipur', divisionId: 'dhaka', nameBn: 'গাজীপুর', nameEn: 'Gazipur'),
    District(id: 'narayanganj', divisionId: 'dhaka', nameBn: 'নারায়ণগঞ্জ', nameEn: 'Narayanganj'),
    District(id: 'rajshahi_dist', divisionId: 'rajshahi', nameBn: 'রাজশাহী জেলা', nameEn: 'Rajshahi District'),
    District(id: 'bogura', divisionId: 'rajshahi', nameBn: 'বগুড়া', nameEn: 'Bogura'),
    District(id: 'pabna', divisionId: 'rajshahi', nameBn: 'পাবনা', nameEn: 'Pabna'),
    District(id: 'ctg_dist', divisionId: 'chattogram', nameBn: 'চট্টগ্রাম জেলা', nameEn: 'Chattogram District'),
    District(id: 'coxsbazar', divisionId: 'chattogram', nameBn: 'কক্সবাজার', nameEn: "Cox's Bazar"),
    District(id: 'khulna_dist', divisionId: 'khulna', nameBn: 'খুলনা জেলা', nameEn: 'Khulna District'),
    District(id: 'jashore', divisionId: 'khulna', nameBn: 'যশোর', nameEn: 'Jashore'),
    District(id: 'sylhet_dist', divisionId: 'sylhet', nameBn: 'সিলেট জেলা', nameEn: 'Sylhet District'),
    District(id: 'barishal_dist', divisionId: 'barishal', nameBn: 'বরিশাল জেলা', nameEn: 'Barishal District'),
    District(id: 'rangpur_dist', divisionId: 'rangpur', nameBn: 'রংপুর জেলা', nameEn: 'Rangpur District'),
    District(id: 'mymensingh_dist', divisionId: 'mymensingh', nameBn: 'ময়মনসিংহ জেলা', nameEn: 'Mymensingh District'),
  ];

  static const List<MarketLocation> markets = [
    // Dhaka
    MarketLocation(
      id: 'dhaka_karwan_bazar',
      divisionId: 'dhaka',
      districtId: 'dhaka_dist',
      upazilaId: 'tejgaon',
      nameBn: 'কারওয়ান বাজার, ঢাকা',
      nameEn: 'Karwan Bazar, Dhaka',
      priceModifier: 1.05,
    ),
    MarketLocation(
      id: 'dhaka_mirpur_1',
      divisionId: 'dhaka',
      districtId: 'dhaka_dist',
      upazilaId: 'mirpur',
      nameBn: 'মিরপুর ১ কাঁচাবাজার, ঢাকা',
      nameEn: 'Mirpur 1 Kacha Bazar, Dhaka',
      priceModifier: 1.03,
    ),
    MarketLocation(
      id: 'dhaka_shyam_bazar',
      divisionId: 'dhaka',
      districtId: 'dhaka_dist',
      upazilaId: 'kotwali',
      nameBn: 'শ্যামবাজার (পাইকারি), ঢাকা',
      nameEn: 'Shyambazar Wholesale, Dhaka',
      priceModifier: 0.96,
    ),

    // Rajshahi
    MarketLocation(
      id: 'rajshahi_shaheb_bazar',
      divisionId: 'rajshahi',
      districtId: 'rajshahi_dist',
      upazilaId: 'boalia',
      nameBn: 'সাহেব বাজার, রাজশাহী',
      nameEn: 'Shaheb Bazar, Rajshahi',
      priceModifier: 1.00,
    ),
    MarketLocation(
      id: 'rajshahi_naodapara',
      divisionId: 'rajshahi',
      districtId: 'rajshahi_dist',
      upazilaId: 'shah_makhdum',
      nameBn: 'নওদাপাড়া বাজার, রাজশাহী',
      nameEn: 'Naodapara Bazar, Rajshahi',
      priceModifier: 1.04,
    ),
    MarketLocation(
      id: 'rajshahi_binodpur',
      divisionId: 'rajshahi',
      districtId: 'rajshahi_dist',
      upazilaId: 'motihar',
      nameBn: 'বিনোদপুর বাজার, রাজশাহী',
      nameEn: 'Binodpur Bazar, Rajshahi',
      priceModifier: 1.02,
    ),

    // Chattogram
    MarketLocation(
      id: 'ctg_reazuddin_bazar',
      divisionId: 'chattogram',
      districtId: 'ctg_dist',
      upazilaId: 'kotwali',
      nameBn: 'রিয়াজউদ্দিন বাজার, চট্টগ্রাম',
      nameEn: 'Reazuddin Bazar, Chattogram',
      priceModifier: 1.04,
    ),
    MarketLocation(
      id: 'ctg_chawkbazar',
      divisionId: 'chattogram',
      districtId: 'ctg_dist',
      upazilaId: 'chawkbazar',
      nameBn: 'চকবাজার, চট্টগ্রাম',
      nameEn: 'Chawkbazar, Chattogram',
      priceModifier: 1.06,
    ),

    // Khulna
    MarketLocation(
      id: 'khulna_boro_bazar',
      divisionId: 'khulna',
      districtId: 'khulna_dist',
      upazilaId: 'khulna_sadar',
      nameBn: 'বড় বাজার, খুলনা',
      nameEn: 'Boro Bazar, Khulna',
      priceModifier: 0.98,
    ),

    // Sylhet
    MarketLocation(
      id: 'sylhet_bandar_bazar',
      divisionId: 'sylhet',
      districtId: 'sylhet_dist',
      upazilaId: 'sylhet_sadar',
      nameBn: 'বন্দর বাজার, সিলেট',
      nameEn: 'Bandar Bazar, Sylhet',
      priceModifier: 1.07,
    ),

    // Barishal
    MarketLocation(
      id: 'barishal_port_road',
      divisionId: 'barishal',
      districtId: 'barishal_dist',
      upazilaId: 'barishal_sadar',
      nameBn: 'পোর্ট রোড বাজার, বরিশাল',
      nameEn: 'Port Road Bazar, Barishal',
      priceModifier: 0.97,
    ),

    // Rangpur
    MarketLocation(
      id: 'rangpur_city_bazar',
      divisionId: 'rangpur',
      districtId: 'rangpur_dist',
      upazilaId: 'rangpur_sadar',
      nameBn: 'সিটি বাজার, রংপুর',
      nameEn: 'City Bazar, Rangpur',
      priceModifier: 0.95,
    ),

    // Mymensingh
    MarketLocation(
      id: 'mymensingh_mechua',
      divisionId: 'mymensingh',
      districtId: 'mymensingh_dist',
      upazilaId: 'mymensingh_sadar',
      nameBn: 'মেছুয়া বাজার, ময়মনসিংহ',
      nameEn: 'Mechua Bazar, Mymensingh',
      priceModifier: 0.99,
    ),
  ];

  static const List<SavedPlace> defaultSavedPlaces = [
    SavedPlace(id: 'home', labelBn: 'বাড়ি (সাহেব বাজার)', labelEn: 'Home (Shaheb Bazar)', marketId: 'rajshahi_shaheb_bazar'),
    SavedPlace(id: 'work', labelBn: 'অফিস (কারওয়ান বাজার)', labelEn: 'Work (Karwan Bazar)', marketId: 'dhaka_karwan_bazar'),
    SavedPlace(id: 'favorite', labelBn: 'নিজস্ব বাজার (রিয়াজউদ্দিন বাজার)', labelEn: 'Favorite (Reazuddin Bazar)', marketId: 'ctg_reazuddin_bazar'),
  ];

  static MarketLocation? getLocationById(String id) {
    try {
      return markets.firstWhere((m) => m.id == id);
    } catch (_) {
      return markets.first;
    }
  }
}

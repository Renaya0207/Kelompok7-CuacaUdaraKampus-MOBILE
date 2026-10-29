import 'package:flutter/foundation.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../repositories/weather_repository.dart';
import 'dart:async';

class CampusCity {
  final String name;
  final String province;
  final double latitude;
  final double longitude;

  const CampusCity({
    required this.name,
    required this.province,
    required this.latitude,
    required this.longitude,
  });
}

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel({WeatherRepository? repository})
      : _repository = repository ?? OpenMeteoWeatherRepository(service: WeatherService());

  final WeatherRepository _repository;
  int _requestNumber = 0;

  final List<CampusCity> cities = const [
    // Kalimantan
    CampusCity(name: 'Balikpapan', province: 'Kalimantan Timur', latitude: -1.2379, longitude: 116.8529),
    CampusCity(name: 'Samarinda', province: 'Kalimantan Timur', latitude: -0.5022, longitude: 117.1537),
    CampusCity(name: 'Tanjung Selor', province: 'Kalimantan Utara', latitude: 2.8375, longitude: 117.3653),
    CampusCity(name: 'Tarakan', province: 'Kalimantan Utara', latitude: 3.3000, longitude: 117.6333),
    CampusCity(name: 'Banjarmasin', province: 'Kalimantan Selatan', latitude: -3.3194, longitude: 114.5908),
    CampusCity(name: 'Pontianak', province: 'Kalimantan Barat', latitude: -0.0263, longitude: 109.3425),
    CampusCity(name: 'Palangka Raya', province: 'Kalimantan Tengah', latitude: -2.2096, longitude: 113.9213),
    // Sumatra
    CampusCity(name: 'Medan', province: 'Sumatera Utara', latitude: 3.5952, longitude: 98.6722),
    CampusCity(name: 'Banda Aceh', province: 'Aceh', latitude: 5.5483, longitude: 95.3238),
    CampusCity(name: 'Padang', province: 'Sumatera Barat', latitude: -0.9471, longitude: 100.4172),
    CampusCity(name: 'Pekanbaru', province: 'Riau', latitude: 0.5071, longitude: 101.4478),
    CampusCity(name: 'Palembang', province: 'Sumatera Selatan', latitude: -2.9761, longitude: 104.7754),
    // Java and Bali
    CampusCity(name: 'Jakarta', province: 'DKI Jakarta', latitude: -6.2088, longitude: 106.8456),
    CampusCity(name: 'Bandung', province: 'Jawa Barat', latitude: -6.9175, longitude: 107.6191),
    CampusCity(name: 'Semarang', province: 'Jawa Tengah', latitude: -6.9667, longitude: 110.4167),
    CampusCity(name: 'Yogyakarta', province: 'DI Yogyakarta', latitude: -7.7956, longitude: 110.3695),
    CampusCity(name: 'Surabaya', province: 'Jawa Timur', latitude: -7.2575, longitude: 112.7521),
    CampusCity(name: 'Denpasar', province: 'Bali', latitude: -8.6705, longitude: 115.2126),
    // Sulawesi
    CampusCity(name: 'Makassar', province: 'Sulawesi Selatan', latitude: -5.1477, longitude: 119.4327),
    CampusCity(name: 'Manado', province: 'Sulawesi Utara', latitude: 1.4748, longitude: 124.8421),
    // Nusa Tenggara, Maluku, Papua
    CampusCity(name: 'Mataram', province: 'Nusa Tenggara Barat', latitude: -8.5833, longitude: 116.1167),
    CampusCity(name: 'Kupang', province: 'Nusa Tenggara Timur', latitude: -10.1772, longitude: 123.6070),
    CampusCity(name: 'Ambon', province: 'Maluku', latitude: -3.6954, longitude: 128.1814),
    CampusCity(name: 'Jayapura', province: 'Papua', latitude: -2.5916, longitude: 140.6690),
  ];

  CampusCity selectedCity = const CampusCity(
    name: 'Jakarta', province: 'DKI Jakarta', latitude: -6.2088, longitude: 106.8456,
  );

  WeatherModel? weather;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadWeather({bool showLoading = true}) async {
    final request = ++_requestNumber;
    if (showLoading || weather == null) isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _repository.fetch(CampusWeatherLocation(
        name: selectedCity.name,
        latitude: selectedCity.latitude,
        longitude: selectedCity.longitude,
      ));
      if (request != _requestNumber) return;
      weather = result;
    } catch (error) {
      if (request != _requestNumber) return;
      if (error is TimeoutException) {
        errorMessage = 'Server cuaca terlalu lama merespons. Coba lagi.';
      } else if (error is ApiException && error.statusCode >= 500) {
        errorMessage = 'Server cuaca sedang bermasalah. Coba lagi nanti.';
      } else if (error is FormatException) {
        errorMessage = 'Data cuaca tidak dapat dibaca. Coba lagi.';
      } else {
        errorMessage = 'Cuaca belum bisa dimuat. Periksa koneksi internet.';
      }
    } finally {
      if (request == _requestNumber) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> selectCity(CampusCity city) async {
    if (city.name == selectedCity.name) return;
    selectedCity = city;
    notifyListeners();
    await loadWeather();
  }

  @override
  void dispose() {
    _requestNumber++;
    super.dispose();
  }

  List<CampusCity> searchCities(String query) {
    return cities.where((city) {
      return city.name.toLowerCase().contains(query.toLowerCase()) ||
          city.province.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
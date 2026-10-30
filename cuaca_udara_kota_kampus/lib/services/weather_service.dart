import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  const ApiException(this.statusCode);
}

class WeatherService {
  WeatherService({http.Client? client, this.timeout = const Duration(seconds: 10)})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String airQualityHost = 'air-quality-api.open-meteo.com';

  Future<Map<String, dynamic>> fetchForecast({required double latitude, required double longitude}) {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });
    return _getJson(uri, 'cuaca');
  }

  /// Kualitas udara saat ini (US AQI dan konsentrasi polutan utama).
  Future<Map<String, dynamic>> fetchAirQuality({required double latitude, required double longitude}) {
    final uri = Uri.https(airQualityHost, '/v1/air-quality', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current': 'us_aqi,pm2_5,pm10,ozone,nitrogen_dioxide,sulphur_dioxide,carbon_monoxide',
      'timezone': 'auto',
    });
    return _getJson(uri, 'kualitas udara');
  }

  Future<Map<String, dynamic>> _getJson(Uri uri, String label) async {
    final response = await _client.get(uri, headers: {'Accept': 'application/json'}).timeout(timeout);
    if (response.statusCode != 200) throw ApiException(response.statusCode);
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is Map<String, dynamic>) return decoded;
    throw FormatException('Format data $label tidak dikenal.');
  }

  void close() => _client.close();
}

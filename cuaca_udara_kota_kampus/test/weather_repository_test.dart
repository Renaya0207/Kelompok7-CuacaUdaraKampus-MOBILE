import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:udara_kampus/repositories/weather_repository.dart';
import 'package:udara_kampus/services/weather_service.dart';

const _jakarta = CampusWeatherLocation(
  name: 'Jakarta', latitude: -6.2088, longitude: 106.8456,
);

Map<String, dynamic> _forecastJson() {
  final dates = List.generate(7, (i) => DateTime(2026, 10, 30 + i).toIso8601String().substring(0, 10));
  return {
    'current': {
      'time': '2026-10-30T12:00',
      'temperature_2m': 29.5,
      'apparent_temperature': 33.0,
      'relative_humidity_2m': 75,
      'weather_code': 3,
      'wind_speed_10m': 8.0,
    },
    'daily': {
      'time': dates,
      'weather_code': List.filled(7, 3),
      'temperature_2m_max': List.filled(7, 32.0),
      'temperature_2m_min': List.filled(7, 24.0),
      'precipitation_probability_max': List.filled(7, 30),
    },
  };
}

Map<String, dynamic> _airJson() => {
      'current': {
        'time': '2026-10-30T12:00',
        'us_aqi': 87,
        'pm2_5': 28.4,
        'pm10': 40.1,
        'ozone': 55.0,
        'nitrogen_dioxide': 12.0,
        'sulphur_dioxide': 6.5,
        'carbon_monoxide': 310.0,
      },
    };

void main() {
  test('repository membaca cuaca saat ini dan prakiraan tujuh hari', () async {
    final client = MockClient((request) async {
      if (request.url.host == WeatherService.airQualityHost) {
        return http.Response(jsonEncode(_airJson()), 200);
      }
      expect(request.url.queryParameters['forecast_days'], '7');
      expect(request.url.queryParameters.containsKey('daily'), isTrue);
      return http.Response(jsonEncode(_forecastJson()), 200);
    });
    final repository = OpenMeteoWeatherRepository(
      service: WeatherService(client: client),
    );
    final result = await repository.fetch(_jakarta);

    expect(result.city, 'Jakarta');
    expect(result.temperature, 29.5);
    expect(result.forecast.length, 7);
    expect(result.forecast.first.maxTemperature, 32.0);
    expect(result.forecast.first.precipitationProbability, 30);
    client.close();
  });

  test('repository membaca kualitas udara', () async {
    final client = MockClient((request) async {
      if (request.url.host == WeatherService.airQualityHost) {
        expect(request.url.path, '/v1/air-quality');
        expect(request.url.queryParameters['current'], contains('us_aqi'));
        return http.Response(jsonEncode(_airJson()), 200);
      }
      return http.Response(jsonEncode(_forecastJson()), 200);
    });
    final repository = OpenMeteoWeatherRepository(
      service: WeatherService(client: client),
    );
    final result = await repository.fetch(_jakarta);

    expect(result.airQuality, isNotNull);
    expect(result.airQuality!.usAqi, 87);
    expect(result.airQuality!.pm25, 28.4);
    expect(result.airQuality!.pm10, 40.1);
    client.close();
  });

  test('cuaca tetap dimuat saat API kualitas udara gagal', () async {
    final client = MockClient((request) async {
      if (request.url.host == WeatherService.airQualityHost) {
        return http.Response('error', 500);
      }
      return http.Response(jsonEncode(_forecastJson()), 200);
    });
    final repository = OpenMeteoWeatherRepository(
      service: WeatherService(client: client),
    );
    final result = await repository.fetch(_jakarta);

    expect(result.temperature, 29.5);
    expect(result.airQuality, isNull);
    client.close();
  });
}

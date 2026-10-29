import 'air_quality_model.dart';

class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;
  final int? precipitationProbability;

  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
    required this.precipitationProbability,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json, int index) {
    final times = json['time'] as List<dynamic>;
    final codes = json['weather_code'] as List<dynamic>;
    final max = json['temperature_2m_max'] as List<dynamic>;
    final min = json['temperature_2m_min'] as List<dynamic>;
    final rain = json['precipitation_probability_max'] as List<dynamic>;
    return DailyForecast(
      date: DateTime.parse(times[index] as String),
      weatherCode: (codes[index] as num).toInt(),
      maxTemperature: (max[index] as num).toDouble(),
      minTemperature: (min[index] as num).toDouble(),
      precipitationProbability: (rain[index] as num?)?.toInt(),
    );
  }

  String get description => weatherDescription(weatherCode);
  String get emoji => weatherEmoji(weatherCode);
}

String weatherDescription(int code) {
  if (code == 0) return 'Cerah';
  if (code == 1 || code == 2) return 'Cerah berawan';
  if (code == 3) return 'Berawan';
  if (code == 45 || code == 48) return 'Berkabut';
  if (code >= 51 && code <= 57) return 'Gerimis';
  if ([61, 63, 65, 66, 67, 80, 81, 82].contains(code)) return 'Hujan';
  if ([71, 73, 75, 77, 85, 86].contains(code)) return 'Salju';
  if (code >= 95 && code <= 99) return 'Badai petir';
  return 'Kondisi tidak diketahui';
}

String weatherEmoji(int code) {
  if (code == 0) return '☀️';
  if (code == 1 || code == 2) return '🌤️';
  if (code == 3) return '☁️';
  if (code == 45 || code == 48) return '🌫️';
  if (code >= 95 && code <= 99) return '⛈️';
  if (code >= 51 && code <= 82) return '🌧️';
  return '🌦️';
}

class WeatherModel {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final String city;
  final String updatedAt;
  final List<DailyForecast> forecast;

  /// Kualitas udara; `null` bila datanya belum tersedia.
  final AirQuality? airQuality;

  const WeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.city,
    required this.updatedAt,
    required this.forecast,
    this.airQuality,
  });

  String get description => weatherDescription(weatherCode);
  String get emoji => weatherEmoji(weatherCode);

  WeatherModel withAirQuality(AirQuality? air) => WeatherModel(
        temperature: temperature,
        feelsLike: feelsLike,
        humidity: humidity,
        windSpeed: windSpeed,
        weatherCode: weatherCode,
        city: city,
        updatedAt: updatedAt,
        forecast: forecast,
        airQuality: air,
      );

  factory WeatherModel.fromJson(Map<String, dynamic> json, String city) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    final times = daily['time'] as List<dynamic>;
    final codes = daily['weather_code'] as List<dynamic>;
    final max = daily['temperature_2m_max'] as List<dynamic>;
    final min = daily['temperature_2m_min'] as List<dynamic>;
    final rain = daily['precipitation_probability_max'] as List<dynamic>;
    final count = times.length;
    if (codes.length != count || max.length != count || min.length != count || rain.length != count) {
      throw const FormatException('Panjang data prakiraan harian tidak sama.');
    }
    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      city: city,
      updatedAt: current['time']?.toString() ?? '',
      forecast: List.generate(count, (i) => DailyForecast.fromJson(daily, i)),
    );
  }
}

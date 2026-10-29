import '../models/air_quality_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

abstract class WeatherRepository {
  Future<WeatherModel> fetch(CampusWeatherLocation city);
}

class CampusWeatherLocation {
  final String name;
  final double latitude;
  final double longitude;
  const CampusWeatherLocation({required this.name, required this.latitude, required this.longitude});
}

class OpenMeteoWeatherRepository implements WeatherRepository {
  final WeatherService service;
  const OpenMeteoWeatherRepository({required this.service});

  @override
  Future<WeatherModel> fetch(CampusWeatherLocation city) async {
    // Kualitas udara dimuat paralel dengan cuaca. Kegagalannya tidak boleh
    // menggagalkan cuaca, sehingga galatnya diubah menjadi `null`.
    final airFuture = _fetchAirQuality(city);
    final json = await service.fetchForecast(latitude: city.latitude, longitude: city.longitude);
    final weather = WeatherModel.fromJson(json, city.name);
    return weather.withAirQuality(await airFuture);
  }

  Future<AirQuality?> _fetchAirQuality(CampusWeatherLocation city) async {
    try {
      final json = await service.fetchAirQuality(latitude: city.latitude, longitude: city.longitude);
      final air = AirQuality.fromJson(json);
      return air.hasData ? air : null;
    } catch (_) {
      return null;
    }
  }
}

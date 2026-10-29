/// Data kualitas udara saat ini dari Open-Meteo Air Quality API.
///
/// Semua nilai bersifat opsional karena API dapat mengembalikan `null`
/// untuk lokasi yang belum memiliki data.
class AirQuality {
  /// Indeks kualitas udara standar US EPA (0–500).
  final int? usAqi;

  /// Konsentrasi polutan dalam µg/m³.
  final double? pm25;
  final double? pm10;
  final double? ozone;
  final double? nitrogenDioxide;
  final double? sulphurDioxide;
  final double? carbonMonoxide;

  final String updatedAt;

  const AirQuality({
    required this.usAqi,
    required this.pm25,
    required this.pm10,
    required this.ozone,
    required this.nitrogenDioxide,
    required this.sulphurDioxide,
    required this.carbonMonoxide,
    required this.updatedAt,
  });

  /// True bila ada setidaknya satu nilai yang bisa ditampilkan.
  bool get hasData => usAqi != null || pm25 != null || pm10 != null;

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    if (current is! Map<String, dynamic>) {
      throw const FormatException('Data kualitas udara tidak dikenal.');
    }
    double? number(String key) {
      final value = current[key];
      return value is num ? value.toDouble() : null;
    }

    final aqi = current['us_aqi'];
    return AirQuality(
      usAqi: aqi is num ? aqi.round() : null,
      pm25: number('pm2_5'),
      pm10: number('pm10'),
      ozone: number('ozone'),
      nitrogenDioxide: number('nitrogen_dioxide'),
      sulphurDioxide: number('sulphur_dioxide'),
      carbonMonoxide: number('carbon_monoxide'),
      updatedAt: current['time']?.toString() ?? '',
    );
  }
}

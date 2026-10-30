import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/air_quality_model.dart';
import '../models/weather_model.dart';

// ---------------------------------------------------------------------------
// Ilustrasi kampus
// ---------------------------------------------------------------------------

class CampusIllustration extends StatelessWidget {
  const CampusIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return Container(
      height: 210,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: p.isDark ? p.border : Colors.white.withValues(alpha: 0.85),
          width: 2,
        ),
        boxShadow: p.cardShadow,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: p.isDark
                ? Image.asset(
                    'assets/images/campus_air.png',
                    fit: BoxFit.cover,
                    // Bila aset gagal dimuat, tampilkan ilustrasi vektor.
                    errorBuilder: (_, __, ___) => const _CampusScene(),
                  )
                : const _CampusScene(),
          ),
          // Lapisan gelap tipis di bawah agar teks selalu terbaca.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: p.isDark ? 0.35 : 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: p.isDark
                      ? p.surface.withValues(alpha: 0.92)
                      : Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Kotamu, udaramu 🌿',
                  style: TextStyle(
                    color: p.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampusScene extends StatelessWidget {
  const _CampusScene();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8ED8FF), Color(0xFFD8F4FF), Color(0xFFFFE8B4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 22,
            right: 30,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFFFFF3A6), Color(0xFFFFC857)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x66FFC857),
                    blurRadius: 24,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 20,
            top: 30,
            child: Text('☁️', style: TextStyle(fontSize: 32)),
          ),
          const Positioned(
            right: 105,
            top: 56,
            child: Text('☁️', style: TextStyle(fontSize: 24)),
          ),
          // Bukit
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFB4E889),
                    Color(0xFF65C98A),
                    Color(0xFF319B70),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
              ),
            ),
          ),
          Positioned(bottom: 48, left: 30, child: _tree(44, const Color(0xFF25845D))),
          Positioned(bottom: 46, right: 22, child: _tree(54, const Color(0xFF176B52))),
          // Gedung kampus
          Positioned(
            bottom: 40,
            left: 70,
            right: 70,
            child: Container(
              height: 126,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E9),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(9),
                  bottom: Radius.circular(3),
                ),
                border: Border.all(color: const Color(0xFFB9C9B9), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x44304F42),
                    offset: Offset(0, 6),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0x22304F42),
                    offset: Offset(0, 10),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 26,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF145B48), Color(0xFF218665)],
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(7)),
                    ),
                    child: const Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'UNIVERSITY TOWN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(5, (_) => const _Window()),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...List.generate(2, (_) => const _Window()),
                                Container(
                                  width: 34,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFDBA36A),
                                        Color(0xFFFFD49A),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                    border: Border.fromBorderSide(
                                      BorderSide(
                                        color: Color(0xFFB27C48),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                ...List.generate(2, (_) => const _Window()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 5, color: const Color(0xFFB9C7B6)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tree(double size, Color color) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(color: Color(0x22204C40), offset: Offset(3, 4)),
            ],
          ),
        ),
        Container(width: 9, height: 24, color: const Color(0xFF966641)),
      ],
    );
  }
}

class _Window extends StatelessWidget {
  const _Window();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 22,
      decoration: BoxDecoration(
        color: const Color(0xFF8BD3E8),
        border: Border.all(color: forest, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Judul section
// ---------------------------------------------------------------------------

class SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const SectionHeading({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: p.accentSoft,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: p.accent, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: p.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: p.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Kartu cuaca utama
// ---------------------------------------------------------------------------

List<Color> _heroGradient(int code) {
  if (code >= 95 && code <= 99) {
    return const [Color(0xFF33376B), Color(0xFF555A9C)]; // badai
  }
  if (code >= 51 && code <= 86) {
    return const [Color(0xFF2B5782), Color(0xFF4682B4)]; // hujan / gerimis
  }
  if (code == 3 || code == 45 || code == 48) {
    return const [Color(0xFF3F5868), Color(0xFF5E7B8B)]; // berawan / kabut
  }
  if (code == 1 || code == 2) {
    return const [Color(0xFF1A6F80), Color(0xFF2D93A5)]; // cerah berawan
  }
  return const [forest, Color(0xFF269B79)]; // cerah
}

String _updatedLabel(String raw) {
  final time = DateTime.tryParse(raw);
  if (time == null) return '';
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return 'Diperbarui $h.$m';
}

class WeatherHeroCard extends StatelessWidget {
  final WeatherModel weather;
  final String? subtitle;

  const WeatherHeroCard({super.key, required this.weather, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = _heroGradient(weather.weatherCode);
    final updated = _updatedLabel(weather.updatedAt);
    final rain = weather.forecast.isEmpty
        ? null
        : weather.forecast.first.precipitationProbability;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.30),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              if (updated.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    updated,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${weather.temperature.round()}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 72,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weather.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Terasa seperti ${weather.feelsLike.round()}°C',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(weather.emoji, style: const TextStyle(fontSize: 76)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _WeatherMetric(
                icon: Icons.water_drop_rounded,
                label: 'Lembap',
                value: '${weather.humidity}%',
              ),
              const SizedBox(width: 10),
              _WeatherMetric(
                icon: Icons.air_rounded,
                label: 'Angin',
                value: '${weather.windSpeed.round()} km/j',
              ),
              if (rain != null) ...[
                const SizedBox(width: 10),
                _WeatherMetric(
                  icon: Icons.umbrella_rounded,
                  label: 'Hujan',
                  value: '$rain%',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Prakiraan 7 hari
// ---------------------------------------------------------------------------

class ForecastCard extends StatelessWidget {
  final List<DailyForecast> days;

  const ForecastCard({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    if (days.isEmpty) return const SizedBox.shrink();

    var lo = days.first.minTemperature;
    var hi = days.first.maxTemperature;
    for (final d in days) {
      if (d.minTemperature < lo) lo = d.minTemperature;
      if (d.maxTemperature > hi) hi = d.maxTemperature;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.border),
        boxShadow: p.cardShadow,
      ),
      child: Column(
        children: [
          for (var i = 0; i < days.length; i++) ...[
            _ForecastRow(day: days[i], isToday: i == 0, lo: lo, hi: hi),
            if (i != days.length - 1)
              Divider(height: 1, thickness: 1, color: p.border),
          ],
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final DailyForecast day;
  final bool isToday;
  final double lo;
  final double hi;

  const _ForecastRow({
    required this.day,
    required this.isToday,
    required this.lo,
    required this.hi,
  });

  static const _names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final date =
        '${day.date.day.toString().padLeft(2, '0')}/${day.date.month.toString().padLeft(2, '0')}';
    final rain = day.precipitationProbability == null
        ? 'Peluang hujan —'
        : 'Peluang hujan ${day.precipitationProbability}%';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? 'Hari ini' : _names[day.date.weekday - 1],
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: isToday ? p.accent : p.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: p.textSecondary),
                ),
              ],
            ),
          ),
          Text(day.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rain,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: p.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 84,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${day.maxTemperature.round()}° / ${day.minTemperature.round()}°',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: p.accent,
                  ),
                ),
                const SizedBox(height: 6),
                _RangeBar(
                  min: day.minTemperature,
                  max: day.maxTemperature,
                  lo: lo,
                  hi: hi,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Batang kecil yang menunjukkan rentang suhu harian relatif terhadap
/// rentang seluruh pekan.
class _RangeBar extends StatelessWidget {
  final double min;
  final double max;
  final double lo;
  final double hi;

  const _RangeBar({
    required this.min,
    required this.max,
    required this.lo,
    required this.hi,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final span = (hi - lo) <= 0 ? 1.0 : (hi - lo);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final left = ((min - lo) / span * w).clamp(0.0, w - 6.0).toDouble();
        final width = ((max - min) / span * w).clamp(6.0, w - left).toDouble();

        return SizedBox(
          height: 5,
          width: w,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Positioned(
                left: left,
                width: width,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5BC0DE), orange],
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Kualitas udara
// ---------------------------------------------------------------------------

/// Kategori US AQI beserta warna dan saran singkat untuk mahasiswa.
class AqiLevel {
  final String label;
  final String advice;
  final Color color;
  final Color onColor;

  const AqiLevel(this.label, this.advice, this.color, this.onColor);
}

const List<AqiLevel> _aqiLevels = [
  AqiLevel('Baik', 'Udara bersih. Aman untuk beraktivitas di luar ruangan.',
      Color(0xFF2E9E5B), Colors.white),
  AqiLevel('Sedang', 'Cukup aman. Yang sangat sensitif sebaiknya tidak terlalu lama di luar.',
      Color(0xFFE8C21A), Color(0xFF2B2400)),
  AqiLevel('Tidak sehat bagi kelompok sensitif', 'Penderita asma atau gangguan napas sebaiknya kurangi aktivitas di luar.',
      Color(0xFFF08A24), Color(0xFF2B1600)),
  AqiLevel('Tidak sehat', 'Kurangi aktivitas berat di luar ruangan dan pertimbangkan memakai masker.',
      Color(0xFFD64545), Colors.white),
  AqiLevel('Sangat tidak sehat', 'Hindari aktivitas di luar ruangan. Gunakan masker bila harus keluar.',
      Color(0xFF8E4FB3), Colors.white),
  AqiLevel('Berbahaya', 'Tetap di dalam ruangan dan tutup jendela.',
      Color(0xFF8A2A3F), Colors.white),
];

AqiLevel aqiLevelFor(int aqi) {
  if (aqi <= 50) return _aqiLevels[0];
  if (aqi <= 100) return _aqiLevels[1];
  if (aqi <= 150) return _aqiLevels[2];
  if (aqi <= 200) return _aqiLevels[3];
  if (aqi <= 300) return _aqiLevels[4];
  return _aqiLevels[5];
}

class AirQualityCard extends StatelessWidget {
  /// `null` berarti datanya belum tersedia.
  final AirQuality? air;

  const AirQualityCard({super.key, required this.air});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final data = air;
    final aqi = data?.usAqi;

    if (data == null || aqi == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: p.border),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off_rounded, color: p.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Data kualitas udara belum tersedia untuk lokasi ini.',
                style: TextStyle(color: p.textSecondary, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    final level = aqiLevelFor(aqi);
    final pollutants = <_Pollutant>[
      if (data.pm25 != null) _Pollutant('PM2.5', data.pm25!),
      if (data.pm10 != null) _Pollutant('PM10', data.pm10!),
      if (data.ozone != null) _Pollutant('O₃', data.ozone!),
      if (data.nitrogenDioxide != null) _Pollutant('NO₂', data.nitrogenDioxide!),
      if (data.sulphurDioxide != null) _Pollutant('SO₂', data.sulphurDioxide!),
      if (data.carbonMonoxide != null) _Pollutant('CO', data.carbonMonoxide!),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.border),
        boxShadow: p.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: level.color,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$aqi',
                      style: TextStyle(
                        color: level.onColor,
                        fontSize: 28,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'US AQI',
                      style: TextStyle(
                        color: level.onColor.withValues(alpha: 0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.label,
                      style: TextStyle(
                        color: p.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.advice,
                      style: TextStyle(
                        color: p.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _AqiScale(aqi: aqi),
          if (pollutants.isNotEmpty) ...[
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 8.0;
                final itemWidth = (constraints.maxWidth - spacing * 2) / 3;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final item in pollutants)
                      SizedBox(
                        width: itemWidth,
                        child: _PollutantTile(item: item),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Konsentrasi dalam µg/m³ · Sumber: Open-Meteo Air Quality',
              style: TextStyle(color: p.textSecondary, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pollutant {
  final String name;
  final double value;
  const _Pollutant(this.name, this.value);
}

class _PollutantTile extends StatelessWidget {
  final _Pollutant item;
  const _PollutantTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final v = item.value;
    final text = v >= 100 ? v.round().toString() : v.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: TextStyle(
              color: p.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                color: p.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skala warna 0–300 dengan penanda posisi nilai AQI saat ini.
class _AqiScale extends StatelessWidget {
  final int aqi;
  const _AqiScale({required this.aqi});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final fraction = (aqi / 300.0).clamp(0.0, 1.0).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        const marker = 16.0;
        final left = (fraction * w - marker / 2).clamp(0.0, w - marker).toDouble();

        return SizedBox(
          height: marker,
          width: w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [for (final l in _aqiLevels) l.color],
                  ),
                ),
              ),
              Positioned(
                left: left,
                child: Container(
                  width: marker,
                  height: marker,
                  decoration: BoxDecoration(
                    color: p.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: p.textPrimary, width: 3),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

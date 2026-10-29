import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../app_theme_controller.dart';
import '../viewmodels/weather_viewmodel.dart';
import 'widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showAllCities = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WeatherViewModel>().loadWeather();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Memilih kota lalu menggulir ke atas agar hasilnya langsung terlihat.
  void _selectCity(WeatherViewModel vm, CampusCity city) {
    vm.selectCity(city);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();
    final themeController = context.watch<AppThemeController>();
    final p = AppPalette.of(context);
    final filteredCities = vm.searchCities(_searchQuery);
    final visibleCities = (_showAllCities || _searchQuery.isNotEmpty)
        ? filteredCities
        : filteredCities.take(4).toList();

    return Scaffold(
      backgroundColor: p.background,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: p.backgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: p.accent,
            onRefresh: vm.loadWeather,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  children: [
                    _Header(vm: vm, themeController: themeController),
                    const SizedBox(height: 16),
                    _CityChips(
                      cities: vm.cities
                          .where((c) => _lecturerCities.contains(c.name))
                          .toList()
                        ..sort((a, b) => _lecturerCities
                            .indexOf(a.name)
                            .compareTo(_lecturerCities.indexOf(b.name))),
                      selectedName: vm.selectedCity.name,
                      onSelect: (city) => _selectCity(vm, city),
                    ),
                    const SizedBox(height: 20),
                    const CampusIllustration(),
                    const SizedBox(height: 28),
                    const SectionHeading(
                      icon: Icons.wb_sunny_rounded,
                      title: 'Cuaca kampus',
                      subtitle: 'Kondisi terkini di kota pilihanmu',
                    ),
                    const SizedBox(height: 14),
                    if (vm.isLoading && vm.weather == null)
                      const _LoadingCard()
                    else if (vm.errorMessage != null && vm.weather == null)
                      _ErrorCard(
                        message: vm.errorMessage!,
                        onRetry: vm.loadWeather,
                      )
                    else if (vm.weather != null)
                      WeatherHeroCard(
                        weather: vm.weather!,
                        subtitle: vm.selectedCity.province,
                      ),
                    if (vm.isLoading && vm.weather != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            color: p.accent,
                            backgroundColor: p.accentSoft,
                            minHeight: 4,
                          ),
                        ),
                      ),
                    if (vm.errorMessage != null && vm.weather != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _InlineErrorBanner(
                          message: vm.errorMessage!,
                          onRetry: vm.loadWeather,
                        ),
                      ),
                    if (vm.weather != null) ...[
                      const SizedBox(height: 32),
                      const SectionHeading(
                        icon: Icons.air_rounded,
                        title: 'Kualitas udara',
                        subtitle: 'Seberapa bersih udara di sekitarmu',
                      ),
                      const SizedBox(height: 14),
                      AirQualityCard(air: vm.weather!.airQuality),
                      const SizedBox(height: 32),
                      const SectionHeading(
                        icon: Icons.calendar_month_rounded,
                        title: 'Prakiraan 7 hari',
                        subtitle: 'Kondisi cuaca untuk sepekan ke depan',
                      ),
                      const SizedBox(height: 14),
                      ForecastCard(days: vm.weather!.forecast),
                    ],
                    const SizedBox(height: 32),
                    const SectionHeading(
                      icon: Icons.explore_rounded,
                      title: 'Jelajahi Indonesia',
                      subtitle: 'Lihat cuaca kota-kota lain',
                    ),
                    const SizedBox(height: 14),
                    _SearchField(
                      controller: _searchController,
                      query: _searchQuery,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      onClear: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    ),
                    const SizedBox(height: 14),
                    if (filteredCities.isEmpty)
                      const _EmptyCities()
                    else
                      _CityGrid(
                        cities: visibleCities,
                        selectedName: vm.selectedCity.name,
                        onSelect: (city) => _selectCity(vm, city),
                      ),
                    if (_searchQuery.isEmpty && filteredCities.length > 4)
                      Center(
                        child: TextButton.icon(
                          onPressed: () =>
                              setState(() => _showAllCities = !_showAllCities),
                          icon: Icon(
                            _showAllCities
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                          ),
                          label: Text(
                            _showAllCities
                                ? 'Tampilkan lebih sedikit'
                                : 'Lihat semua kota (${filteredCities.length})',
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    const _ReminderCard(),
                    const SizedBox(height: 22),
                    Center(
                      child: Text(
                        'Dibuat untuk kehidupan kampus 💚',
                        style: TextStyle(
                          fontSize: 12,
                          color: p.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bagian-bagian halaman
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final WeatherViewModel vm;
  final AppThemeController themeController;

  const _Header({required this.vm, required this.themeController});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    ButtonStyle iconStyle(Color fg) => IconButton.styleFrom(
          backgroundColor: p.surface,
          foregroundColor: fg,
          side: BorderSide(color: p.border),
        );

    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [forest, Color(0xFF2AA37F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.eco_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Udara Kampus',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: p.textPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Sedikit cerah untuk harimu',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: p.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: themeController.toggleTheme,
          tooltip:
              p.isDark ? 'Aktifkan mode terang' : 'Aktifkan mode gelap',
          style: iconStyle(p.isDark ? const Color(0xFFFFD166) : p.accent),
          icon: Icon(
            p.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          onPressed: vm.loadWeather,
          tooltip: 'Segarkan cuaca',
          style: iconStyle(p.accent),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }
}

/// Delapan kota kampus sesuai instruksi (Contoh 11), berurutan.
const List<String> _lecturerCities = [
  'Jakarta',
  'Bandung',
  'Yogyakarta',
  'Surabaya',
  'Denpasar',
  'Samarinda',
  'Makassar',
  'Medan',
];

/// Baris chip pilihan kota. Bisa digeser ke samping bila layar sempit.
class _CityChips extends StatelessWidget {
  final List<CampusCity> cities;
  final String selectedName;
  final ValueChanged<CampusCity> onSelect;

  const _CityChips({
    required this.cities,
    required this.selectedName,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final city = cities[i];
          final selected = city.name == selectedName;

          return Material(
            color: selected ? p.accent : p.surface,
            shape: StadiumBorder(
              side: BorderSide(color: selected ? p.accent : p.border),
            ),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => onSelect(city),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Center(
                  child: Text(
                    city.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: selected ? p.onAccent : p.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: TextStyle(color: p.textPrimary, fontSize: 15),
      cursorColor: p.accent,
      decoration: InputDecoration(
        hintText: 'Cari kota atau provinsi...',
        hintStyle: TextStyle(color: p.textSecondary),
        prefixIcon: Icon(Icons.search_rounded, color: p.accent),
        suffixIcon: query.isEmpty
            ? null
            : IconButton(
                onPressed: onClear,
                tooltip: 'Hapus pencarian',
                icon: Icon(Icons.close_rounded, color: p.textSecondary),
              ),
        filled: true,
        fillColor: p.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: border(p.border, 1),
        enabledBorder: border(p.border, 1),
        focusedBorder: border(p.accent, 2),
      ),
    );
  }
}

class _CityGrid extends StatelessWidget {
  final List<CampusCity> cities;
  final String selectedName;
  final ValueChanged<CampusCity> onSelect;

  const _CityGrid({
    required this.cities,
    required this.selectedName,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final columns = constraints.maxWidth >= 640 ? 2 : 1;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final city in cities)
              SizedBox(
                width: itemWidth,
                child: _CityTile(
                  city: city,
                  selected: city.name == selectedName,
                  onTap: () => onSelect(city),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CityTile extends StatelessWidget {
  final CampusCity city;
  final bool selected;
  final VoidCallback onTap;

  const _CityTile({
    required this.city,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return Material(
      color: selected ? p.accentSoft : p.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? p.accent : p.border,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: selected ? p.accent : p.surfaceAlt,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    _cityEmoji(city.name),
                    style: const TextStyle(fontSize: 23),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: p.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      city.province,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: p.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: selected ? 24 : 15,
                color: p.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _cityEmoji(String city) {
    switch (city) {
      case 'Balikpapan':
      case 'Samarinda':
      case 'Tanjung Selor':
      case 'Tarakan':
      case 'Banjarmasin':
      case 'Pontianak':
      case 'Palangka Raya':
        return '🌿';
      case 'Jakarta':
      case 'Surabaya':
      case 'Bandung':
      case 'Semarang':
        return '🏙️';
      case 'Denpasar':
      case 'Mataram':
      case 'Kupang':
        return '🌴';
      case 'Jayapura':
      case 'Ambon':
      case 'Makassar':
      case 'Manado':
        return '🌊';
      default:
        return '📍';
    }
  }
}

class _EmptyCities extends StatelessWidget {
  const _EmptyCities();

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: p.textSecondary),
          const SizedBox(height: 10),
          Text(
            'Kota tidak ditemukan. Coba kata kunci lain.',
            textAlign: TextAlign.center,
            style: TextStyle(color: p.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard();

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.accentSoft,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengingat kecil',
                  style: TextStyle(
                    color: p.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bawa botol minum, jaga lingkungan, dan tetap semangat kuliah!',
                  style: TextStyle(
                    color: p.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status memuat & galat
// ---------------------------------------------------------------------------

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: p.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: p.accent),
          const SizedBox(height: 16),
          Text(
            'Mengambil data cuaca...',
            style: TextStyle(color: p.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: p.border),
      ),
      child: Column(
        children: [
          const Text('🌧️', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: p.textPrimary, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }
}

class _InlineErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      decoration: BoxDecoration(
        color: p.warnBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.warnBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: p.warnIcon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: p.warnText, fontSize: 13),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}

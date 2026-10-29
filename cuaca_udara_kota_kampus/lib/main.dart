import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/weather_service.dart';
import 'repositories/weather_repository.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home_view.dart';
import 'app_theme.dart';
import 'app_theme_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeController()),
        Provider<WeatherService>(
          create: (_) => WeatherService(),
          dispose: (_, service) => service.close(),
        ),
        ProxyProvider<WeatherService, WeatherRepository>(
          update: (_, service, __) => OpenMeteoWeatherRepository(service: service),
        ),
        ChangeNotifierProvider<WeatherViewModel>(
          create: (context) => WeatherViewModel(repository: context.read<WeatherRepository>()),
        ),
      ],
      child: const UdaraKampusApp(),
    ),
  );
}

class UdaraKampusApp extends StatelessWidget {
  const UdaraKampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<AppThemeController>();
    return MaterialApp(
      title: 'cuaca_udara_kota_kampus',
      debugShowCheckedModeBanner: false,
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      home: const HomeView(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:portfolio_test2/core/theme.dart';
import 'package:portfolio_test2/presentation/pages/portfolio_page.dart';
import 'package:portfolio_test2/core/app_localizations.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _currentLocale = const Locale('en', '');
  final String _themeKey = 'theme_mode';
  final String _localeKey = 'locale';
  bool _isUserThemeSet = false; // 사용자가 수동으로 테마를 설정했는지 여부

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPreferences();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (!_isUserThemeSet) {
      debugPrint('System theme changed, updating app theme');
      setState(() {
        _themeMode = ThemeMode.system;
      });
    }
  }

  Locale _getSystemLocale() {
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    final isKorean = systemLocale.languageCode == 'ko';

    debugPrint('System locale: ${systemLocale.languageCode}');
    debugPrint('Selected locale: ${isKorean ? 'ko' : 'en'}');

    return isKorean ? const Locale('ko', '') : const Locale('en', '');
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final savedThemeString = prefs.getString(_themeKey);
      final savedUserThemeSet = prefs.getBool('user_theme_set') ?? false;

      if (savedThemeString != null) {
        _isUserThemeSet = savedUserThemeSet;
        switch (savedThemeString) {
          case 'light':
            _themeMode = ThemeMode.light;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            break;
          case 'system':
          default:
            _themeMode = ThemeMode.system;
            _isUserThemeSet = false;
            break;
        }
        debugPrint(
          'Loaded saved theme: $savedThemeString, userSet: $_isUserThemeSet',
        );
      } else {
        debugPrint('No saved theme found, using system theme');
        _themeMode = ThemeMode.system;
        _isUserThemeSet = false;
        _saveThemeToPrefs(_themeMode, _isUserThemeSet);
      }

      final savedLocaleCode = prefs.getString(_localeKey);
      if (savedLocaleCode != null) {
        _currentLocale = Locale(savedLocaleCode, '');
        debugPrint('Loaded saved locale: $savedLocaleCode');
      } else {
        debugPrint('No saved locale found, using system locale');
        _currentLocale = _getSystemLocale();
        _saveLocaleToPrefs(_currentLocale);
      }
    });
  }

  Future<void> _saveThemeToPrefs(ThemeMode themeMode, bool isUserSet) async {
    final prefs = await SharedPreferences.getInstance();
    String themeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
    }
    await prefs.setString(_themeKey, themeString);
    await prefs.setBool('user_theme_set', isUserSet);
  }

  Future<void> _saveLocaleToPrefs(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  void changeTheme(ThemeMode newThemeMode) {
    setState(() {
      _themeMode = newThemeMode;
      _isUserThemeSet = newThemeMode != ThemeMode.system;
    });
    _saveThemeToPrefs(_themeMode, _isUserThemeSet);
    debugPrint('Theme changed to: $_themeMode, userSet: $_isUserThemeSet');
  }

  void changeLocale(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
    _saveLocaleToPrefs(locale);
    debugPrint('Locale changed to: ${locale.languageCode}');
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    switch (_themeMode) {
      case ThemeMode.dark:
        isDarkMode = true;
        break;
      case ThemeMode.light:
        isDarkMode = false;
        break;
      case ThemeMode.system:
        isDarkMode =
            MediaQuery.platformBrightnessOf(context) == Brightness.dark;
        break;
    }

    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _currentLocale,
      home: PortfolioPage(
        isDarkMode: isDarkMode,
        themeMode: _themeMode,
        onThemeChanged: changeTheme,
        currentLocale: _currentLocale,
        onLocaleChanged: changeLocale,
      ),
    );
  }
}

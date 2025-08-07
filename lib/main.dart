import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'theme.dart';
import 'portfolio_page.dart';
import 'app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fontLoader = FontLoader('PretendardVariable')
    ..addFont(rootBundle.load('assets/fonts/PretendardVariable.woff2'));
  await fontLoader.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
    // 사용자가 수동으로 테마를 설정하지 않은 경우에만 시스템 테마 변경에 반응
    if (!_isUserThemeSet) {
      debugPrint('System theme changed, updating app theme');
      setState(() {
        // ThemeMode.system을 사용하면 Flutter가 자동으로 시스템 테마를 감지
        _themeMode = ThemeMode.system;
      });
    }
  }

  /// 시스템 언어를 확인하여 지원되는 언어 반환
  Locale _getSystemLocale() {
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    final isKorean = systemLocale.languageCode == 'ko';

    // 디버그 정보 출력
    debugPrint('System locale: ${systemLocale.languageCode}');
    debugPrint('Selected locale: ${isKorean ? 'ko' : 'en'}');

    // 시스템 언어가 한국어면 한국어, 아니면 영어
    return isKorean ? const Locale('ko', '') : const Locale('en', '');
  }

  /// 시스템 다크모드 설정을 확인하여 반환
  bool _getSystemDarkMode() {
    final brightness = ui.PlatformDispatcher.instance.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    // 디버그 정보 출력
    debugPrint('System brightness: $brightness');
    debugPrint('System dark mode: $isDarkMode');

    return isDarkMode;
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 저장된 테마 설정 확인
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
            _isUserThemeSet = false; // 시스템 테마는 사용자 설정이 아님
            break;
        }
        debugPrint(
          'Loaded saved theme: $savedThemeString, userSet: $_isUserThemeSet',
        );
      } else {
        // 첫 실행 시 시스템 테마로 설정
        debugPrint('No saved theme found, using system theme');
        _themeMode = ThemeMode.system;
        _isUserThemeSet = false;
        _saveThemeToPrefs(_themeMode, _isUserThemeSet);
      }

      // 저장된 언어 설정이 있으면 사용, 없으면 시스템 언어 확인
      final savedLocaleCode = prefs.getString(_localeKey);
      if (savedLocaleCode != null) {
        _currentLocale = Locale(savedLocaleCode, '');
        debugPrint('Loaded saved locale: $savedLocaleCode');
      } else {
        // 첫 실행 시 시스템 언어로 설정
        debugPrint('No saved locale found, using system locale');
        _currentLocale = _getSystemLocale();
        // 시스템 언어를 기본값으로 저장 (다음 실행 시 사용자가 변경했는지 알 수 있음)
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
      default:
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
    // 현재 테마 모드에 따른 다크모드 여부 계산
    bool isDarkMode;
    switch (_themeMode) {
      case ThemeMode.dark:
        isDarkMode = true;
        break;
      case ThemeMode.light:
        isDarkMode = false;
        break;
      case ThemeMode.system:
      default:
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

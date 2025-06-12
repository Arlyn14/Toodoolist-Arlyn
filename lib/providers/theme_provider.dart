import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeBoxName = 'themeBox';
  static const String _themeKey = 'isDarkMode';
  bool _isDarkMode = false;
  late Box _box;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeFromHive();
  }

  Future<void> _loadThemeFromHive() async {
    _box = await Hive.openBox(_themeBoxName);
    _isDarkMode = _box.get(_themeKey, defaultValue: false);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _box.put(_themeKey, _isDarkMode);
    notifyListeners();
  }

  ThemeData get theme => _isDarkMode ? _darkTheme : _lightTheme;

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black,
        fontSize: 45,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 21,
      ),
      displaySmall: TextStyle(
        color: Color.fromARGB(255, 234, 234, 234),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        color: Colors.grey,
        fontSize: 17,
      ),
      headlineSmall: TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
      titleSmall: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontSize: 40,
        color: Colors.black,
        fontWeight: FontWeight.w300,
      ),
    ),
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 45,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 21,
      ),
      displaySmall: TextStyle(
        color: Color.fromARGB(255, 234, 234, 234),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        color: Colors.grey,
        fontSize: 17,
      ),
      headlineSmall: TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontSize: 40,
        color: Colors.white,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}

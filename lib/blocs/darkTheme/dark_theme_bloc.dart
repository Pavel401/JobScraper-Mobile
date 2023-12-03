import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dark_theme_event.dart';
part 'dark_theme_state.dart';

class DarkThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  DarkThemeBloc() : super(SetInitialThemeState()) {
    _loadTheme();
    on<ThemeEvent>((event, emit) {
      if (event is ToggleDarkTheme) {
        _saveTheme(true);
        emit(SetDarkThemeState());
      } else if (event is ToggleLightTheme) {
        _saveTheme(false);
        emit(SetLightThemeState());
      } else if (event is ToggleInitialTheme) {
        emit(SetInitialThemeState());
      }
    });
  }

  void setDarkMode() {
    add(ToggleDarkTheme(isDarkTheme: true));
  }

  void setLightMode() {
    add(ToggleLightTheme(isLightTheme: true));
  }

  void setInitialTheme() {
    add(ToggleInitialTheme(isInitialTheme: true));
  }

  // Save the theme preference to shared preferences
  Future<void> _saveTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  // Load the theme preference from shared preferences
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    if (isDarkMode) {
      add(ToggleDarkTheme(isDarkTheme: true));
    } else {
      add(ToggleLightTheme(isLightTheme: true));
    }
  }
}

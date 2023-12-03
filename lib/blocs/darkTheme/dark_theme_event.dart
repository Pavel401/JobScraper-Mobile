part of 'dark_theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

final class ToggleDarkTheme extends ThemeEvent {
  final bool isDarkTheme;

  const ToggleDarkTheme({required this.isDarkTheme});

  @override
  List<Object> get props => [isDarkTheme];
}

final class ToggleLightTheme extends ThemeEvent {
  final bool isLightTheme;

  const ToggleLightTheme({required this.isLightTheme});

  @override
  List<Object> get props => [isLightTheme];
}

final class ToggleInitialTheme extends ThemeEvent {
  final bool isInitialTheme;

  const ToggleInitialTheme({required this.isInitialTheme});

  @override
  List<Object> get props => [isInitialTheme];
}

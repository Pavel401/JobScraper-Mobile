part of 'dark_theme_bloc.dart';

sealed class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

final class SetDarkThemeState extends ThemeState {}

final class SetLightThemeState extends ThemeState {}

final class SetInitialThemeState extends ThemeState {}

part of 'system_theme_bloc.dart';

sealed class SystemThemeEvent extends Equatable {
  const SystemThemeEvent();

  @override
  List<Object> get props => [];
}

final class SystemThemeInitial extends SystemThemeEvent {}

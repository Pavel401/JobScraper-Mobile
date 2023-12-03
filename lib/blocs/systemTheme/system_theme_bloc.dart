import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'system_theme_event.dart';
part 'system_theme_state.dart';

class SystemThemeBloc extends Bloc<SystemThemeEvent, SystemThemeState> {
  SystemThemeBloc() : super(SystemThemeInitialState()) {
    on<SystemThemeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

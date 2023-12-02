import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class NavigationEvent {}

class UpdateNavigationEvent extends NavigationEvent {
  final int selectedIndex;

  UpdateNavigationEvent(this.selectedIndex);
}

// States
abstract class NavigationState {}

class NavigationInitialState extends NavigationState {
  final int initialIndex;

  NavigationInitialState(this.initialIndex);
}

// BLoC
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitialState(0));

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is UpdateNavigationEvent) {
      yield NavigationInitialState(event.selectedIndex);
    }
  }
}

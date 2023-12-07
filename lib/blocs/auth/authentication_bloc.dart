import 'package:bloc/bloc.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_Event.dart';
import 'package:jobhunt_mobile/blocs/auth/authentication_state.dart';
import 'package:jobhunt_mobile/model/userModel.dart';
import 'package:jobhunt_mobile/services/authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService = AuthService();

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignUpUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user =
            await authService.signUpUser(event.email, event.password);

        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        print(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
    on<SignInUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user =
            await authService.signInUser(event.email, event.password);

        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('sign-in failed'));
        }
      } catch (e) {
        print(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SignOut>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        authService.signOutUser();
      } catch (e) {
        print('error');
        print(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
}
